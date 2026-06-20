import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/helpers/storage_helper.dart';
import '../../auth/services/auth_service.dart';

class DashboardRouterPage extends ConsumerStatefulWidget {
  const DashboardRouterPage({super.key});

  @override
  ConsumerState<DashboardRouterPage> createState() => _DashboardRouterPageState();
}

class _DashboardRouterPageState extends ConsumerState<DashboardRouterPage> {
  @override
  void initState() {
    super.initState();
    _routeUser();
  }

  void _routeUser() async {
    final token = await StorageHelper.getToken();
    final role = await StorageHelper.getRole();
    if (!mounted) return;

    if (token == null || role == null) {
      context.go('/login');
      return;
    }

    try {
      // Panggil profile API untuk verifikasi token keaktifan
      final authService = ref.read(authServiceProvider);
      final user = await authService.getProfile();
      if (!mounted) return;

      _navigateToDashboard(user.role);
    } catch (_) {
      // Jika token expired/invalid, logout dan bersihkan sesi lokal
      if (mounted) {
        final authService = ref.read(authServiceProvider);
        await authService.logout();
        if (mounted) {
          context.go('/login');
        }
      }
    }
  }

  void _navigateToDashboard(String role) {
    if (role == 'super_admin') {
      context.go('/dashboard/super-admin');
    } else if (role == 'admin') {
      context.go('/dashboard/admin');
    } else if (role == 'kaprodi') {
      context.go('/dashboard/kaprodi');
    } else if (role == 'dosen') {
      context.go('/dashboard/dosen');
    } else if (role == 'mahasiswa') {
      context.go('/dashboard/mahasiswa');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
