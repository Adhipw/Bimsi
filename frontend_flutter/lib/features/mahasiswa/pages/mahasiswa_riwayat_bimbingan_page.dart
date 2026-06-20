import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/models/riwayat_bimbingan_model.dart';
import '../../mahasiswa/services/riwayat_bimbingan_service.dart';

class MahasiswaRiwayatBimbinganPage extends ConsumerStatefulWidget {
  const MahasiswaRiwayatBimbinganPage({super.key});

  @override
  ConsumerState<MahasiswaRiwayatBimbinganPage> createState() => _MahasiswaRiwayatBimbinganPageState();
}

class _MahasiswaRiwayatBimbinganPageState extends ConsumerState<MahasiswaRiwayatBimbinganPage> {
  List<RiwayatBimbinganModel> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(riwayatBimbinganServiceProvider).getMahasiswaRiwayat();
      setState(() {
        _history = list;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat riwayat bimbingan: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'revisi') {
      return const Color(0xFFF44336); // Red for revisi
    }
    return const Color(0xFF4CAF50); // Green for selesai
  }

  String _getStatusLabel(String status) {
    if (status == 'revisi') {
      return 'Butuh Revisi';
    }
    return 'Lanjut / Selesai';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Buku Konsultasi Skripsi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              child: _history.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final item = _history[index];
                        return _buildHistoryCard(item);
                      },
                    ),
            ),
    );
  }

  Widget _buildHistoryCard(RiwayatBimbinganModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lecturer & Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0056A6).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded, color: Color(0xFF0056A6), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaDosen,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A1A)),
                      ),
                      const Text(
                        'Dosen Pembimbing',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusLabel(item.status),
                    style: TextStyle(
                      color: _getStatusColor(item.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Time and dates
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 15, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Tanggal: ${item.tanggalBimbingan} | ${item.slotWaktu}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 15, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Dicatat pada: ${item.createdAt}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dosen Feedback Notes Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.feedback_rounded, size: 14, color: Color(0xFF0056A6)),
                      SizedBox(width: 6),
                      Text(
                        'Catatan & Arahan Revisi Dosen:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.catatanDosen,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF444444)),
                  ),
                ],
              ),
            ),

            if (item.catatanMahasiswa != null && item.catatanMahasiswa!.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan Mahasiswa:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.catatanMahasiswa!,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                    ),
                  ],
                ),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_edu_outlined,
                color: Color(0xFF0056A6),
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Riwayat Bimbingan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dosen pembimbing Anda belum mencatat riwayat konsultasi skripsi bimbingan Anda.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
