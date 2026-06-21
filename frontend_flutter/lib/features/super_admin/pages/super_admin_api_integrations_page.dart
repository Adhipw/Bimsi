import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class SuperAdminApiIntegrationsPage extends ConsumerStatefulWidget {
  const SuperAdminApiIntegrationsPage({super.key});

  @override
  ConsumerState<SuperAdminApiIntegrationsPage> createState() => _SuperAdminApiIntegrationsPageState();
}

class _SuperAdminApiIntegrationsPageState extends ConsumerState<SuperAdminApiIntegrationsPage> {
  final Map<String, bool> _syncStatus = {
    'mahasiswa': false,
    'dosen': false,
    'matakuliah': false,
    'nilai': false,
  };

  final Map<String, String> _lastSync = {
    'mahasiswa': '12 jam lalu',
    'dosen': '1 hari lalu',
    'matakuliah': '1 minggu lalu',
    'nilai': '3 jam lalu',
  };

  void _syncData(String module) async {
    setState(() => _syncStatus[module] = true);
    
    // Simulate network delay for syncing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _syncStatus[module] = false;
        _lastSync[module] = 'Baru saja';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sinkronisasi data $module berhasil.')),
      );
    }
  }

  Widget _buildSyncCard(String title, String key, IconData icon) {
    final isSyncing = _syncStatus[key] ?? false;
    final lastSyncTime = _lastSync[key] ?? 'Belum pernah';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Terakhir Sync: $lastSyncTime', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: isSyncing
                ? const Center(child: CircularProgressIndicator())
                : OutlinedButton.icon(
                    onPressed: () => _syncData(key),
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync Now'),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'API Integrations (SIAKAD)',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen Sinkronisasi Data SIAKAD',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tarik data master terbaru secara langsung dari sistem SIAKAD kampus utama. Anda dapat memicu sinkronisasi secara manual per modul data.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            Text(
              'Konfigurasi API Endpoint',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'SIAKAD Base URL',
                        border: OutlineInputBorder(),
                        hintText: 'https://siakad.ubsi.ac.id/api/v1',
                      ),
                      controller: TextEditingController(text: 'https://siakad.ubsi.ac.id/api/v1'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: 'Ubah URL',
                    icon: Icons.edit,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fungsi ubah URL disimulasikan.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Modul Sinkronisasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width > 800 ? 400 : double.infinity,
                mainAxisExtent: 160,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSyncCard('Data Mahasiswa Aktif', 'mahasiswa', Icons.people_outline),
                _buildSyncCard('Data Dosen', 'dosen', Icons.school_outlined),
                _buildSyncCard('Jadwal & Mata Kuliah', 'matakuliah', Icons.calendar_month_outlined),
                _buildSyncCard('Transkrip & Nilai', 'nilai', Icons.grade_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
