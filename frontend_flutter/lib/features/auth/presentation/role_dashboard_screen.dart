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

  final String role;
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

  String _roleLabel(String role) {
    switch (role) {
      case 'mahasiswa':
        return 'Mahasiswa';
      case 'dosen':
        return 'Dosen';
      case 'koordinator':
        return 'Koordinator / Kaprodi';
      case 'admin':
        return 'Admin Akademik';
      case 'superAdmin':
        return 'Super Admin';
      default:
        return 'Role Tidak Dikenal';
    }
  }
}
