import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/realtime_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/dashboard_hero_card.dart';
import '../../../core/widgets/dashboard_menu_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/services/auth_service.dart';
import '../../mahasiswa/services/pengajuan_judul_service.dart';
import '../widgets/kaprodi_analytics_widget.dart';

class KaprodiDashboardPage extends ConsumerStatefulWidget {
  const KaprodiDashboardPage({super.key});

  @override
  ConsumerState<KaprodiDashboardPage> createState() => _KaprodiDashboardPageState();
}

class _KaprodiDashboardPageState extends ConsumerState<KaprodiDashboardPage> {
  int _pendingCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPendingCount();
  }

  Future<void> _fetchPendingCount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      final list = await service.getKaprodiList(status: 'pending');
      setState(() {
        _pendingCount = list.length;
      });

      // Initialize Pusher
      final realtime = ref.read(realtimeServiceProvider);
      await realtime.initPusher();
      await realtime.subscribeToChannel('private-kaprodi.notifications', (event) {});
      
      realtime.eventStream.listen((event) {
        if (event.channelName == 'private-kaprodi.notifications') {
          if (event.eventName == 'judul.diajukan') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ada pengajuan judul baru!')),
              );
              _fetchPendingCount();
            }
          }
        }
      });
      
    } catch (_) {
      // Abaikan error pada dashboard count agar tidak mengganggu layout utama
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Dashboard Kaprodi',
      body: RefreshIndicator(
        onRefresh: _fetchPendingCount,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeroCard(
                title: 'Selamat Datang, Kaprodi',
                subtitle: 'Kelola persetujuan judul skripsi mahasiswa dan pantau integritas akademik program studi Anda.',
              ),
              const SizedBox(height: 32),
              
              const KaprodiAnalyticsWidget(),
              const SizedBox(height: 32),

              Text(
                'Menu & Validasi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.push('/dashboard/kaprodi/pengajuan').then((_) => _fetchPendingCount());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.assignment_turned_in_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Persetujuan Judul Skripsi',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                _isLoading
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(strokeWidth: 1.5),
                                      )
                                    : Text(
                                        _pendingCount > 0
                                            ? 'Ada $_pendingCount usulan judul menunggu persetujuan.'
                                            : 'Semua usulan judul skripsi telah diproses.',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: _pendingCount > 0 
                                            ? Colors.orange 
                                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                          fontWeight: _pendingCount > 0 ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
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
                    title: 'Penentuan Pembimbing',
                    subtitle: 'Alokasikan pembimbing untuk judul yang disetujui.',
                    icon: Icons.supervisor_account_rounded,
                    onTap: () => context.push('/dashboard/kaprodi/pembimbing'),
                  ),
                  DashboardMenuCard(
                    title: 'Monitoring Progress',
                    subtitle: 'Pantau kemajuan skripsi seluruh mahasiswa.',
                    icon: Icons.bar_chart_rounded,
                    onTap: () => context.pushNamed('kaprodi_monitoring_progress'),
                  ),
                  DashboardMenuCard(
                    title: 'Penetapan Dosen Penguji',
                    subtitle: 'Tetapkan penguji untuk sidang mahasiswa.',
                    icon: Icons.gavel_rounded,
                    onTap: () => context.push('/dashboard/kaprodi/penguji'),
                  ),
                  DashboardMenuCard(
                    title: 'Analytics & Statistik',
                    subtitle: 'Distribusi beban & kelulusan',
                    icon: Icons.insights_rounded,
                    onTap: () => context.push('/dashboard/kaprodi/analytics'),
                  ),
                  DashboardMenuCard(
                    title: 'Approval Perubahan',
                    subtitle: 'Persetujuan ubah judul/dosen',
                    icon: Icons.rule_folder_rounded,
                    onTap: () => context.push('/dashboard/kaprodi/approval-perubahan'),
                  ),
                  DashboardMenuCard(
                    title: 'Generate SK Penugasan',
                    subtitle: 'Cetak dokumen otomatis ke PDF',
                    icon: Icons.document_scanner_rounded,
                    onTap: () => context.push('/dashboard/kaprodi/generate-sk'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
