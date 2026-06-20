import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/models/dokumen_skripsi_model.dart';
import '../../mahasiswa/services/dokumen_service.dart';
import '../../../core/widgets/custom_text_field.dart';

class DosenReviewDokumenPage extends ConsumerStatefulWidget {
  const DosenReviewDokumenPage({super.key});

  @override
  ConsumerState<DosenReviewDokumenPage> createState() => _DosenReviewDokumenPageState();
}

class _DosenReviewDokumenPageState extends ConsumerState<DosenReviewDokumenPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DokumenSkripsiModel> _documents = [];
  bool _isLoading = false;
  bool _isSavingReview = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDocuments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(dokumenServiceProvider).getDosenDokumen();
      setState(() {
        _documents = list;
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

  Future<void> _showReviewDialog(int versiDokumenId, String docLabel) async {
    final formKey = GlobalKey<FormState>();
    final komentarController = TextEditingController();
    String selectedStatus = 'approved'; // 'approved', 'revisi', 'rejected'

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text('Review $docLabel', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Keputusan Kelayakan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'approved', child: Text('Setujui (Lulus Bab)')),
                          DropdownMenuItem(value: 'revisi', child: Text('Perlu Revisi')),
                          DropdownMenuItem(value: 'rejected', child: Text('Tolak Dokumen')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedStatus = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Komentar & Catatan Ulasan *',
                        controller: komentarController,
                        hint: 'Tulis arahan bimbingan revisi atau rincian persetujuan Anda...',
                        maxLines: 4,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Komentar wajib diisi';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, false),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogCtx, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056A6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Kirim Review', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );

    if (save == true) {
      setState(() {
        _isSavingReview = true;
      });

      try {
        await ref.read(dokumenServiceProvider).reviewDokumen(
              versiDokumenId: versiDokumenId,
              komentar: komentarController.text.trim(),
              status: selectedStatus,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review dokumen berhasil dikirim!'), backgroundColor: Colors.green),
          );
        }
        _fetchDocuments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim review: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSavingReview = false;
          });
        }
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
      case 'revisi':
        return const Color(0xFFFF9800);
      default:
        return Colors.blue;
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
    final pendingDocs = _documents.where((d) => d.latestStatus == 'pending').toList();
    final reviewedDocs = _documents.where((d) => d.latestStatus != 'pending').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Review Dokumen Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Menunggu Review', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (pendingDocs.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${pendingDocs.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(child: Text('Sudah Direview', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: _isLoading || _isSavingReview
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDocumentList(pendingDocs, isPending: true),
                _buildDocumentList(reviewedDocs, isPending: false),
              ],
            ),
    );
  }

  Widget _buildDocumentList(List<DokumenSkripsiModel> list, {required bool isPending}) {
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchDocuments,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPending ? Icons.rate_review_outlined : Icons.checklist_rtl_rounded,
                    color: const Color(0xFF0056A6),
                    size: 56,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isPending ? 'Tidak Ada Dokumen Menunggu' : 'Histori Review Kosong',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 8),
                Text(
                  isPending
                      ? 'Saat ini tidak ada mahasiswa bimbingan yang mengunggah dokumen baru.'
                      : 'Belum ada dokumen bimbingan mahasiswa yang selesai Anda review.',
                  style: const TextStyle(color: Color(0xFF757575), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchDocuments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final doc = list[index];
          return _buildDocumentCard(doc, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildDocumentCard(DokumenSkripsiModel doc, {required bool isPending}) {
    final latestVer = doc.versiDokumens.first;

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
          child: const Icon(Icons.folder_shared_rounded, color: Color(0xFF0056A6), size: 24),
        ),
        title: Text(
          doc.namaMahasiswa ?? 'Mahasiswa',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A1A)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${doc.jenisDokumenLabel} (Versi ${doc.latestVersionNumber})',
              style: const TextStyle(fontSize: 12, color: Color(0xFF555555), fontWeight: FontWeight.w500),
            ),
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
                  'NIM: ${doc.nimMahasiswa ?? "-"}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                // Info Judul Skripsi
                if (doc.judulSkripsi != null) ...[
                  const Text('Judul Skripsi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    doc.judulSkripsi!,
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF555555)),
                  ),
                  const SizedBox(height: 14),
                ],

                // Link Berkas download card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.file_present_rounded, color: Color(0xFF0056A6), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unduh Berkas Mahasiswa:',
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
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: 'Salin Link Berkas',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link berkas disalin ke clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Student Upload Note
                if (latestVer.catatanRevisi != null) ...[
                  const Text('Catatan Pengiriman Mahasiswa:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    latestVer.catatanRevisi!,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                  ),
                  const SizedBox(height: 14),
                ],

                // Display previous review comments if already reviewed
                if (latestVer.reviewDokumens.isNotEmpty) ...[
                  const Text('Ulasan Anda Sebelumnya:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                            const Text(
                              'Anda (Pembimbing)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                  const SizedBox(height: 16),
                ],

                // Action Review button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _showReviewDialog(latestVer.id, '${doc.jenisDokumenLabel} (V${latestVer.versi})'),
                    icon: const Icon(Icons.rate_review_rounded, size: 16),
                    label: Text(isPending ? 'Berikan Review' : 'Perbarui Review'),
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
}
