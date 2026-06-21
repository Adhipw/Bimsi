import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class DosenRekapHonorariumPage extends ConsumerWidget {
  const DosenRekapHonorariumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaffold(
      title: 'Rekapitulasi Beban & Honorarium',
      actions: [
        CustomButton(
          text: 'Export PDF',
          icon: Icons.picture_as_pdf,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengunduh rekapitulasi dalam format PDF...')),
            );
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Aktivitas Semester Genap 2025/2026',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(24),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Column(
                      children: [
                        const Icon(Icons.group, size: 48, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text('Total Mahasiswa Bimbingan', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('12 Orang', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                        const Icon(Icons.gavel, size: 48, color: Colors.green),
                        const SizedBox(height: 8),
                        Text('Total Ujian (Penguji)', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('8 Kali', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                        const Icon(Icons.payments, size: 48, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text('Estimasi Honorarium', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('Rp 2.800.000', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Rincian Aktivitas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Jenis Aktivitas')),
                    DataColumn(label: Text('Mahasiswa')),
                    DataColumn(label: Text('Status Pencairan')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('20 Jun 2026')),
                      DataCell(Text('Penguji Sidang Skripsi')),
                      DataCell(Text('Budi Santoso (12345678)')),
                      DataCell(Text('Belum Cair', style: TextStyle(color: Colors.red))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15 Jun 2026')),
                      DataCell(Text('Bimbingan Selesai (ACC Sidang)')),
                      DataCell(Text('Siti Aminah (87654321)')),
                      DataCell(Text('Dalam Proses', style: TextStyle(color: Colors.orange))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10 Mei 2026')),
                      DataCell(Text('Penguji Proposal Skripsi')),
                      DataCell(Text('Ahmad Dahlan (11223344)')),
                      DataCell(Text('Sudah Cair', style: TextStyle(color: Colors.green))),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
