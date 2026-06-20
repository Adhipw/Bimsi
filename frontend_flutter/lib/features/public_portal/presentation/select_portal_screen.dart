import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../application/public_portal_flow_controller.dart';
import 'widgets/portal_choice_card.dart';

class SelectPortalScreen extends ConsumerWidget {
  const SelectPortalScreen({super.key});

  static const _portals = <_PortalTarget>[
    _PortalTarget('Mahasiswa', RoutePaths.studentLogin, Icons.person_outline),
    _PortalTarget('Dosen', RoutePaths.lecturerLogin, Icons.badge_outlined),
    _PortalTarget('Koordinator Skripsi', RoutePaths.coordinatorLogin, Icons.manage_search_outlined),
    _PortalTarget('Admin Kampus', RoutePaths.adminLogin, Icons.admin_panel_settings_outlined),
    _PortalTarget('Super Admin', RoutePaths.superAdminLogin, Icons.verified_user_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(publicPortalFlowControllerProvider);
    final controller = ref.read(publicPortalFlowControllerProvider.notifier);

    return ResponsiveScaffold(
      title: 'Pilih Portal',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Portal',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              'Masuk langsung ke portal sesuai role. Data kampus, jurusan, dan periode bisa dikelola dari modul admin.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _portals
                .map(
                  (portal) => SizedBox(
                    width: 260,
                    child: PortalChoiceCard(
                      title: portal.title,
                      subtitle: 'Masuk ke ${portal.title.toLowerCase()}',
                      icon: portal.icon,
                      selected: flow.portal == portal.title,
                      onTap: () => controller.selectPortal(portal.title),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: flow.hasPortal
                ? () => context.go(_routeForPortal(flow.portal!))
                : null,
            icon: const Icon(Icons.login),
            label: const Text('Masuk ke Portal'),
          ),
        ],
      ),
    );
  }

  String _routeForPortal(String portal) {
    return _portals.firstWhere((item) => item.title == portal).route;
  }
}

class _PortalTarget {
  const _PortalTarget(this.title, this.route, this.icon);

  final String title;
  final String route;
  final IconData icon;
}
