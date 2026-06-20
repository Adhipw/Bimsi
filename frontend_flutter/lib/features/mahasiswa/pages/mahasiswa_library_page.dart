import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/referensi_provider.dart';
import '../models/referensi_model.dart';

class MahasiswaLibraryPage extends ConsumerStatefulWidget {
  const MahasiswaLibraryPage({super.key});

  @override
  ConsumerState<MahasiswaLibraryPage> createState() => _MahasiswaLibraryPageState();
}

class _MahasiswaLibraryPageState extends ConsumerState<MahasiswaLibraryPage> {
  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _urlController = TextEditingController();
  String _tipeReferensi = 'jurnal';

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(referensiListProvider);
    final addState = ref.watch(addReferensiProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Library Referensi', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A), // Indigo-900
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2563EB),
        onPressed: () => _showAddDialog(addState.isLoading),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: listState.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                'Belum ada referensi tersimpan.\nTekan + untuk menambahkan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildReferensiCard(list[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildReferensiCard(ReferensiModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.tipeReferensi.toUpperCase(),
                  style: GoogleFonts.inter(color: const Color(0xFF1D4ED8), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _deleteReferensi(item.id),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.judulArtikel,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF111827)),
          ),
          if (item.penulis != null && item.penulis!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(item.penulis!, style: GoogleFonts.inter(color: Colors.grey[700])),
          ],
          const SizedBox(height: 16),
          if (item.urlTautan != null && item.urlTautan!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _launchUrl(item.urlTautan!),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Buka Tautan'),
              ),
            )
        ],
      ),
    );
  }

  void _showAddDialog(bool isLoading) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tambah Referensi', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Artikel / Buku', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _penulisController,
              decoration: const InputDecoration(labelText: 'Penulis (Opsional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL Tautan (Opsional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipeReferensi,
              items: const [
                DropdownMenuItem(value: 'jurnal', child: Text('Jurnal')),
                DropdownMenuItem(value: 'buku', child: Text('Buku')),
                DropdownMenuItem(value: 'website', child: Text('Website')),
              ],
              onChanged: (val) => setState(() => _tipeReferensi = val!),
              decoration: const InputDecoration(labelText: 'Tipe', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                onPressed: isLoading ? null : () {
                  Navigator.pop(context);
                  _submitForm();
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    ref.read(addReferensiProvider.notifier).add(
      mahasiswaId: 1, // Placeholder
      pengajuanJudulId: 1, // Placeholder
      judulArtikel: _judulController.text,
      penulis: _penulisController.text,
      urlTautan: _urlController.text,
      tipeReferensi: _tipeReferensi,
    ).then((_) {
      ref.refresh(referensiListProvider);
      _judulController.clear();
      _penulisController.clear();
      _urlController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referensi ditambahkan')));
    });
  }

  void _deleteReferensi(int id) {
    ref.read(addReferensiProvider.notifier).remove(id).then((_) {
      ref.refresh(referensiListProvider);
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
