import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/analytics_service.dart';
import '../../../core/widgets/kpi_grid_card.dart';

class KaprodiAnalyticsWidget extends ConsumerWidget {
  const KaprodiAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(kaprodiAnalyticsProvider);

    return analyticsAsync.when(
      data: (data) {
        final topDosen = data['top_dosen_load'] as List<dynamic>;
        final statusPengajuan = data['status_pengajuan'] as List<dynamic>;
        final avgDuration = data['avg_duration'] as String;
        
        int pending = 0;
        int approved = 0;
        int rejected = 0;

        for (var item in statusPengajuan) {
          if (item['status'] == 'pending') pending = item['total'];
          if (item['status'] == 'disetujui') approved = item['total'];
          if (item['status'] == 'ditolak') rejected = item['total'];
        }

        int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 
                             MediaQuery.of(context).size.width > 800 ? 2 : 1;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Pengajuan Judul',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 120,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                KpiGridCard(
                  title: 'Menunggu Persetujuan',
                  value: pending.toString(),
                  icon: Icons.hourglass_empty,
                  color: Colors.orange,
                ),
                KpiGridCard(
                  title: 'Judul Disetujui',
                  value: approved.toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
                KpiGridCard(
                  title: 'Judul Ditolak',
                  value: rejected.toString(),
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                ),
                KpiGridCard(
                  title: 'Rata-rata Lulus',
                  value: avgDuration,
                  icon: Icons.timer_outlined,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Dashboard Analitik Dosen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top 5 Beban Dosen Pembimbing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 15,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() >= topDosen.length) return const SizedBox.shrink();
                                  final name = topDosen[value.toInt()]['nama'].toString();
                                  // take first name
                                  final shortName = name.split(' ').first;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(shortName, style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 5,
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(topDosen.length, (index) {
                            final load = topDosen[index]['beban'] as int;
                            final quota = topDosen[index]['kuota'] as int;
                            final isOverload = load > quota && quota > 0;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: load.toDouble(),
                                  color: isOverload ? Colors.red : Colors.blue,
                                  width: 22,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Gagal memuat analitik: $e')),
    );
  }
}
