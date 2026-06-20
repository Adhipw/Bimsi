import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../services/kaprodi_penguji_service.dart';
import '../../mahasiswa/services/pembimbing_service.dart';

class KaprodiPenetapanPengujiPage extends ConsumerStatefulWidget {
  const KaprodiPenetapanPengujiPage({super.key});

  @override
  ConsumerState<KaprodiPenetapanPengujiPage> createState() => _KaprodiPenetapanPengujiPageState();
}

class _KaprodiPenetapanPengujiPageState extends ConsumerState<KaprodiPenetapanPengujiPage> {
  bool _isLoading = false;
  List<dynamic> _dosenList = [];
  int? _selectedPenguji1;
  int? _selectedPenguji2;

  @override
  void initState() {
    super.initState();
    _fetchDosen();
  }

  Future<void> _fetchDosen() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(pembimbingServiceProvider);
      final list = await service.getKaprodiDosenList();
      setState(() => _dosenList = list);
    } catch (e) {
      // Error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _assignPenguji(int sidangId) {
    if (_dosenList.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Tetapkan Dosen Penguji'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Penguji 1', border: OutlineInputBorder()),
                    value: _selectedPenguji1,
                    items: _dosenList.map((d) {
                      return DropdownMenuItem<int>(
                        value: d['id'],
                        child: Text(d['user']['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setStateDialog(() => _selectedPenguji1 = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Penguji 2', border: OutlineInputBorder()),
                    value: _selectedPenguji2,
                    items: _dosenList.map((d) {
                      return DropdownMenuItem<int>(
                        value: d['id'],
                        child: Text(d['user']['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setStateDialog(() => _selectedPenguji2 = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (_selectedPenguji1 == null || _selectedPenguji2 == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih kedua penguji.')));
                      return;
                    }
                    if (_selectedPenguji1 == _selectedPenguji2) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Penguji 1 dan 2 tidak boleh sama.')));
                      return;
                    }

                    try {
                      final service = ref.read(kaprodiPengujiServiceProvider);
                      await service.assignPenguji(sidangId, _selectedPenguji1!, _selectedPenguji2!);
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ref.invalidate(kaprodiSidangMenungguPengujiProvider);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Penguji berhasil ditetapkan.')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(kaprodiSidangMenungguPengujiProvider);

    return ResponsiveScaffold(
      title: 'Penetapan Dosen Penguji',
      body: listAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Tidak ada pendaftaran sidang yang menunggu penguji.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final sidang = list[index];
              final mhs = sidang['mahasiswa']['user']['name'];
              final judul = sidang['pengajuan_judul']['judul'];
              final jenis = sidang['jenis_sidang'] == 'sempro' ? 'Sidang Sempro' : 'Sidang Akhir';
              final pengujis = sidang['pengujis'] as List<dynamic>;
              
              final isAssigned = pengujis.length >= 2;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(jenis),
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(color: Colors.blue),
                          ),
                          if (isAssigned)
                            const Chip(
                              label: Text('Selesai Diplot'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(mhs, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(judul, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      if (isAssigned) ...[
                        const Text('Penguji 1:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(pengujis.firstWhere((p) => p['peran'] == 'Penguji 1', orElse: () => {'dosen': {'user': {'name': '-'}}})['dosen']['user']['name']),
                        const SizedBox(height: 4),
                        const Text('Penguji 2:', style: TextStyle(fontWeight: FontWeight.w500)),
                        Text(pengujis.firstWhere((p) => p['peran'] == 'Penguji 2', orElse: () => {'dosen': {'user': {'name': '-'}}})['dosen']['user']['name']),
                      ] else ...[
                        _isLoading
                          ? const CircularProgressIndicator()
                          : Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                onPressed: () => _assignPenguji(sidang['id']),
                                icon: const Icon(Icons.person_add),
                                label: const Text('Tetapkan Penguji'),
                              ),
                            ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
