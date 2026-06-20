import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/sidang_provider.dart';
import '../models/pendaftaran_sidang_model.dart';
import '../../../core/services/api_client.dart';

class MahasiswaPendaftaranSidangPage extends ConsumerStatefulWidget {
  const MahasiswaPendaftaranSidangPage({super.key});

  @override
  ConsumerState<MahasiswaPendaftaranSidangPage> createState() => _MahasiswaPendaftaranSidangPageState();
}

class _MahasiswaPendaftaranSidangPageState extends ConsumerState<MahasiswaPendaftaranSidangPage> {
  final _jenisSidangController = TextEditingController();
  final _fileSyaratController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sidangState = ref.watch(pendaftaranSidangListProvider);
    final submitState = ref.watch(submitPendaftaranSidangProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Pendaftaran Sidang', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A), // Indigo-900
        elevation: 0,
        centerTitle: true,
      ),
      body: sidangState.when(
        data: (list) {
          final hasPendaftaran = list.isNotEmpty;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasPendaftaran) ...[
                  Text(
                    'Riwayat Pendaftaran',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return _buildStatusCard(item);
                    },
                  ),
                  const SizedBox(height: 32),
                ],

                Text(
                  'Ajukan Pendaftaran Sidang',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: _jenisSidangController,
                        decoration: InputDecoration(
                          labelText: 'Jenis Sidang (sempro/akhir)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _fileSyaratController,
                        decoration: InputDecoration(
                          labelText: 'URL File Persyaratan',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB), // Blue-600
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: submitState.isLoading ? null : () => _submitForm(context),
                          child: submitState.isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                              : Text('Kirim Pendaftaran', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusCard(PendaftaranSidangModel item) {
    Color statusColor;
    switch (item.status) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sidang ${item.jenisSidang.toUpperCase()}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(item.accPembimbing ? Icons.check_circle : Icons.hourglass_empty, 
                        color: item.accPembimbing ? Colors.green : Colors.grey, size: 16),
                      const SizedBox(width: 6),
                      Text(item.accPembimbing ? 'ACC Dosen' : 'Menunggu ACC',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: GoogleFonts.inter(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              )
            ],
          ),
          if (item.status == 'approved' && item.turnitinStatus != 'approved') ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showTurnitinDialog(item),
              icon: const Icon(Icons.upload_file),
              label: Text(item.turnitinStatus == 'pending' ? 'Update Bukti Turnitin (Sedang Di-review)' : 'Upload Bukti Turnitin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981), // Emerald-500
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showTurnitinDialog(PendaftaranSidangModel item) {
    final _scoreController = TextEditingController(text: item.turnitinScore?.toString());
    final _urlController = TextEditingController(text: item.turnitinFileUrl);
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Upload Hasil Turnitin'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Skor Turnitin (0-100)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(labelText: 'URL File Bukti Turnitin'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : () async {
                    setState(() => _isSubmitting = true);
                    try {
                      final apiClient = ref.read(apiClientProvider);
                      await apiClient.dio.post('/mahasiswa/pendaftaran-sidang/${item.id}/turnitin', data: {
                        'turnitin_score': int.parse(_scoreController.text),
                        'turnitin_file_url': _urlController.text,
                      });
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ref.invalidate(pendaftaranSidangListProvider);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turnitin berhasil diunggah!')));
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        setState(() => _isSubmitting = false);
                      }
                    }
                  },
                  child: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Simpan'),
                )
              ],
            );
          }
        );
      }
    );
  }

  void _submitForm(BuildContext context) {
    // In a real app, you'd fetch the user's active IDs
    ref.read(submitPendaftaranSidangProvider.notifier).submit(
      mahasiswaId: 1, // Placeholder
      pengajuanJudulId: 1, // Placeholder
      jenisSidang: _jenisSidangController.text,
      fileSyaratUrl: _fileSyaratController.text,
    ).then((_) {
      ref.refresh(pendaftaranSidangListProvider);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil dikirim!')));
    });
  }
}
