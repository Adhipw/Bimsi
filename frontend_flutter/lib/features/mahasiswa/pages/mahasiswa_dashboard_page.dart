import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/realtime_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/dashboard_hero_card.dart';
import '../../../core/widgets/dashboard_menu_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/services/auth_service.dart';
import '../models/pengajuan_judul_model.dart';
import '../services/pengajuan_judul_service.dart';

class MahasiswaDashboardPage extends ConsumerStatefulWidget {
  const MahasiswaDashboardPage({super.key});

  @override
  ConsumerState<MahasiswaDashboardPage> createState() => _MahasiswaDashboardPageState();
}

class _MahasiswaDashboardPageState extends ConsumerState<MahasiswaDashboardPage> {
  PengajuanJudulModel? _pengajuan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getProfile();
      
      final service = ref.read(pengajuanJudulServiceProvider);
      final fetched = await service.getStatus();
      setState(() {
        _pengajuan = fetched;
      });

      // Initialize Pusher
      final realtime = ref.read(realtimeServiceProvider);
      await realtime.initPusher();
      await realtime.subscribeToChannel('private-mahasiswa.${user.id}', (event) {});
      
      realtime.eventStream.listen((event) {
        if (event.channelName == 'private-mahasiswa.${user.id}') {
          if (event.eventName == 'status.judul.updated' || event.eventName == 'progress.updated') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pembaruan data dari server...')),
              );
              _fetchStatus();
            }
          }
        }
      });
      
    } catch (_) {
      // Abaikan error pada dashboard, user dapat refresh manual atau melihat detail
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'disetujui': return const Color(0xFF16A34A); // Green 600
      case 'revisi': return const Color(0xFFF59E0B); // Amber 500
      case 'ditolak': return const Color(0xFFDC2626); // Red 600
      default: return const Color(0xFF2563EB); // Blue 600
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'disetujui': return 'Disetujui';
      case 'revisi': return 'Butuh Revisi';
      case 'ditolak': return 'Ditolak';
      default: return 'Menunggu Validasi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Dashboard Mahasiswa',
      body: RefreshIndicator(
        onRefresh: _fetchStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeroCard(
                title: 'Selamat Datang di BIMSI UBSI',
                subtitle: 'Kelola usulan judul skripsi dan pantau perkembangan bimbingan Anda secara realtime.',
              ),
              const SizedBox(height: 32),
              Text(
                'Status Skripsi Anda',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()))
              else
                AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _pengajuan == null
                                  ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
                                  : _getStatusColor(_pengajuan!.status).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _pengajuan == null ? Icons.info_outline : Icons.assignment,
                              color: _pengajuan == null
                                  ? Theme.of(context).colorScheme.secondary
                                  : _getStatusColor(_pengajuan!.status),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _pengajuan == null ? 'Judul Belum Diajukan' : 'Usulan Judul: ${_pengajuan!.judul}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _pengajuan == null
                                      ? 'Anda belum mengajukan usulan judul skripsi.'
                                      : 'Status: ${_getStatusLabel(_pengajuan!.status)}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_pengajuan == null || _pengajuan!.status == 'revisi') ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: _pengajuan == null ? 'Ajukan Judul Sekarang' : 'Revisi Judul',
                            onPressed: () {
                              context.push('/dashboard/mahasiswa/pengajuan');
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (_pengajuan != null && _pengajuan!.status == 'disetujui') ...[
                const SizedBox(height: 32),
                Text(
                  'Bimbingan & Dosen',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 
                                 MediaQuery.of(context).size.width > 800 ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  children: [
                    DashboardMenuCard(
                      title: 'Dosen Pembimbing',
                      subtitle: 'Lihat informasi detail dosen',
                      icon: Icons.supervisor_account_rounded,
                      onTap: () => context.push('/dashboard/mahasiswa/pembimbing'),
                    ),
                    DashboardMenuCard(
                      title: 'Jadwal Bimbingan',
                      subtitle: 'Status pengajuan bimbingan mingguan',
                      icon: Icons.event_note_rounded,
                      onTap: () => context.push('/dashboard/mahasiswa/jadwal'),
                    ),
                    DashboardMenuCard(
                      title: 'Ajukan Jadwal Baru',
                      subtitle: 'Ajukan konsultasi ke pembimbing',
                      icon: Icons.add_alarm_rounded,
                      onTap: () => context.push('/dashboard/mahasiswa/ajukan-jadwal'),
                    ),
                    DashboardMenuCard(
                      title: 'Buku Konsultasi',
                      subtitle: 'Catatan bimbingan dan revisi',
                      icon: Icons.history_edu_rounded,
                      onTap: () => context.push('/dashboard/mahasiswa/riwayat'),
                    ),
                    DashboardMenuCard(
                      title: 'Dokumen Skripsi',
                      subtitle: 'Unggah draft proposal/naskah bab',
                      icon: Icons.inventory_2_rounded,
                      onTap: () => context.pushNamed('mahasiswa_dokumen'),
                    ),
                    DashboardMenuCard(
                      title: 'Progress Skripsi',
                      subtitle: 'Persentase kemajuan penyusunan',
                      icon: Icons.bar_chart_rounded,
                      onTap: () => context.pushNamed('mahasiswa_progress'),
                    ),
                    DashboardMenuCard(
                      title: 'Pendaftaran Sidang',
                      subtitle: 'Daftar sidang & Turnitin',
                      icon: Icons.gavel_rounded,
                      onTap: () => context.push('/dashboard/mahasiswa/sidang'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
