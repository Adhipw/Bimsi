import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/master_service.dart';
import '../models/program_studi_model.dart';
import '../models/tahun_akademik_model.dart';
import '../models/semester_model.dart';
import '../models/kelas_model.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../../auth/models/user_model.dart';

class MasterDataListPage extends ConsumerStatefulWidget {
  final String type;

  const MasterDataListPage({super.key, required this.type});

  @override
  ConsumerState<MasterDataListPage> createState() => _MasterDataListPageState();
}

class _MasterDataListPageState extends ConsumerState<MasterDataListPage> {
  final _searchController = TextEditingController();
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case 'program-studi': return 'Program Studi';
      case 'tahun-akademik': return 'Tahun Akademik';
      case 'semester': return 'Semester';
      case 'kelas': return 'Kelas';
      case 'user': return 'User';
      case 'dosen': return 'Dosen';
      case 'mahasiswa': return 'Mahasiswa';
      default: return 'Data Master';
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(masterServiceProvider);
      List<dynamic> fetched = [];
      switch (widget.type) {
        case 'program-studi':
          fetched = await service.getProgramStudis();
          break;
        case 'tahun-akademik':
          fetched = await service.getTahunAkademiks();
          break;
        case 'semester':
          fetched = await service.getSemesters();
          break;
        case 'kelas':
          fetched = await service.getKelas();
          break;
        case 'user':
          fetched = await service.getUsers();
          break;
        case 'dosen':
          fetched = await service.getDosens();
          break;
        case 'mahasiswa':
          fetched = await service.getMahasiswas();
          break;
      }

      setState(() {
        _items = fetched;
        _filteredItems = fetched;
      });
    } catch (e) {
      _showSnackbar('Gagal mengambil data: $e', Colors.redAccent);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        if (item is ProgramStudiModel) {
          return item.namaProdi.toLowerCase().contains(query) || item.kodeProdi.toLowerCase().contains(query);
        } else if (item is TahunAkademikModel) {
          return item.tahun.toLowerCase().contains(query);
        } else if (item is SemesterModel) {
          return item.nama.toLowerCase().contains(query);
        } else if (item is KelasModel) {
          return item.namaKelas.toLowerCase().contains(query) || (item.programStudi?.namaProdi.toLowerCase().contains(query) ?? false);
        } else if (item is UserModel) {
          return item.name.toLowerCase().contains(query) || item.email.toLowerCase().contains(query) || item.role.toLowerCase().contains(query);
        } else if (item is DosenModel) {
          return (item.user?.name.toLowerCase().contains(query) ?? false) || item.nidn.toLowerCase().contains(query);
        } else if (item is MahasiswaModel) {
          return (item.user?.name.toLowerCase().contains(query) ?? false) || item.nim.toLowerCase().contains(query);
        }
        return false;
      }).toList();
    });
  }

  Future<void> _deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final service = ref.read(masterServiceProvider);
      switch (widget.type) {
        case 'program-studi': await service.deleteProgramStudi(id); break;
        case 'tahun-akademik': await service.deleteTahunAkademik(id); break;
        case 'semester': await service.deleteSemester(id); break;
        case 'kelas': await service.deleteKelas(id); break;
        case 'user': await service.deleteUser(id); break;
        case 'dosen': await service.deleteDosen(id); break;
        case 'mahasiswa': await service.deleteMahasiswa(id); break;
      }
      _showSnackbar('Data berhasil dihapus', Colors.green);
      _fetchData();
    } catch (e) {
      _showSnackbar('Gagal menghapus data: $e', Colors.redAccent);
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg.replaceAll('Exception: ', '')), backgroundColor: color),
    );
  }

  Widget _buildListTile(dynamic item) {
    if (item is ProgramStudiModel) {
      return ListTile(
        title: Text(item.namaProdi, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.kodeProdi} - ${item.jenjang}'),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    } else if (item is TahunAkademikModel) {
      return ListTile(
        title: Text('Tahun Akademik ${item.tahun}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(
              item.isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: item.isActive ? Colors.green : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(item.isActive ? 'Aktif' : 'Tidak Aktif'),
          ],
        ),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    } else if (item is SemesterModel) {
      return ListTile(
        title: Text('Semester ${item.nama}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(
              item.isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: item.isActive ? Colors.green : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(item.isActive ? 'Aktif' : 'Tidak Aktif'),
          ],
        ),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    } else if (item is KelasModel) {
      return ListTile(
        title: Text('Kelas ${item.namaKelas}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.programStudi?.namaProdi ?? 'Tanpa Prodi'),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    } else if (item is UserModel) {
      return ListTile(
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.email} â€¢ Role: ${item.role}'),
        trailing: _buildActionButtons(int.parse(item.id)),
        onTap: () => _navigateToDetail(int.parse(item.id)),
      );
    } else if (item is DosenModel) {
      return ListTile(
        title: Text(item.user?.name ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('NIDN: ${item.nidn} â€¢ ${item.jabatanFungsional}'),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    } else if (item is MahasiswaModel) {
      return ListTile(
        title: Text(item.user?.name ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('NIM: ${item.nim} â€¢ ${item.programStudi?.namaProdi ?? ''} - ${item.kelas?.namaKelas ?? ''}'),
        trailing: _buildActionButtons(item.id),
        onTap: () => _navigateToDetail(item.id),
      );
    }
    return const SizedBox();
  }

  Widget _buildActionButtons(int id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Color(0xFF0056A6), size: 20),
          onPressed: () => _navigateToEdit(id),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
          onPressed: () => _deleteItem(id),
        ),
      ],
    );
  }

  void _navigateToDetail(int id) {
    context.push('/dashboard/admin/master-detail?type=${widget.type}&id=$id').then((_) => _fetchData());
  }

  void _navigateToEdit(int id) {
    context.push('/dashboard/admin/master-form?type=${widget.type}&id=$id').then((_) => _fetchData());
  }

  void _navigateToCreate() {
    context.push('/dashboard/admin/master-form?type=${widget.type}').then((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Daftar $_title', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0056A6),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari $_title...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredItems.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text('Tidak ada data.', style: TextStyle(color: Colors.grey))),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1.5,
                              child: _buildListTile(item),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0056A6),
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
