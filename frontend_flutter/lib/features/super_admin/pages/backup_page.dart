import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../../core/services/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

final backupsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/backups');
  if (response.data is Map && response.data.containsKey('data')) {
    return response.data['data'] as List<dynamic>;
  }
  return response.data as List<dynamic>;
});

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _isBackingUp = false;

  Future<void> _runBackup() async {
    setState(() => _isBackingUp = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post('/backups/run');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup berhasil dijalankan')),
        );
        ref.invalidate(backupsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menjalankan backup: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isBackingUp = false);
    }
  }

  void _downloadBackup(String disk, String file) async {
    final api = ref.read(apiClientProvider);
    final url = Uri.parse('${api.baseUrl}/backups/download?disk=$disk&file=$file');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat mengunduh file')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backupsAsync = ref.watch(backupsProvider);

    return ResponsiveScaffold(
      title: 'Manajemen Backup & Logs',
      body: backupsAsync.when(
        data: (backups) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar File Backup',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: _isBackingUp ? null : _runBackup,
                      icon: _isBackingUp 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.backup),
                      label: const Text('Buat Backup Baru'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: backups.isEmpty
                    ? const Center(child: Text('Belum ada file backup'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: backups.length,
                        itemBuilder: (context, index) {
                          final backup = backups[index];
                          final disk = backup['disk'] ?? 'local';
                          final file = backup['file'] ?? '';
                          final size = backup['size'] ?? 0;
                          final date = backup['date'] ?? '';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: const Icon(Icons.folder_zip, size: 40, color: Colors.blue),
                              title: Text(file),
                              subtitle: Text('Disk: $disk | Size: ${(size / 1024 / 1024).toStringAsFixed(2)} MB | Date: $date'),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                tooltip: 'Download',
                                onPressed: () => _downloadBackup(disk, file),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
