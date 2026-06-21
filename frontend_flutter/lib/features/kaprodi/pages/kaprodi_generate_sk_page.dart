import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../models/plotting_sk_model.dart';

class KaprodiGenerateSkPage extends ConsumerStatefulWidget {
  const KaprodiGenerateSkPage({super.key});

  @override
  ConsumerState<KaprodiGenerateSkPage> createState() => _KaprodiGenerateSkPageState();
}

class _KaprodiGenerateSkPageState extends ConsumerState<KaprodiGenerateSkPage> {
  final List<PlottingSkModel> _daftarPlotting = [
    PlottingSkModel(
      nim: '12200111',
      nama: 'Ahmad Fadillah',
      prodi: 'Sistem Informasi',
      dosenPembimbing: 'Dr. Ir. Budi Santoso, M.Kom',
      statusSk: 'Belum Terbit',
    ),
    PlottingSkModel(
      nim: '12200222',
      nama: 'Siti Aminah',
      prodi: 'Sistem Informasi',
      dosenPembimbing: 'Prof. Dr. Siti Aminah, S.T., M.T.',
      statusSk: 'Belum Terbit',
    ),
    PlottingSkModel(
      nim: '12200333',
      nama: 'Budi Santoso',
      prodi: 'Teknik Informatika',
      dosenPembimbing: 'Andi Saputra, M.Kom',
      statusSk: 'Sudah Terbit',
    ),
  ];

  final Set<String> _selectedIds = {};
  bool _isGenerating = false;

  void _generateSk() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih setidaknya satu mahasiswa untuk men-generate SK.')),
      );
      return;
    }

    setState(() => _isGenerating = true);
    
    // Simulate generation delay
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        for (var nim in _selectedIds) {
          final index = _daftarPlotting.indexWhere((p) => p.nim == nim);
          if (index != -1) {
            final old = _daftarPlotting[index];
            _daftarPlotting[index] = PlottingSkModel(
              nim: old.nim,
              nama: old.nama,
              prodi: old.prodi,
              dosenPembimbing: old.dosenPembimbing,
              statusSk: 'Sudah Terbit',
            );
          }
        }
      });
      
      final selectedCount = _selectedIds.length;
      setState(() {
        _selectedIds.clear();
        _isGenerating = false;
      });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Generate Selesai'),
            content: Text('$selectedCount dokumen SK Penugasan Pembimbing berhasil di-generate dan siap diunduh.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Generate SK Penugasan',
      actions: [
        if (_isGenerating)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          )
        else
          CustomButton(
            text: 'Generate SK Terpilih',
            icon: Icons.picture_as_pdf,
            onPressed: _generateSk,
          ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Plotting Pembimbing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih mahasiswa yang sudah mendapatkan pembimbing untuk dibuatkan Surat Keputusan (SK) secara massal.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                            value: _selectedIds.length == _daftarPlotting.length && _daftarPlotting.isNotEmpty,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedIds.addAll(_daftarPlotting.map((e) => e.nim));
                                } else {
                                  _selectedIds.clear();
                                }
                              });
                            },
                          ),
                          const Text('Pilih Semua'),
                        ],
                      ),
                    ),
                    const DataColumn(label: Text('Mahasiswa')),
                    const DataColumn(label: Text('Prodi')),
                    const DataColumn(label: Text('Dosen Pembimbing')),
                    const DataColumn(label: Text('Status SK')),
                    const DataColumn(label: Text('Aksi')),
                  ],
                  rows: _daftarPlotting.map((item) {
                    final isGenerated = item.statusSk == 'Sudah Terbit';
                    return DataRow(
                      selected: _selectedIds.contains(item.nim),
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedIds.add(item.nim);
                          } else {
                            _selectedIds.remove(item.nim);
                          }
                        });
                      },
                      cells: [
                        DataCell(Checkbox(
                          value: _selectedIds.contains(item.nim),
                          onChanged: (_) {},
                        )),
                        DataCell(Text('${item.nama}\n${item.nim}')),
                        DataCell(Text(item.prodi)),
                        DataCell(Text(item.dosenPembimbing)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isGenerated ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.statusSk,
                              style: TextStyle(
                                color: isGenerated ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          isGenerated
                              ? IconButton(
                                  icon: const Icon(Icons.download, color: Colors.blue),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Mengunduh SK untuk ${item.nama}...')),
                                    );
                                  },
                                  tooltip: 'Unduh SK',
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
