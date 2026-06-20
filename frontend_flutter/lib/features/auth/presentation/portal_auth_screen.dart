import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';

enum PortalAccessMode { login, register, requestAccount }

class PortalAuthScreen extends ConsumerWidget {
  const PortalAuthScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.mode,
    required this.role,
  });

  final String title;
  final String subtitle;
  final String description;
  final PortalAccessMode mode;
  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authSessionControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    String roleLabel(UserRole value) {
      switch (value) {
        case UserRole.mahasiswa:
          return 'Mahasiswa';
        case UserRole.dosen:
          return 'Dosen';
        case UserRole.koordinator:
          return 'Koordinator';
        case UserRole.admin:
          return 'Admin';
        case UserRole.superAdmin:
          return 'Super Admin';
      }
    }

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
            constraints: const BoxConstraints(maxWidth: 760),
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
            children: _buildActions(context, controller, roleLabel(role)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    AuthSessionController controller,
    String roleLabel,
  ) {
    switch (mode) {
      case PortalAccessMode.login:
        return [
          FilledButton.icon(
            onPressed: () {
              controller.login(role: role, profileCompleted: true, requiresVerification: false);
              context.go(_dashboardForRole(role));
            },
            icon: const Icon(Icons.login),
            label: Text('Login Demo $roleLabel'),
          ),
          if (role == UserRole.mahasiswa)
            OutlinedButton(
              onPressed: () {
                controller.login(role: role, profileCompleted: false, requiresVerification: false);
                context.go(RoutePaths.completeProfile);
              },
              child: const Text('Simulasi Profil Belum Lengkap'),
            ),
        ];
      case PortalAccessMode.register:
        return [
          FilledButton.icon(
            onPressed: () {
              controller.registerStudent();
              context.go(RoutePaths.waitingVerification);
            },
            icon: const Icon(Icons.app_registration),
            label: const Text('Daftar Demo'),
          ),
        ];
      case PortalAccessMode.requestAccount:
        return [
          FilledButton.icon(
            onPressed: () {
              controller.requestLecturerAccount();
              context.go(RoutePaths.waitingVerification);
            },
            icon: const Icon(Icons.send),
            label: const Text('Kirim Request Demo'),
          ),
        ];
    }
  }

  String _dashboardForRole(UserRole role) {
    switch (role) {
      case UserRole.mahasiswa:
        return RoutePaths.dashboardMahasiswa;
      case UserRole.dosen:
        return RoutePaths.dashboardDosen;
      case UserRole.koordinator:
        return RoutePaths.dashboardKoordinator;
      case UserRole.admin:
        return RoutePaths.dashboardAdmin;
      case UserRole.superAdmin:
        return RoutePaths.dashboardSuperAdmin;
    }
  }
}

