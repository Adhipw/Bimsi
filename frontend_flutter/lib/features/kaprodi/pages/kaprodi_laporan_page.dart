import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../services/laporan_service.dart';

class KaprodiLaporanPage extends ConsumerStatefulWidget {
  const KaprodiLaporanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<KaprodiLaporanPage> createState() => _KaprodiLaporanPageState();
}

class _KaprodiLaporanPageState extends ConsumerState<KaprodiLaporanPage> {
  bool _isLoading = false;

  void _export(String type) async {
    setState(() => _isLoading = true);
    try {
      final _laporanService = ref.read(laporanServiceProvider);
      await _laporanService.exportLaporan(type);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Laporan $type berhasil di-generate dan siap diunduh')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Skripsi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: AppCard(
            padding: const EdgeInsets.all(32),
            child: _isLoading 
              ? const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.analytics_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 24),
                    Text('Laporan Skripsi', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Unduh laporan rekapitulasi data skripsi mahasiswa dalam format PDF atau Excel.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _export('pdf'),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Export PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _export('excel'),
                            icon: const Icon(Icons.table_view),
                            label: const Text('Export Excel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
