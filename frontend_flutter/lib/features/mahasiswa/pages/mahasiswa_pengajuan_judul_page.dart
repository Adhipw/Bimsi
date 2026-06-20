import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/pengajuan_judul_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class MahasiswaPengajuanJudulPage extends ConsumerStatefulWidget {
  final String? id;
  final String? initialJudul;
  final String? initialDeskripsi;

  const MahasiswaPengajuanJudulPage({
    super.key,
    this.id,
    this.initialJudul,
    this.initialDeskripsi,
  });

  @override
  ConsumerState<MahasiswaPengajuanJudulPage> createState() => _MahasiswaPengajuanJudulPageState();
}

class _MahasiswaPengajuanJudulPageState extends ConsumerState<MahasiswaPengajuanJudulPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _deskripsiController;
  bool _isSaving = false;

  bool get _isRevision => widget.id != null;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.initialJudul);
    _deskripsiController = TextEditingController(text: widget.initialDeskripsi);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      if (_isRevision) {
        await service.reviseJudul(
          int.parse(widget.id!),
          _judulController.text,
          _deskripsiController.text,
        );
      } else {
        await service.submitJudul(
          _judulController.text,
          _deskripsiController.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Judul skripsi berhasil diajukan!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _isRevision ? 'Revisi Judul Skripsi' : 'Ajukan Judul Skripsi',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Pengajuan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pastikan judul yang Anda ajukan relevan dengan program studi Anda dan memiliki deskripsi/rumusan masalah yang jelas.',
                        style: TextStyle(color: Color(0xFF757575), fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Judul Skripsi',
                        controller: _judulController,
                        hint: 'Masukkan usulan judul skripsi Anda',
                        validator: (v) => v == null || v.trim().isEmpty ? 'Judul skripsi wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Deskripsi / Rumusan Masalah',
                        controller: _deskripsiController,
                        hint: 'Jelaskan latar belakang, rumusan masalah, dan tujuan skripsi secara ringkas',
                        maxLines: 6,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Deskripsi skripsi wajib diisi' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isRevision ? 'Kirim Revisi Judul' : 'Ajukan Judul Skripsi',
                isLoading: _isSaving,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
