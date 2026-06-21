import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class KaprodiAnalyticsPage extends ConsumerWidget {
  const KaprodiAnalyticsPage({super.key});

  Widget _buildBarChartMockup(BuildContext context, String title, List<Map<String, dynamic>> data) {
    double maxVal = data.fold(0.0, (max, e) => (e['value'] as int) > max ? (e['value'] as int).toDouble() : max);

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.map((item) {
                double heightRatio = maxVal > 0 ? (item['value'] / maxVal) : 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${item['value']}'),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 150 * heightRatio,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(item['label'], style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distribusiBeban = [
      {'label': 'Dosen A', 'value': 8},
      {'label': 'Dosen B', 'value': 12},
      {'label': 'Dosen C', 'value': 5},
      {'label': 'Dosen D', 'value': 10},
      {'label': 'Dosen E', 'value': 15}, // Overloaded
    ];

    final kelulusanAngkatan = [
      {'label': '2022', 'value': 85}, // percentage
      {'label': '2023', 'value': 78},
      {'label': '2024', 'value': 90},
      {'label': '2025', 'value': 40}, // ongoing
    ];

    return ResponsiveScaffold(
      title: 'Analytics & Statistik Prodi',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Analitik',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pantau metrik utama seperti distribusi beban dosen pembimbing dan statistik kelulusan tepat waktu.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            
            // Highlight Cards
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(24),
                    color: Colors.blue.withOpacity(0.1),
                    child: Column(
                      children: [
                        const Text('Total Mahasiswa Aktif Skripsi', textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('145', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(24),
                    color: Colors.green.withOpacity(0.1),
                    child: Column(
                      children: [
                        const Text('Tingkat Kelulusan Tepat Waktu', textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('78%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(24),
                    color: Colors.orange.withOpacity(0.1),
                    child: Column(
                      children: [
                        const Text('Dosen Overload (>10 Mhs)', textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('3 Dosen', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Charts
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBarChartMockup(context, 'Distribusi Beban Mahasiswa Bimbingan', distribusiBeban),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _buildBarChartMockup(context, 'Tingkat Kelulusan per Angkatan (%)', kelulusanAngkatan),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
