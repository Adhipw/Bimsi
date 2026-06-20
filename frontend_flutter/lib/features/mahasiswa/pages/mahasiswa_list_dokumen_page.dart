import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/dokumen_skripsi_model.dart';
import '../services/dokumen_service.dart';

class MahasiswaListDokumenPage extends ConsumerStatefulWidget {
  const MahasiswaListDokumenPage({super.key});

  @override
  ConsumerState<MahasiswaListDokumenPage> createState() => _MahasiswaListDokumenPageState();
}

class _MahasiswaListDokumenPageState extends ConsumerState<MahasiswaListDokumenPage> {
  List<DokumenSkripsiModel> _uploadedDocs = [];
  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'value': 'proposal', 'label': 'Proposal Skripsi'},
    {'value': 'bab1', 'label': 'BAB I (Pendahuluan)'},
    {'value': 'bab2', 'label': 'BAB II (Tinjauan Pustaka)'},
    {'value': 'bab3', 'label': 'BAB III (Metodologi)'},
    {'value': 'bab4', 'label': 'BAB IV (Hasil & Pembahasan)'},
    {'value': 'bab5', 'label': 'BAB V (Penutup)'},
    {'value': 'final', 'label': 'Laporan Akhir (Final)'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(dokumenServiceProvider).getMahasiswaDokumen();
      setState(() {
        _uploadedDocs = list;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat dokumen: ${e.toString().replaceAll('Exception: ', '')}'),
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
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50); // Green
      case 'rejected':
        return const Color(0xFFF44336); // Red
      case 'revisi':
        return const Color(0xFFFF9800); // Orange
      default:
        return Colors.blue; // Pending review
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'revisi':
        return 'Butuh Revisi';
      default:
        return 'Menunggu Review';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Dokumen Skripsi Saya', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchDocuments,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  // Find if student has uploaded this category
                  final uploaded = _uploadedDocs.where((doc) => doc.jenisDokumen == cat['value']);
                  
                  if (uploaded.isNotEmpty) {
                    return _buildUploadedCard(uploaded.first);
                  } else {
                    return _buildEmptyCard(cat['value']!, cat['label']!);
                  }
                },
              ),
            ),
    );
  }

  Widget _buildUploadedCard(DokumenSkripsiModel doc) {
    final latestVer = doc.versiDokumens.first; // Already sorted descending in model

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        key: PageStorageKey<int>(doc.id),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0056A6).withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.description_rounded, color: Color(0xFF0056A6), size: 24),
        ),
        title: Text(
          doc.jenisDokumenLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A1A)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(doc.latestStatus).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusLabel(doc.latestStatus),
                    style: TextStyle(
                      color: _getStatusColor(doc.latestStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Versi: ${doc.latestVersionNumber}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // File URL Link card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Berkas Terakhir:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doc.latestFileUrl,
                              style: const TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 18),
                        tooltip: 'Salin Link Berkas',
                        onPressed: () {
                          // Copy link
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link berkas disalin ke clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Last revision notes from student
                if (latestVer.catatanRevisi != null) ...[
                  const Text('Catatan Pengiriman Anda:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    latestVer.catatanRevisi!,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Lecturer review comments section
                if (latestVer.reviewDokumens.isNotEmpty) ...[
                  const Text('Review Pembimbing:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(latestVer.status).withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor(latestVer.status).withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              latestVer.reviewDokumens.first.namaDosen ?? 'Pembimbing',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              latestVer.reviewDokumens.first.createdAt,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          latestVer.reviewDokumens.first.komentar,
                          style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF444444)),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.hourglass_empty, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Berkas menunggu ulasan / verifikasi dari Dosen Pembimbing Anda.',
                            style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // Button upload new version
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/dashboard/mahasiswa/dokumen/upload?jenis=${doc.jenisDokumen}').then((val) {
                        if (val == true) {
                          _fetchDocuments();
                        }
                      });
                    },
                    icon: const Icon(Icons.upload_file_rounded, size: 16),
                    label: const Text('Unggah Versi Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056A6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String jenis, String label) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.upload_file_outlined, color: Colors.grey.shade400, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Belum ada berkas yang diunggah.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/dashboard/mahasiswa/dokumen/upload?jenis=$jenis').then((val) {
                  if (val == true) {
                    _fetchDocuments();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.08),
                foregroundColor: const Color(0xFF0056A6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Unggah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
