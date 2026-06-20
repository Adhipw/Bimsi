import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_paths.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';

class RoleDashboardScreen extends ConsumerWidget {
  const RoleDashboardScreen({
    super.key,
    required this.role,
    required this.title,
  });

  final UserRole role;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authSessionControllerProvider.notifier);
    return ResponsiveScaffold(
      title: title,
      actions: [
        IconButton(
          onPressed: () {
            ref.read(authSessionControllerProvider.notifier).logout();
            context.go('/login');
          },
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard ${_roleLabel(role)}', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text(
            'Ini dashboard placeholder yang dipakai untuk validasi redirect Step 12. Fitur bisnis penuh akan masuk di step berikutnya.',
          ),
        ],
      ),
    );
  }

  String _roleLabel(UserRole role) {
    switch (role) {
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
}

