import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../application/public_portal_flow_controller.dart';
import 'widgets/portal_choice_card.dart';
import 'widgets/selection_header.dart';

class SelectCampusScreen extends ConsumerWidget {
  const SelectCampusScreen({super.key});

  static const _campuses = <String>[
    'Kampus Demo A',
    'Kampus Demo B',
    'Kampus Demo C',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(publicPortalFlowControllerProvider);
    final controller = ref.read(publicPortalFlowControllerProvider.notifier);

    return ResponsiveScaffold(
      title: 'Pilih Kampus',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SelectionHeader(
            title: 'Pilih Kampus',
            subtitle: 'Langkah 1',
            description: 'Pengguna harus menentukan kampus terlebih dahulu sebelum melanjutkan ke jurusan.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _campuses
                .map(
                  (campus) => SizedBox(
                    width: 260,
                    child: PortalChoiceCard(
                      title: campus,
                      subtitle: 'Dipakai sebagai konteks awal login.',
                      icon: Icons.location_city_outlined,
                      selected: flow.campus == campus,
                      onTap: () => controller.selectCampus(campus),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: flow.hasCampus
                ? () => context.go(RoutePaths.selectDepartment)
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Lanjut ke Jurusan'),
          ),
        ],
      ),
    );
  }
}

