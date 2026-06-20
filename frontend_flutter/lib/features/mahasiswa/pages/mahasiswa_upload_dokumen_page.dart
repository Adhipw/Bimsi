import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../services/dokumen_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class MahasiswaUploadDokumenPage extends ConsumerStatefulWidget {
  final String? initialJenisDokumen;

  const MahasiswaUploadDokumenPage({
    super.key,
    this.initialJenisDokumen,
  });

  @override
  ConsumerState<MahasiswaUploadDokumenPage> createState() => _MahasiswaUploadDokumenPageState();
}

class _MahasiswaUploadDokumenPageState extends ConsumerState<MahasiswaUploadDokumenPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedJenis = 'proposal';
  PlatformFile? _selectedFile;
  final _catatanController = TextEditingController();
  bool _isSaving = false;

  final List<Map<String, String>> _jenisOptions = [
    {'value': 'proposal', 'label': 'Proposal Skripsi'},
    {'value': 'bab1', 'label': 'BAB I (Pendahuluan)'},
    {'value': 'bab2', 'label': 'BAB II (Tinjauan Pustaka)'},
    {'value': 'bab3', 'label': 'BAB III (Metodologi)'},
    {'value': 'bab4', 'label': 'BAB IV (Hasil & Pembahasan)'},
    {'value': 'bab5', 'label': 'BAB V (Penutup)'},
    {'value': 'final', 'label': 'Laporan Akhir (Final)'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialJenisDokumen != null) {
      final exists = _jenisOptions.any((opt) => opt['value'] == widget.initialJenisDokumen);
      if (exists) {
        _selectedJenis = widget.initialJenisDokumen!;
      }
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'zip', 'rar'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Validate file size (max 10MB)
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ukuran file maksimal adalah 10 MB.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih file: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null || _selectedFile!.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih dokumen yang ingin diunggah.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(dokumenServiceProvider).uploadDokumen(
            filePath: _selectedFile!.path!,
            fileName: _selectedFile!.name,
            jenisDokumen: _selectedJenis,
            catatanRevisi: _catatanController.text.trim().isNotEmpty 
                ? _catatanController.text.trim() 
                : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dokumen berhasil diunggah!'), backgroundColor: Colors.green),
        );
        context.pop(true); // Return true to refresh parent list
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

  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Unggah Dokumen', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              'Formulir Unggahan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Pilih kategori dokumen skripsi dan lampirkan dokumen pendukung (PDF, DOCX, DOC, atau ZIP) maksimal 10MB.',
                              style: TextStyle(color: Color(0xFF757575), fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 20),

                            // Jenis Dokumen Dropdown
                            const Text('Kategori Dokumen *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedJenis,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              items: _jenisOptions.map((opt) {
                                return DropdownMenuItem<String>(
                                  value: opt['value'],
                                  child: Text(opt['label']!, style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: widget.initialJenisDokumen != null
                                  ? null // Lock if preselected
                                  : (val) {
                                      if (val != null) {
                                        setState(() {
                                          _selectedJenis = val;
                                        });
                                      }
                                    },
                            ),
                            const SizedBox(height: 16),

                            // File Picker Widget
                            const Text('Berkas File *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickFile,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade50,
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 40,
                                      color: Color(0xFF0056A6),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _selectedFile == null ? 'Pilih file dokumen' : 'Ganti file dokumen',
                                      style: const TextStyle(
                                        color: Color(0xFF0056A6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Format file: PDF, DOC, DOCX, ZIP (Maks. 10MB)',
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Selected File Info Card
                            if (_selectedFile != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0056A6).withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF0056A6).withValues(alpha: 0.15)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 28),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedFile!.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _getFileSizeString(_selectedFile!.size),
                                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded, color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _selectedFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Catatan Revisi / Versi
                            CustomTextField(
                              label: 'Catatan Pengiriman / Keterangan Versi',
                              controller: _catatanController,
                              hint: 'Contoh: Revisi Bab I bagian rumusan masalah, dsb...',
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Unggah Sekarang',
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
