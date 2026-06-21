import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../../core/services/api_client.dart';

final settingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/settings');
  
  final List data;
  if (response.data is Map && response.data.containsKey('data')) {
    data = response.data['data'] as List;
  } else {
    data = response.data as List;
  }
  
  return {for (var e in data) e['key']: e['value']};
});

class SystemSettingsPage extends ConsumerStatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  ConsumerState<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends ConsumerState<SystemSettingsPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isSaving = false;

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSettings(String key, String value) async {
    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.put('/settings', data: {
        'settings': {
          key: value,
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pengaturan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return ResponsiveScaffold(
      title: 'Pengaturan Sistem',
      body: settingsAsync.when(
        data: (settings) {
          // Initialize controllers if empty
          if (_controllers.isEmpty) {
            for (var entry in settings.entries) {
              _controllers[entry.key] = TextEditingController(text: entry.value?.toString());
            }
          }

          // Define known settings for UI
          final settingsUI = [
            {'key': 'registration_open', 'label': 'Pendaftaran Sidang Dibuka (true/false)', 'type': 'boolean'},
            {'key': 'max_students_per_lecturer', 'label': 'Maksimal Kuota Mahasiswa per Dosen', 'type': 'number'},
            {'key': 'current_academic_year', 'label': 'Tahun Akademik Berjalan', 'type': 'text'},
            {'key': 'system_maintenance', 'label': 'Mode Maintenance (true/false)', 'type': 'boolean'},
          ];

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: settingsUI.length,
            itemBuilder: (context, index) {
              final item = settingsUI[index];
              final key = item['key']!;
              final label = item['label']!;
              
              if (!_controllers.containsKey(key)) {
                _controllers[key] = TextEditingController(text: settings[key]?.toString() ?? '');
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[key],
                          decoration: InputDecoration(
                            labelText: label,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSaving ? null : () => _saveSettings(key, _controllers[key]!.text),
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
