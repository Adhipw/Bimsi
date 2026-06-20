import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mahasiswa/models/jadwal_bimbingan_model.dart';
import '../../mahasiswa/services/jadwal_bimbingan_service.dart';

class DosenJadwalBimbinganPage extends ConsumerStatefulWidget {
  const DosenJadwalBimbinganPage({super.key});

  @override
  ConsumerState<DosenJadwalBimbinganPage> createState() => _DosenJadwalBimbinganPageState();
}

class _DosenJadwalBimbinganPageState extends ConsumerState<DosenJadwalBimbinganPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JadwalBimbinganModel> _schedules = [];
  bool _isLoading = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(jadwalBimbinganServiceProvider).getDosenJadwal();
      setState(() {
        _schedules = list;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat jadwal: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleApprove(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Setujui Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menyetujui pengajuan jadwal bimbingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isProcessing = true;
      });
      try {
        await ref.read(jadwalBimbinganServiceProvider).approveJadwal(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal bimbingan berhasil disetujui.'), backgroundColor: Colors.green),
          );
        }
        _fetchSchedules();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyetujui: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  Future<void> _handleReject(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tolak Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menolak pengajuan jadwal bimbingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isProcessing = true;
      });
      try {
        await ref.read(jadwalBimbinganServiceProvider).rejectJadwal(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal bimbingan ditolak.'), backgroundColor: Colors.orange),
          );
        }
        _fetchSchedules();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menolak: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
      case 'cancelled':
        return Colors.blueGrey;
      default:
        return const Color(0xFFFF9800);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'cancelled':
        return 'Dibatalkan Mhs';
      default:
        return 'Menunggu Persetujuan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingSchedules = _schedules.where((s) => s.status == 'scheduled').toList();
    final historySchedules = _schedules.where((s) => s.status != 'scheduled').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Persetujuan Jadwal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Menunggu', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (pendingSchedules.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${pendingSchedules.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(child: Text('Histori Jadwal', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: _isLoading || _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleList(pendingSchedules, isPending: true),
                _buildScheduleList(historySchedules, isPending: false),
              ],
            ),
    );
  }

  Widget _buildScheduleList(List<JadwalBimbinganModel> list, {required bool isPending}) {
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchSchedules,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPending ? Icons.pending_actions_rounded : Icons.history_edu_rounded,
                    color: const Color(0xFF0056A6),
                    size: 56,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isPending ? 'Tidak Ada Pengajuan Menunggu' : 'Histori Jadwal Kosong',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 8),
                Text(
                  isPending
                      ? 'Saat ini tidak ada mahasiswa yang mengajukan jadwal bimbingan baru.'
                      : 'Belum ada riwayat persetujuan atau penolakan jadwal bimbingan.',
                  style: const TextStyle(color: Color(0xFF757575), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchSchedules,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final schedule = list[index];
          return _buildScheduleCard(schedule, isPending: isPending);
        },
      ),
    );
  }

  Widget _buildScheduleCard(JadwalBimbinganModel schedule, {required bool isPending}) {
    final slot = schedule.slotBimbingan;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student and Status Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.1),
                  child: Text(
                    schedule.namaMahasiswa != null && schedule.namaMahasiswa!.isNotEmpty
                        ? schedule.namaMahasiswa![0].toUpperCase()
                        : 'M',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0056A6)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.namaMahasiswa ?? 'Mahasiswa',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: ${schedule.nimMahasiswa ?? "-"} â€¢ Kelas: ${schedule.kelasMahasiswa ?? "-"}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(schedule.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusLabel(schedule.status),
                    style: TextStyle(
                      color: _getStatusColor(schedule.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Slot Details
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF555555)),
                const SizedBox(width: 8),
                Text(
                  'Tanggal: ${schedule.tanggal}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF555555)),
                const SizedBox(width: 8),
                Text(
                  'Slot: ${slot != null ? "${slot.hari} (${slot.jamMulai} - ${slot.jamSelesai})" : "-"}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
              ],
            ),

            if (schedule.judulSkripsi != null && schedule.judulSkripsi!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Judul Skripsi:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule.judulSkripsi!,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF444444)),
                    ),
                  ],
                ),
              ),
            ],

            // Action Buttons
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _handleReject(schedule.id),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFF44336),
                      side: const BorderSide(color: Color(0xFFF44336)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _handleApprove(schedule.id),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ] else if (schedule.status == 'approved') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/dashboard/dosen/riwayat/input?jadwal_id=${schedule.id}').then((val) {
                        if (val == true) {
                          _fetchSchedules();
                        }
                      });
                    },
                    icon: const Icon(Icons.history_edu_rounded, size: 16),
                    label: const Text('Input Riwayat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056A6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
