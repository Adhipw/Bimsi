import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/dosen_kuota_model.dart';

class AdminManajemenKuotaPage extends ConsumerStatefulWidget {
  const AdminManajemenKuotaPage({super.key});

  @override
  ConsumerState<AdminManajemenKuotaPage> createState() => _AdminManajemenKuotaPageState();
}

class _AdminManajemenKuotaPageState extends ConsumerState<AdminManajemenKuotaPage> {
  final List<DosenKuotaModel> _dosenList = [
    DosenKuotaModel(
      nidn: '0123456789',
      nama: 'Dr. Ir. Budi Santoso, M.Kom',
      jabatan: 'Lektor Kepala',
      kuotaMaksimal: 12,
      terisi: 8,
    ),
    DosenKuotaModel(
      nidn: '0987654321',
      nama: 'Prof. Dr. Siti Aminah, S.T., M.T.',
      jabatan: 'Guru Besar',
      kuotaMaksimal: 15,
      terisi: 15,
    ),
    DosenKuotaModel(
      nidn: '1122334455',
      nama: 'Ahmad Dahlan, S.Kom., M.Kom',
      jabatan: 'Asisten Ahli',
      kuotaMaksimal: 8,
      terisi: 6,
    ),
    DosenKuotaModel(
      nidn: '2233445566',
      nama: 'Joko Anwar, M.Cs',
      jabatan: 'Asisten Ahli',
      kuotaMaksimal: 8,
      terisi: 8,
    ),
    DosenKuotaModel(
      nidn: '3344556677',
      nama: 'Rina Mulyani, S.Kom., M.TI',
      jabatan: 'Lektor',
      kuotaMaksimal: 10,
      terisi: 4,
    ),
  ];

  void _updateKuota(int index, int newKuota) {
    setState(() {
      _dosenList[index].kuotaMaksimal = newKuota;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kuota ${_dosenList[index].nama} berhasil diperbarui.')),
    );
  }

  void _showEditKuotaDialog(DosenKuotaModel dosen, int index) {
    final TextEditingController controller = TextEditingController(text: dosen.kuotaMaksimal.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kuota Maksimal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dosen: ${dosen.nama}'),
              Text('Jabatan: ${dosen.jabatan}'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kuota Maksimal',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final newKuota = int.tryParse(controller.text) ?? dosen.kuotaMaksimal;
                _updateKuota(index, newKuota);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Manajemen Kuota Pembimbing',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Dosen & Kuota Bimbingan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola batas maksimal mahasiswa yang dapat dibimbing oleh setiap dosen berdasarkan jabatan fungsional akademik.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nama Dosen')),
                    DataColumn(label: Text('Jabatan Akademik')),
                    DataColumn(label: Text('Kuota Maksimal', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Terpakai', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(_dosenList.length, (index) {
                    final dosen = _dosenList[index];
                    final bool isFull = dosen.terisi >= dosen.kuotaMaksimal;
                    return DataRow(
                      cells: [
                        DataCell(Text(dosen.nama, style: const TextStyle(fontWeight: FontWeight.w500))),
                        DataCell(Text(dosen.jabatan)),
                        DataCell(Center(child: Text('${dosen.kuotaMaksimal}', style: const TextStyle(fontWeight: FontWeight.bold)))),
                        DataCell(Center(child: Text('${dosen.terisi}'))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isFull ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              isFull ? 'Penuh' : 'Tersedia',
                              style: TextStyle(
                                color: isFull ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditKuotaDialog(dosen, index),
                            tooltip: 'Ubah Kuota',
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
