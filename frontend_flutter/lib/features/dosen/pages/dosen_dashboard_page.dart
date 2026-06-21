import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dashboard_hero_card.dart';
import '../../../core/widgets/dashboard_menu_card.dart';
import '../../../core/widgets/kpi_grid_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class DosenDashboardPage extends ConsumerWidget {
  const DosenDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 
                         MediaQuery.of(context).size.width > 800 ? 2 : 1;

    return ResponsiveScaffold(
      title: 'Dashboard Dosen',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeroCard(
              title: 'Selamat Datang, Bapak/Ibu Dosen',
              subtitle: 'Kelola kemajuan riset mahasiswa bimbingan Anda dan catat histori konsultasi akademik secara berkala.',
            ),
            const SizedBox(height: 32),
            Text(
              'Statistik Bimbingan',
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
                  title: 'Total Bimbingan',
                  value: '12',
                  icon: Icons.group,
                  color: Colors.blue,
                ),
                KpiGridCard(
                  title: 'Jadwal Menunggu',
                  value: '4',
                  icon: Icons.calendar_today,
                  color: Colors.orange,
                ),
                KpiGridCard(
                  title: 'Dokumen Baru',
                  value: '7',
                  icon: Icons.insert_drive_file,
                  color: Colors.green,
                ),
                KpiGridCard(
                  title: 'Logbook Pending',
                  value: '3',
                  icon: Icons.menu_book,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Aktivitas Bimbingan',
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
                  title: 'Mahasiswa Bimbingan',
                  subtitle: 'Lihat daftar mahasiswa aktif',
                  icon: Icons.school_rounded,
                  onTap: () => context.push('/dashboard/dosen/bimbingan'),
                ),
                DashboardMenuCard(
                  title: 'Slot Ketersediaan',
                  subtitle: 'Atur jam operasional',
                  icon: Icons.edit_calendar_rounded,
                  onTap: () => context.push('/dashboard/dosen/slots'),
                ),
                DashboardMenuCard(
                  title: 'Persetujuan Jadwal',
                  subtitle: 'Setujui atau tolak jadwal',
                  icon: Icons.approval_rounded,
                  onTap: () => context.push('/dashboard/dosen/jadwal'),
                ),
                DashboardMenuCard(
                  title: 'Riwayat Bimbingan',
                  subtitle: 'Catat histori konsultasi',
                  icon: Icons.history_edu_rounded,
                  onTap: () => context.push('/dashboard/dosen/riwayat'),
                ),
                DashboardMenuCard(
                  title: 'Review Dokumen',
                  subtitle: 'Cek draft proposal & skripsi',
                  icon: Icons.folder_shared_rounded,
                  onTap: () => context.push('/dashboard/dosen/dokumen'),
                ),
                DashboardMenuCard(
                  title: 'Penilaian Sidang',
                  subtitle: 'Input nilai sidang (Rubrik)',
                  icon: Icons.grading_rounded,
                  onTap: () => context.push('/dashboard/dosen/penilaian-sidang'),
                ),
                DashboardMenuCard(
                  title: 'Validasi Berita Acara',
                  subtitle: 'Tanda tangan digital',
                  icon: Icons.draw_rounded,
                  onTap: () => context.push('/dashboard/dosen/validasi-berita-acara'),
                ),
                DashboardMenuCard(
                  title: 'Rekap Honorarium',
                  subtitle: 'Estimasi beban & honor',
                  icon: Icons.payments_outlined,
                  onTap: () => context.push('/dashboard/dosen/rekap-honorarium'),
                ),
                DashboardMenuCard(
                  title: 'Pengajuan Cuti',
                  subtitle: 'Delegasi bimbingan sementara',
                  icon: Icons.flight_takeoff_rounded,
                  onTap: () => context.push('/dashboard/dosen/delegasi-cuti'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
