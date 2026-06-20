import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../application/public_portal_flow_controller.dart';
import 'widgets/portal_choice_card.dart';
import 'widgets/selection_header.dart';

class SelectPeriodScreen extends ConsumerWidget {
  const SelectPeriodScreen({super.key});

  static const _periods = <String>[
    '2025/2026 - Ganjil',
    '2025/2026 - Genap',
    '2026/2027 - Ganjil',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(publicPortalFlowControllerProvider);
    final controller = ref.read(publicPortalFlowControllerProvider.notifier);

    return ResponsiveScaffold(
      title: 'Pilih Periode Skripsi',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionHeader(
            title: 'Pilih Periode Skripsi',
            subtitle: 'Langkah 3',
            description: flow.hasDepartment
                ? 'Jurusan terpilih: ${flow.department}. Sekarang pilih periode skripsi aktif.'
                : 'Pilih jurusan terlebih dahulu sebelum memilih periode.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _periods
                .map(
                  (period) => SizedBox(
                    width: 260,
                    child: PortalChoiceCard(
                      title: period,
                      subtitle: 'Menentukan konteks transaksi dan progres.',
                      icon: Icons.event_note_outlined,
                      selected: flow.period == period,
                      onTap: flow.hasDepartment ? () => controller.selectPeriod(period) : () {},
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: flow.hasPeriod ? () => context.go(RoutePaths.selectPortal) : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Lanjut ke Portal'),
          ),
        ],
      ),
    );
  }
}

