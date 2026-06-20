import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/services/slot_bimbingan_service.dart';
import '../../mahasiswa/models/slot_bimbingan_model.dart';
import '../../../core/widgets/custom_text_field.dart';
 
class DosenSlotBimbinganPage extends ConsumerStatefulWidget {
  const DosenSlotBimbinganPage({super.key});
 
  @override
  ConsumerState<DosenSlotBimbinganPage> createState() => _DosenSlotBimbinganPageState();
}
 
class _DosenSlotBimbinganPageState extends ConsumerState<DosenSlotBimbinganPage> {
  List<SlotBimbinganModel> _slots = [];
  bool _isLoading = false;
  bool _isSaving = false;
 
  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }
 
  Future<void> _fetchSlots() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(slotBimbinganServiceProvider);
      final list = await service.getDosenSlots();
      setState(() {
        _slots = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat slot bimbingan: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  Future<void> _deleteSlot(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Slot Bimbingan', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus ketersediaan slot bimbingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF44336), foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
 
    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        final service = ref.read(slotBimbinganServiceProvider);
        await service.deleteSlot(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slot bimbingan berhasil dihapus.'), backgroundColor: Colors.green),
        );
        _fetchSlots();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
 
  Future<void> _showAddSlotDialog() async {
    final formKey = GlobalKey<FormState>();
    String selectedHari = 'Senin';
    final jamMulaiController = TextEditingController(text: '09:00');
    final jamSelesaiController = TextEditingController(text: '10:00');
    final kuotaController = TextEditingController(text: '5');
 
    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Slot Ketersediaan', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hari Ketersediaan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedHari,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
                            .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedHari = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Jam Mulai (Format HH:MM)',
                        controller: jamMulaiController,
                        hint: '09:00',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Jam mulai wajib diisi';
                          final reg = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                          if (!reg.hasMatch(v)) return 'Format jam salah (contoh: 09:00)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Jam Selesai (Format HH:MM)',
                        controller: jamSelesaiController,
                        hint: '10:00',
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Jam selesai wajib diisi';
                          final reg = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                          if (!reg.hasMatch(v)) return 'Format jam salah (contoh: 10:00)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Kuota Maksimal Mahasiswa',
                        controller: kuotaController,
                        hint: '5',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Kuota wajib diisi';
                          final num = int.tryParse(v);
                          if (num == null || num <= 0) return 'Kuota harus angka positif';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, false),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogCtx, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056A6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
 
    if (save == true) {
      setState(() {
        _isSaving = true;
      });
 
      try {
        final service = ref.read(slotBimbinganServiceProvider);
        await service.createSlot(
          hari: selectedHari,
          jamMulai: jamMulaiController.text,
          jamSelesai: jamSelesaiController.text,
          kuota: int.parse(kuotaController.text),
        );
 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slot bimbingan berhasil ditambahkan!'), backgroundColor: Colors.green),
        );
        _fetchSlots();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
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
        title: const Text('Atur Slot Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading || _isSaving
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchSlots,
              child: _slots.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _slots.length,
                      itemBuilder: (context, index) {
                        final slot = _slots[index];
                        return _buildSlotCard(slot);
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSlotDialog,
        backgroundColor: const Color(0xFF0056A6),
        foregroundColor: Colors.white,
        tooltip: 'Tambah Slot Ketersediaan',
        child: const Icon(Icons.add),
      ),
    );
  }
 
  Widget _buildSlotCard(SlotBimbinganModel slot) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time_filled, color: Color(0xFF0056A6), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.hari,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${slot.jamMulai} - ${slot.jamSelesai}',
                    style: const TextStyle(color: Color(0xFF555555), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kuota: ${slot.kuota} Mahasiswa',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFF44336)),
              tooltip: 'Hapus Slot',
              onPressed: () => _deleteSlot(slot.id),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF0056A6),
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Slot Ketersediaan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda belum menentukan hari dan slot jam ketersediaan bimbingan mingguan Anda.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
