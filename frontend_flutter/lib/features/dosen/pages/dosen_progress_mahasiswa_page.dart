import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/services/progress_skripsi_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';

class DosenProgressMahasiswaPage extends ConsumerStatefulWidget {
  final int pengajuanJudulId;
  final String namaMahasiswa;

  const DosenProgressMahasiswaPage({
    Key? key,
    required this.pengajuanJudulId,
    required this.namaMahasiswa,
  }) : super(key: key);

  @override
  ConsumerState<DosenProgressMahasiswaPage> createState() => _DosenProgressMahasiswaPageState();
}

class _DosenProgressMahasiswaPageState extends ConsumerState<DosenProgressMahasiswaPage> {
  bool _isLoading = false;
  
  final List<String> _babOptions = ['BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5'];
  final List<String> _statusOptions = ['Revisi', 'Disetujui'];
  
  String _selectedBab = 'BAB 1';
  String _selectedStatus = 'Disetujui';
  final TextEditingController _keteranganController = TextEditingController();

  Future<void> _updateProgress() async {
    setState(() {
      _isLoading = true;
    });

    final _service = ref.read(progressSkripsiServiceProvider);
    final result = await _service.updateProgressDosen(
      widget.pengajuanJudulId,
      _selectedBab,
      _selectedStatus,
      _keteranganController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress berhasil diupdate'), backgroundColor: Colors.green),
      );
      _keteranganController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal update progress'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Progress Skripsi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AppCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mahasiswa Bimbingan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.namaMahasiswa,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 32),
                  const Text('Pilih BAB', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBab,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    items: _babOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedBab = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    items: _statusOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Keterangan / Catatan', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _keteranganController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Masukkan catatan tambahan untuk revisi atau persetujuan...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Simpan Progress',
                      isLoading: _isLoading,
                      onPressed: _updateProgress,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
