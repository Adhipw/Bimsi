import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../services/admin_akademik_service.dart';

class AdminPlottingJadwalPage extends ConsumerStatefulWidget {
  const AdminPlottingJadwalPage({super.key});

  @override
  ConsumerState<AdminPlottingJadwalPage> createState() => _AdminPlottingJadwalPageState();
}

class _AdminPlottingJadwalPageState extends ConsumerState<AdminPlottingJadwalPage> {
  bool _isLoading = false;
  List<dynamic> _ruanganList = [];
  
  final Map<int, DateTime> _selectedDates = {};
  final Map<int, TimeOfDay> _selectedStartTimes = {};
  final Map<int, TimeOfDay> _selectedEndTimes = {};
  final Map<int, int> _selectedRuangans = {};

  @override
  void initState() {
    super.initState();
    _fetchRuangans();
  }

  Future<void> _fetchRuangans() async {
    try {
      final service = ref.read(adminAkademikServiceProvider);
      final list = await service.getRuangans();
      if (mounted) {
        setState(() => _ruanganList = list);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _selectDate(BuildContext context, int id) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDates[id] = date);
    }
  }

  Future<void> _selectTime(BuildContext context, int id, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStart) _selectedStartTimes[id] = time;
        else _selectedEndTimes[id] = time;
      });
    }
  }

  String _formatDate(DateTime date) => "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  String _formatTime(TimeOfDay time) => "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  void _simpanJadwal(int sidangId) async {
    if (_selectedDates[sidangId] == null || _selectedStartTimes[sidangId] == null || 
        _selectedEndTimes[sidangId] == null || _selectedRuangans[sidangId] == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua form jadwal')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final service = ref.read(adminAkademikServiceProvider);
      await service.plotJadwal(
        sidangId: sidangId,
        tanggal: _formatDate(_selectedDates[sidangId]!),
        waktuMulai: _formatTime(_selectedStartTimes[sidangId]!),
        waktuSelesai: _formatTime(_selectedEndTimes[sidangId]!),
        ruanganId: _selectedRuangans[sidangId]!,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jadwal berhasil disimpan')));
        ref.invalidate(adminSidangMenungguJadwalProvider);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _downloadSK(int sidangId) async {
    try {
      final service = ref.read(adminAkademikServiceProvider);
      await service.downloadPdf('/admin/sidang/$sidangId/generate-sk-pembimbing', 'SK_Pembimbing_$sidangId.pdf');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _downloadBA(int sidangId) async {
    try {
      final service = ref.read(adminAkademikServiceProvider);
      await service.downloadPdf('/admin/sidang/$sidangId/generate-berita-acara', 'Berita_Acara_$sidangId.pdf');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(adminSidangMenungguJadwalProvider);

    return ResponsiveScaffold(
      title: 'Plotting Jadwal Sidang',
      body: asyncData.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('Tidak ada jadwal sidang yang menunggu diplot.'));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final sidang = list[index];
              final id = sidang['id'];
              final mhs = sidang['mahasiswa']['user']['name'];
              final judul = sidang['pengajuan_judul']['judul'];
              final jenis = sidang['jenis_sidang'];
              final isScheduled = sidang['tanggal_sidang'] != null;

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
                          Chip(label: Text(jenis == 'sempro' ? 'Sempro' : 'Sidang Akhir')),
                          if (isScheduled) 
                            const Chip(label: Text('Sudah Dijadwalkan'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white))
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(mhs, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(judul, style: const TextStyle(color: Colors.grey)),
                      const Divider(height: 32),

                      if (!isScheduled) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _selectDate(context, id),
                                icon: const Icon(Icons.calendar_today, size: 18),
                                label: Text(_selectedDates[id] != null ? _formatDate(_selectedDates[id]!) : 'Pilih Tanggal'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _selectTime(context, id, true),
                                icon: const Icon(Icons.access_time, size: 18),
                                label: Text(_selectedStartTimes[id] != null ? _formatTime(_selectedStartTimes[id]!) : 'Mulai'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _selectTime(context, id, false),
                                icon: const Icon(Icons.access_time, size: 18),
                                label: Text(_selectedEndTimes[id] != null ? _formatTime(_selectedEndTimes[id]!) : 'Selesai'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<int>(
                                decoration: const InputDecoration(labelText: 'Ruangan', border: OutlineInputBorder()),
                                value: _selectedRuangans[id],
                                items: _ruanganList.map((r) => DropdownMenuItem<int>(
                                  value: r['id'],
                                  child: Text(r['nama_ruangan']),
                                )).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedRuangans[id] = val);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: _isLoading ? null : () => _simpanJadwal(id),
                              child: const Text('Simpan Jadwal'),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text('Jadwal: ${sidang['tanggal_sidang']} | ${sidang['waktu_mulai']} - ${sidang['waktu_selesai']}'),
                        Text('Ruangan: ${sidang['ruangan']['nama_ruangan']}'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _downloadSK(id),
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Cetak SK Pembimbing'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () => _downloadBA(id),
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Cetak Berita Acara'),
                            ),
                          ],
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
