import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mahasiswa/models/riwayat_bimbingan_model.dart';
import '../../mahasiswa/services/riwayat_bimbingan_service.dart';

class DosenRiwayatBimbinganPage extends ConsumerStatefulWidget {
  const DosenRiwayatBimbinganPage({super.key});

  @override
  ConsumerState<DosenRiwayatBimbinganPage> createState() => _DosenRiwayatBimbinganPageState();
}

class _DosenRiwayatBimbinganPageState extends ConsumerState<DosenRiwayatBimbinganPage> {
  List<RiwayatBimbinganModel> _history = [];
  List<RiwayatBimbinganModel> _filteredHistory = [];
  bool _isLoading = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHistory();
    _searchController.addListener(_filterSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(riwayatBimbinganServiceProvider).getDosenRiwayat();
      setState(() {
        _history = list;
        _filteredHistory = list;
      });
      _filterSearch();
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

  void _filterSearch() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredHistory = _history;
      });
    } else {
      setState(() {
        _filteredHistory = _history.where((item) {
          final mName = item.namaMahasiswa.toLowerCase();
          final mNim = item.nimMahasiswa.toLowerCase();
          final mJudul = item.judulSkripsi.toLowerCase();
          return mName.contains(query) || mNim.contains(query) || mJudul.contains(query);
        }).toList();
      });
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
        title: const Text('Riwayat Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              child: Column(
                children: [
                  // Search bar
                  if (_history.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama mahasiswa, NIM, atau judul...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF0056A6)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF0056A6), width: 1.5),
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: _filteredHistory.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _filteredHistory.length,
                            itemBuilder: (context, index) {
                              final item = _filteredHistory[index];
                              return _buildHistoryCard(item);
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/dashboard/dosen/riwayat/input').then((value) {
            if (value == true) {
              _fetchHistory();
            }
          });
        },
        backgroundColor: const Color(0xFF0056A6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Input Riwayat', style: TextStyle(fontWeight: FontWeight.bold)),
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
            // Student & Status row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.1),
                  child: Text(
                    item.namaMahasiswa.isNotEmpty ? item.namaMahasiswa[0].toUpperCase() : 'M',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0056A6)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaMahasiswa,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: ${item.nimMahasiswa} â€¢ Kelas: ${item.kelasMahasiswa}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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

            // Meeting Details
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 15, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Bimbingan: ${item.tanggalBimbingan} | ${item.slotWaktu}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 15, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Diinput pada: ${item.createdAt}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Catatan Dosen (Revisi) Section
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
                      Icon(Icons.rate_review_rounded, size: 14, color: Color(0xFF0056A6)),
                      SizedBox(width: 6),
                      Text(
                        'Catatan Bimbingan & Revisi Dosen:',
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
            Text(
              _searchController.text.isNotEmpty
                  ? 'Tidak ditemukan riwayat bimbingan dengan kata pencarian tersebut.'
                  : 'Anda belum pernah mencatat riwayat konsultasi skripsi bimbingan mahasiswa.',
              style: const TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
