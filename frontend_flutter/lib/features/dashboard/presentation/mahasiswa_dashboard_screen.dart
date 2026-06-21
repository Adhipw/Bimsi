import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_session_controller.dart';
import 'dashboard_view.dart';

class MahasiswaDashboardScreen extends ConsumerWidget {
  const MahasiswaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DashboardView(
      title: 'Dashboard Mahasiswa',
      role: 'mahasiswa',
    );
  }
}
