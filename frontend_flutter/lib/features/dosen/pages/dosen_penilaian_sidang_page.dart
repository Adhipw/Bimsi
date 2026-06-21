import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class DosenPenilaianSidangPage extends ConsumerStatefulWidget {
  const DosenPenilaianSidangPage({super.key});

  @override
  ConsumerState<DosenPenilaianSidangPage> createState() => _DosenPenilaianSidangPageState();
}

class _DosenPenilaianSidangPageState extends ConsumerState<DosenPenilaianSidangPage> {
  final Map<String, double> _nilaiRubrik = {
    'Presentasi (30%)': 0,
    'Materi Skripsi (40%)': 0,
    'Tanya Jawab (30%)': 0,
  };
  final TextEditingController _catatanController = TextEditingController();
  bool _isSubmitting = false;

  void _submitNilai() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Nilai sidang berhasil disimpan dan diteruskan ke Kaprodi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  double get _totalNilai {
    double total = 0;
    total += (_nilaiRubrik['Presentasi (30%)'] ?? 0) * 0.3;
    total += (_nilaiRubrik['Materi Skripsi (40%)'] ?? 0) * 0.4;
    total += (_nilaiRubrik['Tanya Jawab (30%)'] ?? 0) * 0.3;
    return total;
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Penilaian Sidang Skripsi',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Penilaian Sidang',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan masukkan nilai berdasarkan rubrik. Skala nilai adalah 0 - 100.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Identitas Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text('NIM: 12345678'),
                  const Text('Nama: Budi Santoso'),
                  const Text('Judul: Implementasi Flutter untuk Aplikasi Manajemen'),
                  const Divider(height: 32),
                  
                  const Text('Rubrik Penilaian (0-100)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ..._nilaiRubrik.keys.map((key) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(key, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text('${_nilaiRubrik[key]?.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Slider(
                            value: _nilaiRubrik[key] ?? 0,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                _nilaiRubrik[key] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Nilai Akhir:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        _totalNilai.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 24, 
                          color: _totalNilai >= 60 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  
                  const Text('Catatan / Revisi untuk Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _catatanController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan catatan perbaikan atau revisi di sini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _isSubmitting ? 'Menyimpan...' : 'Simpan Nilai & Catatan',
                      onPressed: _isSubmitting ? null : _submitNilai,
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
