import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pembimbing_service.dart';
import '../models/pembimbing_model.dart';
 
class MahasiswaPembimbingPage extends ConsumerStatefulWidget {
  const MahasiswaPembimbingPage({super.key});
 
  @override
  ConsumerState<MahasiswaPembimbingPage> createState() => _MahasiswaPembimbingPageState();
}
 
class _MahasiswaPembimbingPageState extends ConsumerState<MahasiswaPembimbingPage> {
  List<PembimbingModel> _pembimbingList = [];
  bool _isLoading = false;
 
  @override
  void initState() {
    super.initState();
    _fetchPembimbing();
  }
 
  Future<void> _fetchPembimbing() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(pembimbingServiceProvider);
      final list = await service.getMahasiswaPembimbing();
      setState(() {
        _pembimbingList = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil pembimbing: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  Color _getRoleColor(String role) {
    if (role == 'Pembimbing 1') {
      return const Color(0xFF0056A6); // Blue
    }
    return const Color(0xFF4CAF50); // Green
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Dosen Pembimbing', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPembimbing,
              child: _pembimbingList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pembimbingList.length,
                      itemBuilder: (context, index) {
                        final p = _pembimbingList[index];
                        return _buildPembimbingCard(p);
                      },
                    ),
            ),
    );
  }
 
  Widget _buildPembimbingCard(PembimbingModel p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Badge (Pembimbing 1 / 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(p.peran).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getRoleColor(p.peran), width: 1.5),
                  ),
                  child: Text(
                    p.peran.toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(p.peran),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'AKTIF',
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Profile & Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _getRoleColor(p.peran).withValues(alpha: 0.08),
                  child: Icon(Icons.person, color: _getRoleColor(p.peran), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.namaDosen ?? 'Nama Dosen',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIDN: ${p.nidnDosen ?? "-"}',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Jabatan: ${p.jabatanDosen ?? "-"}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (p.bidangKeahlian.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              const Text(
                'Bidang Keahlian / Kompetensi:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: p.bidangKeahlian.map((bk) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF0056A6).withValues(alpha: 0.15), width: 0.5),
                    ),
                    child: Text(
                      bk,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0056A6), fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
 
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_ind_rounded,
                color: Color(0xFF0056A6),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Pembimbing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dosen pembimbing skripsi Anda belum dialokasikan oleh Ketua Program Studi. Silakan pantau berkala atau hubungi pihak Kaprodi.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
