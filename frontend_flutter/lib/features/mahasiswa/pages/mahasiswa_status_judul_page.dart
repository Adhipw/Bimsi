import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/pengajuan_judul_service.dart';
import '../models/pengajuan_judul_model.dart';
import '../../../core/widgets/custom_button.dart';

class MahasiswaStatusJudulPage extends ConsumerStatefulWidget {
  const MahasiswaStatusJudulPage({super.key});

  @override
  ConsumerState<MahasiswaStatusJudulPage> createState() => _MahasiswaStatusJudulPageState();
}

class _MahasiswaStatusJudulPageState extends ConsumerState<MahasiswaStatusJudulPage> {
  PengajuanJudulModel? _pengajuan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      final fetched = await service.getStatus();
      setState(() {
        _pengajuan = fetched;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil status: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'disetujui': return const Color(0xFF4CAF50);
      case 'revisi': return const Color(0xFFFF9800);
      case 'ditolak': return const Color(0xFFF44336);
      default: return const Color(0xFF2196F3);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'disetujui': return 'DISETUJUI';
      case 'revisi': return 'BUTUH REVISI';
      case 'ditolak': return 'DITOLAK';
      default: return 'MENUNGGU VALIDASI';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Status Judul Skripsi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pengajuan == null
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _fetchStatus,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Status Card Header
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Status Pengajuan Saat Ini',
                                  style: TextStyle(color: Color(0xFF757575), fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(_pengajuan!.status).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: _getStatusColor(_pengajuan!.status), width: 1.5),
                                  ),
                                  child: Text(
                                    _getStatusLabel(_pengajuan!.status),
                                    style: TextStyle(
                                      color: _getStatusColor(_pengajuan!.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (_pengajuan!.namaPeriode != null) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    _pengajuan!.namaPeriode!,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title Detail Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Judul Skripsi Yang Diajukan',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF757575), fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _pengajuan!.judul,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Divider(),
                                ),
                                const Text(
                                  'Deskripsi / Rumusan Masalah',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF757575), fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _pengajuan!.deskripsi ?? 'Tidak ada deskripsi.',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons based on status
                        if (_pengajuan!.status == 'revisi') ...[
                          const Text(
                            'Catatan Kaprodi meminta Anda melakukan revisi terhadap judul atau deskripsi di atas. Silakan tekan tombol di bawah untuk merevisi.',
                            style: TextStyle(color: Colors.redAccent, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Revisi Judul',
                            onPressed: () {
                              context.push(
                                '/dashboard/mahasiswa/pengajuan?id=${_pengajuan!.id}&judul=${Uri.encodeComponent(_pengajuan!.judul)}&deskripsi=${Uri.encodeComponent(_pengajuan!.deskripsi ?? '')}',
                              ).then((_) => _fetchStatus());
                            },
                          ),
                        ],
                        if (_pengajuan!.status == 'ditolak') ...[
                          const Text(
                            'Pengajuan judul Anda ditolak. Silakan ajukan judul baru dengan usulan topik yang berbeda.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Ajukan Judul Baru',
                            onPressed: () {
                              context.push('/dashboard/mahasiswa/pengajuan').then((_) => _fetchStatus());
                            },
                          ),
                        ],
                      ],
                    ),
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
                color: const Color(0xFF0056A6).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late_rounded,
                color: Color(0xFF0056A6),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Pengajuan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda belum mengajukan judul skripsi untuk periode akademik ini.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Ajukan Judul Sekarang',
              onPressed: () {
                context.push('/dashboard/mahasiswa/pengajuan').then((_) => _fetchStatus());
              },
            ),
          ],
        ),
      ),
    );
  }
}
