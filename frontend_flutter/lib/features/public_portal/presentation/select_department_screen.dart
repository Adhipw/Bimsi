import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../application/public_portal_flow_controller.dart';
import 'widgets/portal_choice_card.dart';
import 'widgets/selection_header.dart';

class SelectDepartmentScreen extends ConsumerWidget {
  const SelectDepartmentScreen({super.key});

  static const _departments = <String>[
    'Teknik Informatika',
    'Sistem Informasi',
    'Manajemen Informatika',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(publicPortalFlowControllerProvider);
    final controller = ref.read(publicPortalFlowControllerProvider.notifier);

    return ResponsiveScaffold(
      title: 'Pilih Jurusan / Program Studi',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionHeader(
            title: 'Pilih Jurusan / Program Studi',
            subtitle: 'Langkah 2',
            description: flow.hasCampus
                ? 'Kampus terpilih: ${flow.campus}. Sekarang pilih jurusan sebelum masuk ke portal.'
                : 'Pilih kampus terlebih dahulu sebelum menentukan jurusan.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _departments
                .map(
                  (department) => SizedBox(
                    width: 260,
                    child: PortalChoiceCard(
                      title: department,
                      subtitle: 'Membatasi akses dan konteks data.',
                      icon: Icons.school_outlined,
                      selected: flow.department == department,
                      onTap: flow.hasCampus ? () => controller.selectDepartment(department) : () {},
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: flow.hasDepartment
                ? () => context.go(RoutePaths.selectPeriod)
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Lanjut ke Periode'),
          ),
        ],
      ),
    );
  }
}

