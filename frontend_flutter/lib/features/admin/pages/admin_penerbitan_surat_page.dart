import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/mahasiswa_bebas_pustaka_model.dart';

class AdminPenerbitanSuratPage extends ConsumerStatefulWidget {
  const AdminPenerbitanSuratPage({super.key});

  @override
  ConsumerState<AdminPenerbitanSuratPage> createState() => _AdminPenerbitanSuratPageState();
}

class _AdminPenerbitanSuratPageState extends ConsumerState<AdminPenerbitanSuratPage> {
  final List<MahasiswaBebasPustakaModel> _mahasiswaList = [
    MahasiswaBebasPustakaModel(
      nim: '12200111',
      nama: 'Ahmad Fadillah',
      prodi: 'Sistem Informasi',
      statusRevisi: 'ACC Pembimbing & Penguji',
      suratBebasTerbit: false,
    ),
    MahasiswaBebasPustakaModel(
      nim: '12200222',
      nama: 'Siti Aminah',
      prodi: 'Sistem Informasi',
      statusRevisi: 'Menunggu ACC Penguji 2',
      suratBebasTerbit: false,
    ),
    MahasiswaBebasPustakaModel(
      nim: '12200333',
      nama: 'Budi Santoso',
      prodi: 'Teknik Informatika',
      statusRevisi: 'ACC Pembimbing & Penguji',
      suratBebasTerbit: true,
    ),
  ];

  void _terbitkanSurat(int index) {
    setState(() {
      _mahasiswaList[index].suratBebasTerbit = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Surat Bebas Pustaka/Revisi untuk ${_mahasiswaList[index].nama} diterbitkan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Penerbitan Surat Bebas',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verifikasi Akhir Pendaftaran Wisuda',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Terbitkan Surat Keterangan Bebas Pustaka & Revisi bagi mahasiswa yang telah menyelesaikan semua tanggungan akademik dan administratif pasca sidang.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Mahasiswa')),
                    DataColumn(label: Text('Status Revisi Sidang')),
                    DataColumn(label: Text('Status Surat Bebas')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(_mahasiswaList.length, (index) {
                    final mhs = _mahasiswaList[index];
                    final bool isAccRevisi = mhs.statusRevisi.contains('ACC Pembimbing & Penguji');
                    final bool isBebasPustaka = mhs.suratBebasTerbit;

                    return DataRow(
                      cells: [
                        DataCell(Text('${mhs.nama}\n${mhs.nim}', style: const TextStyle(fontWeight: FontWeight.w500))),
                        DataCell(
                          Text(
                            mhs.statusRevisi,
                            style: TextStyle(
                              color: isAccRevisi ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isBebasPustaka ? Colors.blue.withOpacity(0.1) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isBebasPustaka ? 'Sudah Terbit' : 'Belum Terbit',
                              style: TextStyle(
                                color: isBebasPustaka ? Colors.blue : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          isBebasPustaka
                              ? Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Mengunduh salinan surat...')),
                                        );
                                      },
                                      child: const Text('Unduh PDF'),
                                    ),
                                  ],
                                )
                              : ElevatedButton(
                                  onPressed: isAccRevisi ? () => _terbitkanSurat(index) : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isAccRevisi ? Colors.blue : Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Terbitkan Surat'),
                                ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
