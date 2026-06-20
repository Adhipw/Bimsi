import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mahasiswa/services/pembimbing_service.dart';
import '../../mahasiswa/models/pembimbing_model.dart';
 
class DosenMahasiswaBimbinganPage extends ConsumerStatefulWidget {
  const DosenMahasiswaBimbinganPage({super.key});
 
  @override
  ConsumerState<DosenMahasiswaBimbinganPage> createState() => _DosenMahasiswaBimbinganPageState();
}
 
class _DosenMahasiswaBimbinganPageState extends ConsumerState<DosenMahasiswaBimbinganPage> {
  List<PembimbingModel> _list = [];
  List<PembimbingModel> _filteredList = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    _fetchBimbingan();
  }
 
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
 
  Future<void> _fetchBimbingan() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(pembimbingServiceProvider);
      final data = await service.getDosenMahasiswaBimbingan();
      setState(() {
        _list = data;
        _filteredList = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data bimbingan: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  void _filterList(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList = _list;
      });
      return;
    }
 
    final search = query.toLowerCase();
    setState(() {
      _filteredList = _list.where((item) {
        final name = (item.mahasiswaNama ?? '').toLowerCase();
        final nim = (item.mahasiswaNim ?? '').toLowerCase();
        final title = (item.judulSkripsi ?? '').toLowerCase();
        return name.contains(search) || nim.contains(search) || title.contains(search);
      }).toList();
    });
  }
 
  Color _getRoleColor(String role) {
    if (role == 'Pembimbing 1') {
      return const Color(0xFF0056A6); // Blue
    }
    return const Color(0xFF4CAF50); // Green
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Mahasiswa Bimbingan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF0056A6),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterList,
                decoration: const InputDecoration(
                  hintText: 'Cari Nama, NIM, atau Judul...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF0056A6)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          // List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchBimbingan,
                    child: _filteredList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final item = _filteredList[index];
                              return _buildStudentCard(item);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildStudentCard(PembimbingModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile and Advisor role badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0056A6).withValues(alpha: 0.08),
                        child: const Icon(Icons.school, color: Color(0xFF0056A6)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.mahasiswaNama ?? 'Mahasiswa',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A1A)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NIM: ${item.mahasiswaNim ?? "-"}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(item.peran).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getRoleColor(item.peran), width: 1),
                  ),
                  child: Text(
                    item.peran.toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(item.peran),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)),
            
            // Judul Skripsi
            const Text(
              'Judul Skripsi:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              item.judulSkripsi ?? 'Judul Skripsi',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 12),
            
            // Meta info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kelas:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(item.mahasiswaKelas ?? '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Program Studi:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(item.mahasiswaProdi ?? '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    'dosen_progress_mahasiswa',
                    queryParameters: {
                      'pengajuan_judul_id': item.pengajuanJudulId.toString(),
                      'nama_mahasiswa': item.mahasiswaNama ?? 'Mahasiswa',
                    },
                  );
                },
                icon: const Icon(Icons.bar_chart, size: 18),
                label: const Text('Update Progress Skripsi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0056A6),
                  side: const BorderSide(color: Color(0xFF0056A6)),
                ),
              ),
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0056A6).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_ind_rounded,
                color: Color(0xFF0056A6),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Bimbingan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda belum terdaftar sebagai pembimbing skripsi mahasiswa manapun untuk periode akademik aktif.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
