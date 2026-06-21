import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dashboard_hero_card.dart';
import '../../../core/widgets/dashboard_menu_card.dart';
import '../../../core/widgets/kpi_grid_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 
                         MediaQuery.of(context).size.width > 800 ? 2 : 1;

    return ResponsiveScaffold(
      title: 'Dashboard Admin Akademik',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeroCard(
              title: 'Selamat Datang, Admin!',
              subtitle: 'Kelola data master akademik dan verifikasi pendaftaran sidang.',
            ),
            const SizedBox(height: 32),
            Text(
              'Statistik Akademik',
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
                  title: 'Sidang Menunggu',
                  value: '12',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
                KpiGridCard(
                  title: 'Turnitin Review',
                  value: '8',
                  icon: Icons.document_scanner,
                  color: Colors.blue,
                ),
                KpiGridCard(
                  title: 'Total Ruangan',
                  value: '15',
                  icon: Icons.meeting_room,
                  color: Colors.green,
                ),
                KpiGridCard(
                  title: 'Repository Publik',
                  value: '142',
                  icon: Icons.public,
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
                  title: 'Kelola Data Master',
                  subtitle: 'CRUD Program Studi, Kelas, Dosen',
                  icon: Icons.storage_rounded,
                  onTap: () => context.push('/dashboard/admin/master'),
                ),
                DashboardMenuCard(
                  title: 'Plotting Sidang',
                  subtitle: 'Atur jadwal dan ruangan sidang',
                  icon: Icons.calendar_month,
                  onTap: () => context.push('/admin/jadwal'),
                ),
                DashboardMenuCard(
                  title: 'Verifikasi Turnitin',
                  subtitle: 'Cek plagiarisme dokumen',
                  icon: Icons.verified,
                  onTap: () => context.push('/admin/turnitin'),
                ),
                DashboardMenuCard(
                  title: 'Repository Skripsi',
                  subtitle: 'Kelola publikasi skripsi mahasiswa',
                  icon: Icons.library_books,
                  onTap: () => context.push('/admin/repository'),
                ),
                DashboardMenuCard(
                  title: 'Manajemen Kuota',
                  subtitle: 'Batas kuota pembimbing',
                  icon: Icons.group_work_rounded,
                  onTap: () => context.push('/dashboard/admin/kuota-pembimbing'),
                ),
                DashboardMenuCard(
                  title: 'Broadcast Pengumuman',
                  subtitle: 'Kirim notifikasi massal',
                  icon: Icons.campaign_rounded,
                  onTap: () => context.push('/dashboard/admin/broadcast-pengumuman'),
                ),
                DashboardMenuCard(
                  title: 'Penerbitan Surat Bebas',
                  subtitle: 'Cetak surat bebas pustaka',
                  icon: Icons.task_rounded,
                  onTap: () => context.push('/dashboard/admin/penerbitan-surat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
