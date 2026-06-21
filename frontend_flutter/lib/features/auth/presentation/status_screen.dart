import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';

enum AuthStatusKind { waitingVerification, completeProfile }

class StatusScreen extends ConsumerWidget {
  const StatusScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String description;
  final AuthStatusKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authSessionControllerProvider.notifier);
    final state = ref.watch(authSessionControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveScaffold(
      title: title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _buildActions(context, controller, state),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    AuthSessionController controller,
    AuthSessionState state,
  ) {
    final dashboardRoute = _dashboardForRole(state.role);

    switch (kind) {
      case AuthStatusKind.waitingVerification:
        return [
          FilledButton.icon(
            onPressed: () {
              controller.approveVerification();
              if (state.profileCompleted) {
                context.go(dashboardRoute);
              } else {
                context.go(RoutePaths.completeProfile);
              }
            },
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Simulasi Verifikasi'),
          ),
        ];
      case AuthStatusKind.completeProfile:
        return [
          FilledButton.icon(
            onPressed: () {
              controller.completeProfile();
              if (state.requiresVerification) {
                context.go(RoutePaths.waitingVerification);
              } else {
                context.go(dashboardRoute);
              }
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Selesaikan Profil'),
          ),
        ];
    }
  }

  String _dashboardForRole(String? role) {
    switch (role) {
      case 'mahasiswa':
        return '/dashboard/mahasiswa';
      case 'dosen':
        return '/dashboard/dosen';
      case 'koordinator':
      case 'kaprodi':
        return '/dashboard/kaprodi';
      case 'admin':
        return '/dashboard/admin';
      case 'superAdmin':
        return '/dashboard/super-admin';
      default:
        return '/dashboard';
    }
  }
}
