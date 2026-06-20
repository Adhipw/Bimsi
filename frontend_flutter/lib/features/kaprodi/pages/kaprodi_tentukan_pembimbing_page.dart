import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/services/pembimbing_service.dart';
import '../../mahasiswa/models/pengajuan_judul_model.dart';
import '../../../core/widgets/custom_button.dart';
 
class KaprodiTentukanPembimbingPage extends ConsumerStatefulWidget {
  const KaprodiTentukanPembimbingPage({super.key});
 
  @override
  ConsumerState<KaprodiTentukanPembimbingPage> createState() => _KaprodiTentukanPembimbingPageState();
}
 
class _KaprodiTentukanPembimbingPageState extends ConsumerState<KaprodiTentukanPembimbingPage> {
  List<PengajuanJudulModel> _students = [];
  List<dynamic> _dosens = [];
  bool _isLoading = false;
  bool _isSaving = false;
 
  @override
  void initState() {
    super.initState();
    _fetchData();
  }
 
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(pembimbingServiceProvider);
      final studentsList = await service.getKaprodiMahasiswaDisetujui();
      final dosensList = await service.getKaprodiDosenList();
      setState(() {
        _students = studentsList;
        _dosens = dosensList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  Future<void> _showAssignDialog(PengajuanJudulModel student) async {
    int? selectedP1DosenId;
    int? selectedP2DosenId;
 
    // Cari pembimbing yang sudah ter-assign sebelumnya
    for (var p in student.pembimbings) {
      if (p.peran == 'Pembimbing 1') {
        selectedP1DosenId = p.dosenId;
      } else if (p.peran == 'Pembimbing 2') {
        selectedP2DosenId = p.dosenId;
      }
    }
 
    final result = await showDialog<Map<String, int?>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alokasikan Pembimbing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    student.namaMahasiswa ?? 'Mahasiswa',
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pembimbing 1 Dropdown
                    const Text('Dosen Pembimbing 1 (Utama) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: selectedP1DosenId,
                      hint: const Text('Pilih Pembimbing 1'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _dosens.map<DropdownMenuItem<int>>((dosen) {
                        final id = dosen['id'] as int;
                        final name = dosen['user']['name'] as String;
                        final activeCount = dosen['pembimbings_count'] ?? 0;
                        final kuota = dosen['kuota_bimbingan'] ?? 10;
                        final isOverload = activeCount >= kuota && kuota > 0;
                        final List bks = dosen['bidang_keahlians'] ?? [];
                        final bkStr = bks.map((bk) => bk['nama_bidang']).join(', ');
                        
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            '$name ($activeCount/$kuota Mhs) ${isOverload ? "[OVERLOAD]" : ""} ${bkStr.isNotEmpty ? "[$bkStr]" : ""}',
                            style: TextStyle(fontSize: 12, color: isOverload ? Colors.red : null),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          selectedP1DosenId = val;
                          if (selectedP2DosenId == val) {
                            selectedP2DosenId = null; // Reset P2 jika sama dengan P1
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
 
                    // Pembimbing 2 Dropdown
                    const Text('Dosen Pembimbing 2 (Pendamping)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: selectedP2DosenId,
                      hint: const Text('Pilih Pembimbing 2 (Opsional)'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _dosens
                          .where((dosen) => dosen['id'] != selectedP1DosenId)
                          .map<DropdownMenuItem<int>>((dosen) {
                        final id = dosen['id'] as int;
                        final name = dosen['user']['name'] as String;
                        final activeCount = dosen['pembimbings_count'] ?? 0;
                        final kuota = dosen['kuota_bimbingan'] ?? 10;
                        final isOverload = activeCount >= kuota && kuota > 0;
                        final List bks = dosen['bidang_keahlians'] ?? [];
                        final bkStr = bks.map((bk) => bk['nama_bidang']).join(', ');
 
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            '$name ($activeCount/$kuota Mhs) ${isOverload ? "[OVERLOAD]" : ""} ${bkStr.isNotEmpty ? "[$bkStr]" : ""}',
                            style: TextStyle(fontSize: 12, color: isOverload ? Colors.red : null),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          selectedP2DosenId = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, null),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: selectedP1DosenId == null
                      ? null
                      : () => Navigator.pop(dialogCtx, {
                            'p1': selectedP1DosenId,
                            'p2': selectedP2DosenId,
                          }),
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
 
    if (result != null) {
      _saveAllocation(student.id, result['p1']!, result['p2']);
    }
  }
 
  Future<void> _saveAllocation(int titleId, int p1Id, int? p2Id) async {
    setState(() {
      _isSaving = true;
    });
 
    try {
      final service = ref.read(pembimbingServiceProvider);
      await service.assignPembimbing(
        pengajuanJudulId: titleId,
        pembimbing1DosenId: p1Id,
        pembimbing2DosenId: p2Id,
      );
 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembimbing skripsi berhasil dialokasikan!'), backgroundColor: Colors.green),
      );
      _fetchData(); // Refresh list data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan alokasi: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
 
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pembimbing 1': return const Color(0xFF0056A6);
      case 'Pembimbing 2': return const Color(0xFF4CAF50);
      default: return Colors.grey;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Penentuan Pembimbing', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading || _isSaving
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: _students.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return _buildStudentCard(student);
                      },
                    ),
            ),
    );
  }
 
  Widget _buildStudentCard(PengajuanJudulModel student) {
    final hasPembimbing = student.pembimbings.isNotEmpty;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.08),
                  child: const Icon(Icons.person, color: Color(0xFF0056A6)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.namaMahasiswa ?? 'Mahasiswa',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A1A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: ${student.nimMahasiswa ?? "-"} | ${student.prodiMahasiswa ?? "-"}',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider(height: 1)),
            
            // Judul Skripsi
            const Text(
              'Judul Skripsi Disetujui:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              student.judul,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 12),
            
            // Advisors List
            const Text(
              'Dosen Pembimbing:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            if (!hasPembimbing)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800), size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Pembimbing Belum Ditentukan',
                      style: TextStyle(fontSize: 11, color: Color(0xFFFF9800), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: student.pembimbings.map((p) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(p.peran).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor(p.peran).withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.peran.toUpperCase(),
                          style: TextStyle(fontSize: 9, color: _getStatusColor(p.peran), fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.namaDosen ?? 'Dosen',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 16),
            
            // Button Action
            CustomButton(
              text: hasPembimbing ? 'Ubah Pembimbing' : 'Tentukan Pembimbing',
              onPressed: () => _showAssignDialog(student),
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
                Icons.assignment_late_rounded,
                color: Color(0xFF0056A6),
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Mahasiswa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Belum ada judul skripsi mahasiswa yang berstatus disetujui untuk dialokasikan pembimbing.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
