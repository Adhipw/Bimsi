import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dosen_catatan_privat_provider.dart';

class DosenCatatanPrivatPage extends ConsumerStatefulWidget {
  final int mahasiswaId; // ID mahasiswa yang sedang di-review
  const DosenCatatanPrivatPage({super.key, required this.mahasiswaId});

  @override
  ConsumerState<DosenCatatanPrivatPage> createState() => _DosenCatatanPrivatPageState();
}

class _DosenCatatanPrivatPageState extends ConsumerState<DosenCatatanPrivatPage> {
  final _catatanController = TextEditingController();
  bool _isInit = false;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catatanState = ref.watch(catatanPrivatProvider(widget.mahasiswaId));
    final saveState = ref.watch(saveCatatanProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Catatan Privat', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: catatanState.when(
        data: (catatan) {
          if (!_isInit) {
            _catatanController.text = catatan?.catatan ?? '';
            _isInit = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Catatan ini hanya dapat dilihat oleh Anda.',
                          style: GoogleFonts.inter(color: Colors.grey[700], fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _catatanController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tulis evaluasi, peringatan, atau progres khusus mahasiswa ini...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: saveState.isLoading ? null : _saveCatatan,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text('Simpan Catatan', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _saveCatatan() {
    ref.read(saveCatatanProvider.notifier).save(widget.mahasiswaId, _catatanController.text).then((_) {
      ref.refresh(catatanPrivatProvider(widget.mahasiswaId));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan berhasil disimpan')));
    });
  }
}
