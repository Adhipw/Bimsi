import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/route_paths.dart';
import '../../features/auth/application/auth_session_controller.dart';
import '../../features/auth/services/auth_service.dart';

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
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline,
                  label: 'Profil Saya',
                  onTap: () => context.go('/profile'),
                ),
                if (role == 'mahasiswa') ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    label: 'Progress Skripsi',
                    onTap: () => context.go('/dashboard/mahasiswa/progress'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.edit_document,
                    label: 'Revisi Sidang',
                    onTap: () => context.go('/dashboard/mahasiswa/revisi'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Diskusi Pembimbing',
                    onTap: () => context.go('/dashboard/mahasiswa/diskusi'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.file_download_outlined,
                    label: 'Dokumen Resmi',
                    onTap: () => context.go('/dashboard/mahasiswa/dokumen-resmi'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.star_border_rounded,
                    label: 'Evaluasi Dosen',
                    onTap: () => context.go('/dashboard/mahasiswa/evaluasi'),
                  ),
                ],
                if (role == 'dosen') ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.people_outline,
                    label: 'Mahasiswa Bimbingan',
                    onTap: () => context.go('/dashboard/dosen/bimbingan'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.grading_rounded,
                    label: 'Penilaian Sidang',
                    onTap: () => context.go('/dashboard/dosen/penilaian-sidang'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.draw_rounded,
                    label: 'Validasi Berita Acara',
                    onTap: () => context.go('/dashboard/dosen/validasi-berita-acara'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.payments_outlined,
                    label: 'Rekap Honorarium',
                    onTap: () => context.go('/dashboard/dosen/rekap-honorarium'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.flight_takeoff_rounded,
                    label: 'Pengajuan Cuti',
                    onTap: () => context.go('/dashboard/dosen/delegasi-cuti'),
                  ),
                ],
                if (role == 'kaprodi' || role == 'koordinator') ...[
                  _buildNavItem(
                    context: context,
                    icon: Icons.monitor_outlined,
                    label: 'Monitoring Progress',
                    onTap: () => context.go('/dashboard/kaprodi/monitoring-progress'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.summarize_outlined,
                    label: 'Laporan',
                    onTap: () => context.go('/dashboard/kaprodi/laporan'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.insights_rounded,
                    label: 'Analytics & Statistik',
                    onTap: () => context.go('/dashboard/kaprodi/analytics'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.rule_folder_rounded,
                    label: 'Approval Perubahan',
                    onTap: () => context.go('/dashboard/kaprodi/approval-perubahan'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.document_scanner_rounded,
                    label: 'Generate SK',
                    onTap: () => context.go('/dashboard/kaprodi/generate-sk'),
                  ),
                ],
                if (role == 'admin' || role == 'super_admin' || role == 'superAdmin') ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 24, top: 16, bottom: 8),
                    child: Text('DATA MASTER', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.storage_outlined,
                    label: 'Kelola Data Master',
                    onTap: () => context.go('/dashboard/admin/master'),
                  ),
                  if (role == 'super_admin' || role == 'superAdmin') ...[
                    _buildNavItem(
                      context: context,
                      icon: Icons.settings_outlined,
                      label: 'Pengaturan Sistem',
                      onTap: () => context.go('/dashboard/super-admin/settings'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Role & Permissions',
                      onTap: () => context.go('/dashboard/super-admin/roles'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.backup_outlined,
                      label: 'Backup & Logs',
                      onTap: () => context.go('/dashboard/super-admin/backup'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.sync_alt_rounded,
                      label: 'API Integrations',
                      onTap: () => context.go('/dashboard/super-admin/api-integrations'),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.bug_report_rounded,
                      label: 'Bug Reports',
                      onTap: () => context.go('/dashboard/super-admin/bug-reports'),
                    ),
                  ],
                  _buildNavItem(
                    context: context,
                    icon: Icons.security_outlined,
                    label: 'Audit Logs',
                    onTap: () => context.go('/dashboard/admin/audit-logs'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_outlined,
                    label: 'Mahasiswa',
                    onTap: () => context.push('/dashboard/admin/master-list?type=mahasiswa'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.group_work_rounded,
                    label: 'Manajemen Kuota',
                    onTap: () => context.go('/dashboard/admin/kuota-pembimbing'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.campaign_rounded,
                    label: 'Broadcast',
                    onTap: () => context.go('/dashboard/admin/broadcast-pengumuman'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.task_rounded,
                    label: 'Penerbitan Surat',
                    onTap: () => context.go('/dashboard/admin/penerbitan-surat'),
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
            onTap: () async {
              await ref.read(authServiceProvider).logout();
              await ref.read(authSessionControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _navigateToDashboard(BuildContext context, String? role) {
    if (role == null) return;
    switch (role) {
      case 'mahasiswa':
        context.go(RoutePaths.dashboardMahasiswa);
        break;
      case 'dosen':
        context.go(RoutePaths.dashboardDosen);
        break;
      case 'kaprodi':
      case 'koordinator':
        context.go(RoutePaths.dashboardKoordinator);
        break;
      case 'admin':
        context.go(RoutePaths.dashboardAdmin);
        break;
      case 'super_admin':
      case 'superAdmin':
        context.go(RoutePaths.dashboardSuperAdmin);
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
