import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mahasiswa/models/jadwal_bimbingan_model.dart';
import '../../mahasiswa/services/riwayat_bimbingan_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class DosenInputRiwayatBimbinganPage extends ConsumerStatefulWidget {
  final int? preSelectedJadwalId;

  const DosenInputRiwayatBimbinganPage({
    super.key,
    this.preSelectedJadwalId,
  });

  @override
  ConsumerState<DosenInputRiwayatBimbinganPage> createState() => _DosenInputRiwayatBimbinganPageState();
}

class _DosenInputRiwayatBimbinganPageState extends ConsumerState<DosenInputRiwayatBimbinganPage> {
  final _formKey = GlobalKey<FormState>();
  List<JadwalBimbinganModel> _approvedSchedules = [];
  int? _selectedJadwalId;
  JadwalBimbinganModel? _selectedJadwalDetails;

  final _catatanDosenController = TextEditingController();
  final _catatanMahasiswaController = TextEditingController();
  String _selectedStatus = 'selesai'; // 'selesai' or 'revisi'

  bool _isLoadingSchedules = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedJadwalId = widget.preSelectedJadwalId;
    _fetchApprovedSchedules();
  }

  @override
  void dispose() {
    _catatanDosenController.dispose();
    _catatanMahasiswaController.dispose();
    super.dispose();
  }

  Future<void> _fetchApprovedSchedules() async {
    setState(() {
      _isLoadingSchedules = true;
    });

    try {
      final list = await ref.read(riwayatBimbinganServiceProvider).getDosenApprovedJadwal();
      setState(() {
        _approvedSchedules = list;
        // If we have a pre-selected ID, try to find details
        if (_selectedJadwalId != null) {
          final found = list.where((item) => item.id == _selectedJadwalId);
          if (found.isNotEmpty) {
            _selectedJadwalDetails = found.first;
          } else {
            // Preselected schedule is not in the list (might already have history, or not approved)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jadwal bimbingan yang dipilih tidak tersedia atau sudah memiliki riwayat.'),
                backgroundColor: Colors.orangeAccent,
              ),
            );
            _selectedJadwalId = null;
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat jadwal approved: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSchedules = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedJadwalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua isian wajib formulir.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(riwayatBimbinganServiceProvider).storeRiwayat(
            jadwalBimbinganId: _selectedJadwalId!,
            catatanDosen: _catatanDosenController.text.trim(),
            status: _selectedStatus,
            catatanMahasiswa: _catatanMahasiswaController.text.trim().isNotEmpty 
                ? _catatanMahasiswaController.text.trim() 
                : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat bimbingan berhasil disimpan!'), backgroundColor: Colors.green),
        );
        context.pop(true); // Return success to reload list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Input Riwayat Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoadingSchedules
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Data Pertemuan Bimbingan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                            ),
                            const SizedBox(height: 14),

                            // Dropdown/Selector for Schedule
                            const Text('Pilih Pertemuan Bimbingan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            if (widget.preSelectedJadwalId != null && _selectedJadwalDetails != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedJadwalDetails!.namaMahasiswa ?? 'Mahasiswa',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'NIM: ${_selectedJadwalDetails!.nimMahasiswa ?? "-"} | Kelas: ${_selectedJadwalDetails!.kelasMahasiswa ?? "-"}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Tanggal: ${_selectedJadwalDetails!.tanggal} (${_selectedJadwalDetails!.slotBimbingan?.hari ?? ""}, ${_selectedJadwalDetails!.slotBimbingan?.jamMulai ?? ""} - ${_selectedJadwalDetails!.slotBimbingan?.jamSelesai ?? ""})',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF0056A6)),
                                    ),
                                  ],
                                ),
                              )
                            else
                              DropdownButtonFormField<int>(
                                isExpanded: true,
                                initialValue: _selectedJadwalId,
                                hint: const Text('Pilih jadwal pertemuan mahasiswa'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: _approvedSchedules.map((j) {
                                  return DropdownMenuItem<int>(
                                    value: j.id,
                                    child: Text(
                                      '${j.namaMahasiswa ?? "Mhs"} - ${j.nimMahasiswa ?? ""} [${j.tanggal}]',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedJadwalId = val;
                                      _selectedJadwalDetails = _approvedSchedules.firstWhere((item) => item.id == val);
                                    });
                                  }
                                },
                                validator: (v) => v == null ? 'Jadwal bimbingan wajib dipilih' : null,
                              ),
                            const SizedBox(height: 16),

                            if (_selectedJadwalDetails != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0056A6).withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF0056A6).withValues(alpha: 0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Judul Skripsi:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedJadwalDetails!.judulSkripsi ?? '-',
                                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF333333)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Form Catatan Dosen
                            CustomTextField(
                              label: 'Catatan Bimbingan & Revisi Dosen *',
                              controller: _catatanDosenController,
                              hint: 'Tuliskan catatan pembahasan bimbingan, arahan dosen, serta detail bagian skripsi yang harus direvisi...',
                              maxLines: 5,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Catatan bimbingan dan revisi wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Form Catatan Mahasiswa
                            CustomTextField(
                              label: 'Catatan Mahasiswa (Opsional)',
                              controller: _catatanMahasiswaController,
                              hint: 'Keterangan tambahan dari mahasiswa (jika ada)...',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),

                            // Status Revisi Selector
                            const Text('Status Revisi / Hasil Bimbingan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(
                                      child: Text(
                                        'Revisi (Butuh Revisi)',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    selected: _selectedStatus == 'revisi',
                                    selectedColor: const Color(0xFFF44336).withValues(alpha: 0.15),
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _selectedStatus == 'revisi' ? const Color(0xFFD32F2F) : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: _selectedStatus == 'revisi' ? const Color(0xFFF44336) : Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _selectedStatus = 'revisi';
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ChoiceChip(
                                    label: const Center(
                                      child: Text(
                                        'Selesai (Lanjut/Lulus)',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    selected: _selectedStatus == 'selesai',
                                    selectedColor: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _selectedStatus == 'selesai' ? const Color(0xFF388E3C) : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: _selectedStatus == 'selesai' ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _selectedStatus = 'selesai';
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Simpan Riwayat Bimbingan',
                      isLoading: _isSaving,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
