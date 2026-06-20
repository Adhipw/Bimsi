import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../services/turnitin_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminTurnitinPage extends ConsumerStatefulWidget {
  const AdminTurnitinPage({super.key});

  @override
  ConsumerState<AdminTurnitinPage> createState() => _AdminTurnitinPageState();
}

class _AdminTurnitinPageState extends ConsumerState<AdminTurnitinPage> {
  bool _isLoading = false;

  void _verifikasi(int sidangId, String status) async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(turnitinServiceProvider);
      await service.verifikasi(sidangId, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status Turnitin diubah menjadi $status')));
        ref.invalidate(turnitinMenungguProvider);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _downloadFile(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka URL')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(turnitinMenungguProvider);

    return ResponsiveScaffold(
      title: 'Verifikasi Turnitin',
      body: asyncData.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('Tidak ada dokumen Turnitin yang menunggu verifikasi.'));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final sidang = list[index];
              final mhs = sidang['mahasiswa']['user']['name'];
              final judul = sidang['pengajuan_judul']['judul'];
              final score = sidang['turnitin_score'];
              final fileUrl = sidang['turnitin_file_url'];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mhs, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(judul, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text('Skor Plagiarisme: ${score ?? '-'}%', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.orange)),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _downloadFile(fileUrl),
                        icon: const Icon(Icons.download),
                        label: const Text('Download Dokumen'),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: _isLoading ? null : () => _verifikasi(sidang['id'], 'approved'),
                        icon: const Icon(Icons.check),
                        style: FilledButton.styleFrom(backgroundColor: Colors.green),
                        label: const Text('Terima'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _isLoading ? null : () => _verifikasi(sidang['id'], 'rejected'),
                        icon: const Icon(Icons.close),
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        label: const Text('Tolak'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
