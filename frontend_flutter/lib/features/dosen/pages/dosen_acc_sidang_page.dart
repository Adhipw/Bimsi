import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dosen_sidang_provider.dart';
import '../../mahasiswa/models/pendaftaran_sidang_model.dart';

class DosenAccSidangPage extends ConsumerStatefulWidget {
  const DosenAccSidangPage({super.key});

  @override
  ConsumerState<DosenAccSidangPage> createState() => _DosenAccSidangPageState();
}

class _DosenAccSidangPageState extends ConsumerState<DosenAccSidangPage> {
  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(dosenSidangListProvider);
    final approveState = ref.watch(approveSidangProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Persetujuan Sidang', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF111827), // Gray-900 for Dosen
        elevation: 0,
      ),
      body: listState.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Tidak ada antrean ACC Sidang.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(dosenSidangListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return _buildPendaftaranCard(item, approveState.isLoading);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildPendaftaranCard(PendaftaranSidangModel item, bool isLoading) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NIM: ${item.mahasiswaId}', // Di sistem nyata, ambil nama relasi
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.jenisSidang.toUpperCase(),
                  style: GoogleFonts.inter(color: const Color(0xFF1D4ED8), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'File Syarat: ${item.fileSyaratUrl ?? "Tidak dilampirkan"}',
            style: GoogleFonts.inter(color: Colors.blue, decoration: TextDecoration.underline),
          ),
          const Divider(height: 32),
          if (item.accPembimbing)
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green),
                const SizedBox(width: 8),
                Text('Telah di-ACC pada ${item.tanggalAcc}', style: GoogleFonts.inter(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Emerald-500
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isLoading ? null : () => _accSidang(item.id),
                icon: const Icon(Icons.draw, color: Colors.white),
                label: Text('Berikan ACC & TTD Digital', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  void _accSidang(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi ACC'),
        content: const Text('Apakah Anda yakin menyetujui mahasiswa ini untuk sidang? Sistem akan membuatkan hash Tanda Tangan Digital atas nama Anda.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(approveSidangProvider.notifier).approve(id).then((_) {
                ref.refresh(dosenSidangListProvider);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ACC & TTD Digital Berhasil!')));
              });
            },
            child: const Text('Ya, ACC'),
          ),
        ],
      ),
    );
  }
}
