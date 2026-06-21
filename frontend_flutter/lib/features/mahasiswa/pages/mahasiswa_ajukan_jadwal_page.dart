import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/pembimbing_service.dart';
import '../services/jadwal_bimbingan_service.dart';
import '../models/pembimbing_model.dart';
import '../models/slot_bimbingan_model.dart';
import '../../../core/widgets/custom_button.dart';
 
class MahasiswaAjukanJadwalPage extends ConsumerStatefulWidget {
  const MahasiswaAjukanJadwalPage({super.key});
 
  @override
  ConsumerState<MahasiswaAjukanJadwalPage> createState() => _MahasiswaAjukanJadwalPageState();
}
 
class _MahasiswaAjukanJadwalPageState extends ConsumerState<MahasiswaAjukanJadwalPage> {
  final _formKey = GlobalKey<FormState>();
  List<PembimbingModel> _advisors = [];
  List<SlotBimbinganModel> _slots = [];
  
  int? _selectedAdvisorId;
  int? _selectedSlotId;
  DateTime? _selectedDate;
  
  bool _isLoadingAdvisors = false;
  bool _isLoadingSlots = false;
  bool _isSaving = false;
 
  @override
  void initState() {
    super.initState();
    _fetchAdvisors();
  }
 
  Future<void> _fetchAdvisors() async {
    setState(() {
      _isLoadingAdvisors = true;
    });
 
    try {
      final list = await ref.read(pembimbingServiceProvider).getMahasiswaPembimbing();
      setState(() {
        _advisors = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat pembimbing: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoadingAdvisors = false;
      });
    }
  }
 
  Future<void> _fetchSlots(int pembimbingId) async {
    setState(() {
      _isLoadingSlots = true;
      _slots = [];
      _selectedSlotId = null;
    });
 
    try {
      final list = await ref.read(jadwalBimbinganServiceProvider).getPembimbingSlots(pembimbingId);
      setState(() {
        _slots = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat slot dosen: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoadingSlots = false;
      });
    }
  }
 
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: 'Pilih Tanggal Bimbingan',
    );
 
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
 
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAdvisorId == null || _selectedSlotId == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua isian formulir.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Past date validation
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    if (selected.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilihan tidak valid: Tanggal bimbingan tidak boleh di masa lalu.'), backgroundColor: Colors.redAccent),
      );
      return;
    }
 
    setState(() {
      _isSaving = true;
    });
 
    try {
      final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      await ref.read(jadwalBimbinganServiceProvider).ajukanJadwal(
        pembimbingId: _selectedAdvisorId!,
        slotBimbinganId: _selectedSlotId!,
        tanggal: formattedDate,
      );
 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal bimbingan berhasil diajukan!'), backgroundColor: Colors.green),
        );
        context.pop();
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
        title: const Text('Ajukan Jadwal Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoadingAdvisors
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
                              'Formulir Pengajuan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Silakan tentukan dosen pembimbing, tanggal konsultasi, dan slot jam yang Anda kehendaki.',
                              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
                            ),
                            const SizedBox(height: 20),
                            
                            // 1. Advisor Selection Dropdown
                            const Text('Pilih Dosen Pembimbing *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<int>(
                              isExpanded: true,
                              initialValue: _selectedAdvisorId,
                              hint: const Text('Pilih dosen pembimbing'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              items: _advisors.map<DropdownMenuItem<int>>((p) {
                                return DropdownMenuItem<int>(
                                  value: p.id,
                                  child: Text('${p.namaDosen} (${p.peran})', style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedAdvisorId = val;
                                  });
                                  _fetchSlots(val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
 
                            // 2. Date Selection Button
                            const Text('Pilih Tanggal Bimbingan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedDate == null
                                          ? 'Pilih tanggal'
                                          : "${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}",
                                      style: TextStyle(
                                        color: _selectedDate == null ? Colors.grey.shade600 : Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today, color: Color(0xFF0056A6), size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
 
                            // 3. Slot Selection Dropdown
                            const Text('Pilih Jam Ketersediaan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            _isLoadingSlots
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    initialValue: _selectedSlotId,
                                    hint: const Text('Pilih slot ketersediaan'),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    items: _slots.map<DropdownMenuItem<int>>((s) {
                                      return DropdownMenuItem<int>(
                                        value: s.id,
                                        child: Text(
                                          '${s.hari} (${s.jamMulai} - ${s.jamSelesai}) [Kuota: ${s.kuota}]',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSlotId = val;
                                      });
                                    },
                                  ),
                            const SizedBox(height: 8),
                            const Text(
                              'Catatan: Pastikan hari pada tanggal yang Anda pilih sesuai dengan hari operasional slot waktu ketersediaan dosen pembimbing.',
                              style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Ajukan Jadwal Bimbingan',
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
