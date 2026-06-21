import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import 'package:file_picker/file_picker.dart';

class MahasiswaRevisiSidangPage extends ConsumerStatefulWidget {
  const MahasiswaRevisiSidangPage({super.key});

  @override
  ConsumerState<MahasiswaRevisiSidangPage> createState() => _MahasiswaRevisiSidangPageState();
}

class _MahasiswaRevisiSidangPageState extends ConsumerState<MahasiswaRevisiSidangPage> {
  bool _isUploading = false;
  String _status = 'Menunggu Unggah Revisi';
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Validate max 10MB
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
          SnackBar(content: Text('Gagal memilih file: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _uploadRevisi() async {
    setState(() {
      _isUploading = true;
    });
    
    // Simulasi proses upload
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isUploading = false;
        _status = 'Menunggu ACC Penguji';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dokumen revisi berhasil diunggah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Revisi Pasca Sidang',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unggah Dokumen Revisi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan dokumen yang diunggah telah diperbaiki sesuai catatan penguji.',
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
                      Icon(Icons.assignment_turned_in, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text('Status Revisi: $_status', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        if (_selectedFile == null) ...[
                          Icon(Icons.upload_file, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text('Klik untuk memilih file PDF/DOCX (Max 10MB)'),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Pilih File',
                            onPressed: _isUploading ? null : _pickFile,
                          ),
                        ] else ...[
                          Icon(Icons.description, size: 48, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFile!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _isUploading ? null : _pickFile,
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Ganti'),
                              ),
                              const SizedBox(width: 8),
                              CustomButton(
                                text: _isUploading ? 'Mengunggah...' : 'Unggah Revisi',
                                onPressed: _isUploading ? null : _uploadRevisi,
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Catatan Penguji:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '- Perbaiki penulisan abstrak\n- Tambahkan referensi tahun terbaru di Bab 2\n- Sesuaikan margin format penulisan',
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
