import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/dashboard/pages/dashboard_router_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_dashboard_page.dart';
import '../../features/dosen/pages/dosen_dashboard_page.dart';
import '../../features/kaprodi/pages/kaprodi_dashboard_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';
import '../../features/super_admin/pages/super_admin_dashboard_page.dart';
import '../../features/admin/pages/master_data_menu_page.dart';
import '../../features/admin/pages/master_data_list_page.dart';
import '../../features/admin/pages/master_data_form_page.dart';
import '../../features/admin/pages/master_data_detail_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_pengajuan_judul_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_status_judul_page.dart';
import '../../features/kaprodi/pages/kaprodi_list_pengajuan_judul_page.dart';
import '../../features/kaprodi/pages/kaprodi_detail_pengajuan_judul_page.dart';
import '../../features/kaprodi/pages/kaprodi_tentukan_pembimbing_page.dart';
import '../../features/kaprodi/pages/kaprodi_penetapan_penguji_page.dart';
import '../../features/kaprodi/pages/kaprodi_monitoring_progress_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_pembimbing_page.dart';
import '../../features/dosen/pages/dosen_mahasiswa_bimbingan_page.dart';
import '../../features/dosen/pages/dosen_slot_bimbingan_page.dart';
import '../../features/dosen/pages/dosen_jadwal_bimbingan_page.dart';
import '../../features/dosen/pages/dosen_riwayat_bimbingan_page.dart';
import '../../features/dosen/pages/dosen_input_riwayat_bimbingan_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_ajukan_jadwal_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_jadwal_bimbingan_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_riwayat_bimbingan_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_list_dokumen_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_upload_dokumen_page.dart';
import '../../features/dosen/pages/dosen_review_dokumen_page.dart';
import '../../features/mahasiswa/pages/mahasiswa_progress_page.dart';
import '../../features/dosen/pages/dosen_progress_mahasiswa_page.dart';
import '../../features/admin/pages/admin_plotting_jadwal_page.dart';
import '../../features/admin/pages/admin_turnitin_page.dart';
import '../../features/admin/pages/repository_public_page.dart';
import '../helpers/storage_helper.dart';
 
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final token = await StorageHelper.getToken();
      final isLoggingIn = state.matchedLocation == '/login';
      
      if (token == null && !isLoggingIn) return '/login';
      if (token != null && isLoggingIn) return '/dashboard';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardRouterPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa',
        name: 'dashboard_mahasiswa',
        builder: (context, state) => const MahasiswaDashboardPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen',
        name: 'dashboard_dosen',
        builder: (context, state) => const DosenDashboardPage(),
      ),
      GoRoute(
        path: '/dashboard/kaprodi',
        name: 'dashboard_kaprodi',
        builder: (context, state) => const KaprodiDashboardPage(),
      ),
      GoRoute(
        path: '/dashboard/admin',
        name: 'dashboard_admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/dashboard/super-admin',
        name: 'dashboard_super_admin',
        builder: (context, state) => const SuperAdminDashboardPage(),
      ),
      GoRoute(
        path: '/dashboard/admin/master',
        name: 'master_menu',
        builder: (context, state) => const MasterDataMenuPage(),
      ),
      GoRoute(
        path: '/dashboard/admin/master-list',
        name: 'master_list',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? '';
          return MasterDataListPage(type: type);
        },
      ),
      GoRoute(
        path: '/dashboard/admin/master-form',
        name: 'master_form',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? '';
          final id = state.uri.queryParameters['id'];
          return MasterDataFormPage(type: type, id: id);
        },
      ),
      GoRoute(
        path: '/dashboard/admin/master-detail',
        name: 'master_detail',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? '';
          final id = state.uri.queryParameters['id'] ?? '';
          return MasterDataDetailPage(type: type, id: id);
        },
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/pengajuan',
        name: 'mahasiswa_pengajuan',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          final judul = state.uri.queryParameters['judul'];
          final deskripsi = state.uri.queryParameters['deskripsi'];
          return MahasiswaPengajuanJudulPage(
            id: id,
            initialJudul: judul != null ? Uri.decodeComponent(judul) : null,
            initialDeskripsi: deskripsi != null ? Uri.decodeComponent(deskripsi) : null,
          );
        },
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/status',
        name: 'mahasiswa_status',
        builder: (context, state) => const MahasiswaStatusJudulPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/pembimbing',
        name: 'mahasiswa_pembimbing',
        builder: (context, state) => const MahasiswaPembimbingPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/jadwal',
        name: 'mahasiswa_jadwal',
        builder: (context, state) => const MahasiswaJadwalBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/ajukan-jadwal',
        name: 'mahasiswa_ajukan_jadwal',
        builder: (context, state) => const MahasiswaAjukanJadwalPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/riwayat',
        name: 'mahasiswa_riwayat',
        builder: (context, state) => const MahasiswaRiwayatBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/dokumen',
        name: 'mahasiswa_dokumen',
        builder: (context, state) => const MahasiswaListDokumenPage(),
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/dokumen/upload',
        name: 'mahasiswa_dokumen_upload',
        builder: (context, state) {
          final jenis = state.uri.queryParameters['jenis'];
          return MahasiswaUploadDokumenPage(initialJenisDokumen: jenis);
        },
      ),
      GoRoute(
        path: '/dashboard/mahasiswa/progress',
        name: 'mahasiswa_progress',
        builder: (context, state) => const MahasiswaProgressPage(),
      ),
      // Kaprodi routes
      GoRoute(
        path: '/dashboard/kaprodi/pengajuan',
        name: 'kaprodi_pengajuan_list',
        builder: (context, state) => const KaprodiListPengajuanJudulPage(),
      ),
      GoRoute(
        path: '/dashboard/kaprodi/pengajuan-detail',
        name: 'kaprodi_pengajuan_detail',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return KaprodiDetailPengajuanJudulPage(id: id);
        },
      ),
      GoRoute(
        path: '/dashboard/kaprodi/pembimbing',
        name: 'kaprodi_pembimbing_assign',
        builder: (context, state) => const KaprodiTentukanPembimbingPage(),
      ),
      GoRoute(
        path: '/dashboard/kaprodi/penguji',
        name: 'kaprodi_penguji',
        builder: (context, state) => const KaprodiPenetapanPengujiPage(),
      ),
      GoRoute(
        path: '/dashboard/kaprodi/monitoring-progress',
        name: 'kaprodi_monitoring_progress',
        builder: (context, state) => const KaprodiMonitoringProgressPage(),
      ),
      // Dosen routes
      GoRoute(
        path: '/dashboard/dosen/bimbingan',
        name: 'dosen_bimbingan_list',
        builder: (context, state) => const DosenMahasiswaBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen/slots',
        name: 'dosen_slots',
        builder: (context, state) => const DosenSlotBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen/jadwal',
        name: 'dosen_jadwal',
        builder: (context, state) => const DosenJadwalBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen/riwayat',
        name: 'dosen_riwayat',
        builder: (context, state) => const DosenRiwayatBimbinganPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen/riwayat/input',
        name: 'dosen_riwayat_input',
        builder: (context, state) {
          final idParam = state.uri.queryParameters['jadwal_id'];
          final id = idParam != null ? int.tryParse(idParam) : null;
          return DosenInputRiwayatBimbinganPage(preSelectedJadwalId: id);
        },
      ),
      GoRoute(
        path: '/dashboard/dosen/dokumen',
        name: 'dosen_dokumen_review',
        builder: (context, state) => const DosenReviewDokumenPage(),
      ),
      GoRoute(
        path: '/dashboard/dosen/progress',
        name: 'dosen_progress_mahasiswa',
        builder: (context, state) {
          final idStr = state.uri.queryParameters['pengajuan_judul_id'];
          final id = idStr != null ? int.tryParse(idStr) ?? 0 : 0;
          final nama = state.uri.queryParameters['nama_mahasiswa'] ?? 'Mahasiswa';
          return DosenProgressMahasiswaPage(pengajuanJudulId: id, namaMahasiswa: nama);
        },
      ),
      // Admin Akademik routes
      GoRoute(
        path: '/admin/jadwal',
        name: 'admin_jadwal',
        builder: (context, state) => const AdminPlottingJadwalPage(),
      ),
      GoRoute(
        path: '/admin/turnitin',
        name: 'admin_turnitin',
        builder: (context, state) => const AdminTurnitinPage(),
      ),
      GoRoute(
        path: '/admin/repository',
        name: 'admin_repository',
        builder: (context, state) => const RepositoryPublicPage(),
      ),
    ],
  );
});
