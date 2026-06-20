import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/route_paths.dart';
import '../../features/auth/application/auth_session_controller.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authSessionControllerProvider);
    final role = state.role;
    final currentRoute = GoRouterState.of(context).uri.path;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 1,
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  onTap: () => _navigateToDashboard(context, role),
                ),
                if (role == UserRole.mahasiswa) ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    label: 'Progress Skripsi',
                    onTap: () => context.go('/mahasiswa/progress'),
                  ),
                ],
                if (role == UserRole.dosen) ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.people_outline,
                    label: 'Mahasiswa Bimbingan',
                    onTap: () => context.go('/dashboard/dosen/bimbingan'),
                  ),
                ],
                if (role == UserRole.koordinator) ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.monitor_outlined,
                    label: 'Monitoring Progress',
                    onTap: () => context.go('/kaprodi/monitoring'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.summarize_outlined,
                    label: 'Laporan',
                    onTap: () => context.go('/kaprodi/laporan'),
                  ),
                ],
                if (role == UserRole.admin || role == UserRole.superAdmin) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
                    child: Text('DATA MASTER', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.school_outlined,
                    label: 'Program Studi',
                    onTap: () => context.push('/dashboard/admin/master-list?type=program-studi'),
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Admin Akademik'),
                    initiallyExpanded: true,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.schedule),
                        title: const Text('Plotting Jadwal Sidang'),
                        selected: currentRoute == '/admin/jadwal',
                        onTap: () => context.go('/admin/jadwal'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.plagiarism),
                        title: const Text('Verifikasi Turnitin'),
                        selected: currentRoute == '/admin/turnitin',
                        onTap: () => context.go('/admin/turnitin'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.library_books),
                        title: const Text('Digital Library'),
                        selected: currentRoute == '/admin/repository',
                        onTap: () => context.go('/admin/repository'),
                      ),
                    ],
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.date_range_outlined,
                    label: 'Tahun Akademik',
                    onTap: () => context.push('/dashboard/admin/master-list?type=tahun-akademik'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Semester',
                    onTap: () => context.push('/dashboard/admin/master-list?type=semester'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.class_outlined,
                    label: 'Kelas',
                    onTap: () => context.push('/dashboard/admin/master-list?type=kelas'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.people_outlined,
                    label: 'User',
                    onTap: () => context.push('/dashboard/admin/master-list?type=user'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.assignment_ind_outlined,
                    label: 'Dosen',
                    onTap: () => context.push('/dashboard/admin/master-list?type=dosen'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_outlined,
                    label: 'Mahasiswa',
                    onTap: () => context.push('/dashboard/admin/master-list?type=mahasiswa'),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          _buildNavItem(
            context: context,
            icon: Icons.logout,
            label: 'Logout',
            isDestructive: true,
            onTap: () {
              ref.read(authSessionControllerProvider.notifier).logout();
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _navigateToDashboard(BuildContext context, UserRole? role) {
    if (role == null) return;
    switch (role) {
      case UserRole.mahasiswa:
        context.go('/mahasiswa');
        break;
      case UserRole.dosen:
        context.go('/dosen');
        break;
      case UserRole.koordinator:
        context.go('/kaprodi');
        break;
      case UserRole.admin:
        context.go('/admin');
        break;
      case UserRole.superAdmin:
        context.go('/super-admin');
        break;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Text(
            'Bimsi UBSI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyLarge?.color;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: () {
        // Close drawer on mobile before navigating
        if (Scaffold.of(context).hasDrawer) {
          Navigator.of(context).pop();
        }
        onTap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
    );
  }
}
