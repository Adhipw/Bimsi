import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class AdminBroadcastPengumumanPage extends ConsumerStatefulWidget {
  const AdminBroadcastPengumumanPage({super.key});

  @override
  ConsumerState<AdminBroadcastPengumumanPage> createState() => _AdminBroadcastPengumumanPageState();
}

class _AdminBroadcastPengumumanPageState extends ConsumerState<AdminBroadcastPengumumanPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  String _tipePenerima = 'Semua';
  String _kategori = 'Umum';
  bool _isSending = false;

  final List<String> _kategoriList = ['Umum', 'Pendaftaran Sidang', 'Deadline Revisi', 'Info Turnitin', 'Lainnya'];
  final List<String> _penerimaList = ['Semua', 'Mahasiswa', 'Dosen Pembimbing', 'Dosen Penguji'];

  void _kirimBroadcast() async {
    if (_judulController.text.isEmpty || _isiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi pengumuman tidak boleh kosong.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSending = true);
    // Simulate sending broadcast (push notification / save to DB)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSending = false;
        _judulController.clear();
        _isiController.clear();
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Broadcast Terkirim'),
          content: Text('Pengumuman "$_kategori" berhasil dikirim ke $_tipePenerima.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Broadcast Pengumuman',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kirim Pengumuman Massal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Gunakan form ini untuk mengirimkan notifikasi penting (seperti jadwal sidang atau deadline) ke dashboard mahasiswa atau dosen.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kategori Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _kategori,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              items: _kategoriList.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                              onChanged: (val) => setState(() => _kategori = val!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tujuan Penerima', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _tipePenerima,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              items: _penerimaList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                              onChanged: (val) => setState(() => _tipePenerima = val!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Judul Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      hintText: 'Misal: Pendaftaran Sidang Gelombang 2 Segera Ditutup',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Isi Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _isiController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan rincian pengumuman secara lengkap di sini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _isSending ? 'Mengirim...' : 'Kirim Pengumuman',
                      icon: Icons.send_rounded,
                      onPressed: _isSending ? null : _kirimBroadcast,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
