import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dashboard_hero_card.dart';
import '../../../core/widgets/dashboard_menu_card.dart';
import '../../../core/widgets/kpi_grid_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class SuperAdminDashboardPage extends ConsumerWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tampilan Grid berdasarkan ukuran layar
    int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 
                         MediaQuery.of(context).size.width > 800 ? 2 : 1;
                         
    return ResponsiveScaffold(
      title: 'Dashboard Super Admin',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeroCard(
              title: 'Selamat Datang, Super Admin!',
              subtitle: 'Kelola semua data bimbingan skripsi mahasiswa Universitas Bina Sarana Informatika.',
            ),
            const SizedBox(height: 32),
            Text(
              'Statistik Sistem',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 120,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                KpiGridCard(
                  title: 'Total Mahasiswa',
                  value: '1,245',
                  icon: Icons.people,
                  color: Colors.blue,
                ),

                KpiGridCard(
                  title: 'Total Dosen',
                  value: '84',
                  icon: Icons.school,
                  color: Colors.green,
                ),
                KpiGridCard(
                  title: 'Program Studi',
                  value: '6',
                  icon: Icons.account_balance,
                  color: Colors.orange,
                ),
                KpiGridCard(
                  title: 'Log Aktivitas',
                  value: '5K+',
                  icon: Icons.history,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Menu Utama',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 120,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardMenuCard(
                  title: 'Pengaturan Sistem',
                  subtitle: 'Konfigurasi global aplikasi',
                  icon: Icons.settings,
                  onTap: () => context.push('/dashboard/super-admin/settings'),
                ),
                DashboardMenuCard(
                  title: 'Role Management',
                  subtitle: 'Kelola hak akses pengguna',
                  icon: Icons.admin_panel_settings,
                  onTap: () => context.push('/dashboard/super-admin/roles'),
                ),
                DashboardMenuCard(
                  title: 'Backup & Logs',
                  subtitle: 'Pengelolaan data cadangan',
                  icon: Icons.backup,
                  onTap: () => context.push('/dashboard/super-admin/backup'),
                ),
                DashboardMenuCard(
                  title: 'API Integrations',
                  subtitle: 'Sinkronisasi SIAKAD',
                  icon: Icons.sync_alt_rounded,
                  onTap: () => context.push('/dashboard/super-admin/api-integrations'),
                ),
                DashboardMenuCard(
                  title: 'Bug Reports',
                  subtitle: 'Tiket laporan user',
                  icon: Icons.bug_report_rounded,
                  onTap: () => context.push('/dashboard/super-admin/bug-reports'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
