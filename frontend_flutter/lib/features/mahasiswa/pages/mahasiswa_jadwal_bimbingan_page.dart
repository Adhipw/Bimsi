import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/jadwal_bimbingan_service.dart';
import '../models/jadwal_bimbingan_model.dart';

class MahasiswaJadwalBimbinganPage extends ConsumerStatefulWidget {
  const MahasiswaJadwalBimbinganPage({super.key});

  @override
  ConsumerState<MahasiswaJadwalBimbinganPage> createState() => _MahasiswaJadwalBimbinganPageState();
}

class _MahasiswaJadwalBimbinganPageState extends ConsumerState<MahasiswaJadwalBimbinganPage> {
  List<JadwalBimbinganModel> _schedules = [];
  bool _isLoading = false;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ref.read(jadwalBimbinganServiceProvider).getMahasiswaJadwal();
      setState(() {
        _schedules = list;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat jadwal bimbingan: ${e.toString().replaceAll('Exception: ', '')}'),
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

  Future<void> _cancelBooking(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pengajuan', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin membatalkan pengajuan jadwal bimbingan ini?'),
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
            child: const Text('Ya, Batalkan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isCancelling = true;
      });

      try {
        await ref.read(jadwalBimbinganServiceProvider).cancelJadwal(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal bimbingan berhasil dibatalkan.'), backgroundColor: Colors.green),
          );
        }
        _fetchSchedules();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membatalkan jadwal: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isCancelling = false;
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
        return 'Dibatalkan';
      default:
        return 'Menunggu Persetujuan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Jadwal Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading || _isCancelling
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchSchedules,
              child: _schedules.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = _schedules[index];
                        return _buildScheduleCard(schedule);
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/dashboard/mahasiswa/ajukan-jadwal').then((_) => _fetchSchedules());
        },
        backgroundColor: const Color(0xFF0056A6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Ajukan Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildScheduleCard(JadwalBimbinganModel schedule) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0056A6).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school_rounded, color: Color(0xFF0056A6), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      schedule.namaDosen ?? 'Dosen Pembimbing',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF555555)),
                const SizedBox(width: 8),
                Text(
                  'Tanggal Bimbingan: ${schedule.tanggal}',
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
                  'Waktu Slot: ${slot != null ? "${slot.hari} (${slot.jamMulai} - ${slot.jamSelesai})" : "-"}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
              ],
            ),
            if (schedule.status == 'scheduled') ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _cancelBooking(schedule.id),
                    icon: const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFF44336)),
                    label: const Text(
                      'Batalkan Pengajuan',
                      style: TextStyle(color: Color(0xFFF44336), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFF0056A6),
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Pengajuan Jadwal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda belum mengajukan jadwal pertemuan bimbingan mingguan dengan dosen pembimbing.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/dashboard/mahasiswa/ajukan-jadwal').then((_) => _fetchSchedules());
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajukan Jadwal Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056A6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
