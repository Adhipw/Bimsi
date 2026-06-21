import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class DosenDelegasiCutiPage extends ConsumerStatefulWidget {
  const DosenDelegasiCutiPage({super.key});

  @override
  ConsumerState<DosenDelegasiCutiPage> createState() => _DosenDelegasiCutiPageState();
}

class _DosenDelegasiCutiPageState extends ConsumerState<DosenDelegasiCutiPage> {
  final TextEditingController _alasanController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedDosenPengganti;
  bool _isSubmitting = false;

  final List<String> _dosenList = [
    'Dr. Ir. Budi Santoso, M.Kom',
    'Prof. Dr. Siti Aminah, S.T., M.T.',
    'Ahmad Dahlan, S.Kom., M.Kom',
  ];

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submitPengajuan() async {
    if (_startDate == null || _endDate == null || _alasanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi tanggal dan alasan cuti.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Pengajuan cuti/delegasi berhasil dikirim ke Kaprodi untuk persetujuan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Pengajuan Delegasi / Cuti',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Pengajuan Cuti Akademik',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Gunakan form ini jika Anda berhalangan hadir atau cuti, sehingga mahasiswa bimbingan Anda dapat didelegasikan sementara ke dosen lain.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rentang Waktu Cuti', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDateRange,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _startDate != null && _endDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Pilih Tanggal Mulai & Selesai',
                            style: TextStyle(color: _startDate != null ? Colors.black87 : Colors.grey.shade600),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Alasan Cuti / Keterangan', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alasanController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Misal: Ibadah Umroh, Tugas Luar Kota, Sakit...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Usulan Dosen Pengganti (Opsional)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    hint: const Text('Pilih Dosen Pengganti...'),
                    value: _selectedDosenPengganti,
                    items: _dosenList.map((String dosen) {
                      return DropdownMenuItem<String>(
                        value: dosen,
                        child: Text(dosen),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDosenPengganti = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _isSubmitting ? 'Mengirim Pengajuan...' : 'Kirim Pengajuan ke Kaprodi',
                      onPressed: _isSubmitting ? null : _submitPengajuan,
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
