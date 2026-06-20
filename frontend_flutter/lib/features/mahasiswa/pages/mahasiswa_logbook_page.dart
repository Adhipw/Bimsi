import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/logbook_provider.dart';
import '../models/logbook_model.dart';

class MahasiswaLogbookPage extends ConsumerStatefulWidget {
  const MahasiswaLogbookPage({super.key});

  @override
  ConsumerState<MahasiswaLogbookPage> createState() => _MahasiswaLogbookPageState();
}

class _MahasiswaLogbookPageState extends ConsumerState<MahasiswaLogbookPage> {
  final _kegiatanController = TextEditingController();
  final _tanggalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logbookState = ref.watch(logbookListProvider);
    final submitState = ref.watch(createLogbookProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Logbook Bimbingan', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A), // Indigo-900
        elevation: 0,
        centerTitle: true,
      ),
      body: logbookState.when(
        data: (list) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildForm(submitState),
                const SizedBox(height: 32),
                Text(
                  'Riwayat Logbook',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A)),
                ),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  Center(child: Text('Belum ada riwayat', style: GoogleFonts.inter(color: Colors.grey)))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildLogbookCard(list[index]);
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildForm(AsyncValue<void> submitState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catat Kegiatan Baru', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _tanggalController,
            decoration: InputDecoration(
              labelText: 'Tanggal (YYYY-MM-DD)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _kegiatanController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Deskripsi Kegiatan / Progress',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: submitState.isLoading ? null : () => _submitForm(context),
              child: submitState.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                  : Text('Simpan Logbook', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookCard(LogbookModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.tanggalKegiatan,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A)),
              ),
              _buildStatusBadge(item.statusApproval),
            ],
          ),
          const Divider(height: 24),
          Text(
            item.deskripsiKegiatan,
            style: GoogleFonts.inter(color: Colors.grey[800], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == 'approved' ? Colors.green : (status == 'revised' ? Colors.orange : Colors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    ref.read(createLogbookProvider.notifier).submit(
      mahasiswaId: 1,
      pengajuanJudulId: 1,
      dosenId: 1,
      tanggalKegiatan: _tanggalController.text,
      deskripsiKegiatan: _kegiatanController.text,
    ).then((_) {
      ref.refresh(logbookListProvider);
      _kegiatanController.clear();
      _tanggalController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logbook disimpan!')));
    });
  }
}
