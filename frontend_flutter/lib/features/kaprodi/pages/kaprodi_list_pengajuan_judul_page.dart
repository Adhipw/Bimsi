import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../mahasiswa/services/pengajuan_judul_service.dart';
import '../../mahasiswa/models/pengajuan_judul_model.dart';
 
class KaprodiListPengajuanJudulPage extends ConsumerStatefulWidget {
  const KaprodiListPengajuanJudulPage({super.key});
 
  @override
  ConsumerState<KaprodiListPengajuanJudulPage> createState() => _KaprodiListPengajuanJudulPageState();
}
 
class _KaprodiListPengajuanJudulPageState extends ConsumerState<KaprodiListPengajuanJudulPage> {
  List<PengajuanJudulModel> _list = [];
  bool _isLoading = false;
  String _selectedStatus = '';
  final TextEditingController _searchController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    _fetchList();
  }
 
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
 
  Future<void> _fetchList() async {
    setState(() {
      _isLoading = true;
    });
 
    try {
      final service = ref.read(pengajuanJudulServiceProvider);
      final data = await service.getKaprodiList(
        status: _selectedStatus,
        search: _searchController.text,
      );
      setState(() {
        _list = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat usulan judul: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
 
  Color _getStatusColor(String status) {
    switch (status) {
      case 'disetujui':
        return const Color(0xFF4CAF50); // Green
      case 'revisi':
        return const Color(0xFFFF9800); // Orange/Amber
      case 'ditolak':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF2196F3); // Blue (pending)
    }
  }
 
  String _getStatusLabel(String status) {
    switch (status) {
      case 'disetujui':
        return 'Disetujui';
      case 'revisi':
        return 'Revisi';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Persetujuan Judul',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Search & Filter Bar
          Container(
            color: const Color(0xFF0056A6),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _fetchList(),
                    decoration: InputDecoration(
                      hintText: 'Cari Judul, Nama, atau NIM...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0056A6)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF0056A6)),
                        onPressed: _fetchList,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('', 'Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('pending', 'Menunggu'),
                      const SizedBox(width: 8),
                      _buildFilterChip('disetujui', 'Disetujui'),
                      const SizedBox(width: 8),
                      _buildFilterChip('revisi', 'Revisi'),
                      const SizedBox(width: 8),
                      _buildFilterChip('ditolak', 'Ditolak'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // List Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchList,
                    child: _list.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              final item = _list[index];
                              return _buildSubmissionCard(item);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedStatus == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0056A6) : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      checkmarkColor: const Color(0xFF0056A6),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedStatus = value;
          });
          _fetchList();
        }
      },
    );
  }
 
  Widget _buildSubmissionCard(PengajuanJudulModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/dashboard/kaprodi/pengajuan-detail?id=${item.id}').then((_) => _fetchList());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge & Date Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusLabel(item.status).toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(item.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    item.namaPeriode ?? 'Periode Aktif',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Judul Skripsi
              Text(
                item.judul,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // Student Metadata
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Color(0xFF0056A6)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${item.namaMahasiswa ?? 'Mahasiswa'} (${item.nimMahasiswa ?? ''})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.school_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.prodiMahasiswa ?? 'Program Studi',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        alignment: Alignment.center,
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
                Icons.assignment_turned_in_rounded,
                color: Color(0xFF0056A6),
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Usulan Judul',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Belum ada mahasiswa yang mengajukan judul skripsi sesuai dengan filter yang dipilih.',
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
