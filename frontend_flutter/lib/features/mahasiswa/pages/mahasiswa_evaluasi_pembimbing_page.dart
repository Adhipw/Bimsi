import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class MahasiswaEvaluasiPembimbingPage extends ConsumerStatefulWidget {
  const MahasiswaEvaluasiPembimbingPage({super.key});

  @override
  ConsumerState<MahasiswaEvaluasiPembimbingPage> createState() => _MahasiswaEvaluasiPembimbingPageState();
}

class _MahasiswaEvaluasiPembimbingPageState extends ConsumerState<MahasiswaEvaluasiPembimbingPage> {
  final Map<int, int> _ratings = {};
  final TextEditingController _saranController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _questions = [
    'Dosen pembimbing mudah ditemui untuk konsultasi.',
    'Dosen pembimbing memberikan umpan balik (feedback) yang konstruktif.',
    'Dosen pembimbing membantu mengarahkan dalam menyelesaikan masalah penelitian.',
    'Dosen pembimbing memberikan waktu yang cukup saat proses bimbingan.',
    'Secara keseluruhan, saya puas dengan proses bimbingan skripsi ini.',
  ];

  void _submitEvaluasi() async {
    if (_ratings.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua pertanyaan kuisioner sebelum menyimpan.'), backgroundColor: Colors.red),
      );
      return;
    }

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
          content: const Text('Terima kasih, evaluasi Anda telah tersimpan.'),
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

  @override
  void dispose() {
    _saranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Evaluasi Pembimbing',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kuisioner Evaluasi Dosen Pembimbing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Penilaian ini bersifat rahasia dan akan digunakan untuk meningkatkan kualitas bimbingan skripsi di masa mendatang.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. $question', style: const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(5, (starIndex) {
                              final ratingValue = starIndex + 1;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _ratings[index] = ratingValue;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _ratings[index] != null && _ratings[index]! >= ratingValue
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(ratingValue.toString(), style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sangat Kurang', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text('Sangat Baik', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  
                  const Divider(height: 32),
                  const Text('Saran & Masukan (Opsional)', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _saranController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan saran atau masukan Anda di sini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _isSubmitting ? 'Menyimpan...' : 'Kirim Evaluasi',
                      onPressed: _isSubmitting ? null : _submitEvaluasi,
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
