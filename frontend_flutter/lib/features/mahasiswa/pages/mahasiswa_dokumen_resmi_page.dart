import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/dokumen_resmi_model.dart';

class MahasiswaDokumenResmiPage extends ConsumerWidget {
  const MahasiswaDokumenResmiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<DokumenResmiModel> dokumenList = [
      DokumenResmiModel(
        nama: 'Surat Tugas Pembimbing',
        tanggal: '10 Feb 2024',
        keterangan: 'Surat resmi penetapan dosen pembimbing skripsi.',
        ukuran: '1.2 MB',
        url: '#',
      ),
      DokumenResmiModel(
        nama: 'Surat Undangan Sidang',
        tanggal: '15 Mei 2024',
        keterangan: 'Undangan resmi pelaksanaan sidang skripsi komprehensif.',
        ukuran: '850 KB',
        url: '#',
      ),
      DokumenResmiModel(
        nama: 'Berita Acara Sidang',
        tanggal: '20 Mei 2024',
        keterangan: 'Catatan dan hasil nilai sidang yang telah divalidasi.',
        ukuran: '2.1 MB',
        url: '#',
      ),
    ];

    return ResponsiveScaffold(
      title: 'Dokumen Resmi',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unduh Dokumen Skripsi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikut adalah dokumen-dokumen resmi terkait proses bimbingan dan sidang skripsi Anda.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dokumenList.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final doc = dokumenList[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(doc.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(doc.keterangan),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(doc.tanggal, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const SizedBox(width: 16),
                            Icon(Icons.sd_storage_outlined, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(doc.ukuran, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ],
                    trailing: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mengunduh dokumen ${doc.nama}...')),
                        );
                      },
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Unduh'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
