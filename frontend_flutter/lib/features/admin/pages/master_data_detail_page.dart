import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/master_service.dart';
import '../models/program_studi_model.dart';
import '../models/tahun_akademik_model.dart';
import '../models/semester_model.dart';
import '../models/kelas_model.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';
import '../../auth/models/user_model.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class MasterDataDetailPage extends ConsumerStatefulWidget {
  final String type;
  final String id;

  const MasterDataDetailPage({super.key, required this.type, required this.id});

  @override
  ConsumerState<MasterDataDetailPage> createState() => _MasterDataDetailPageState();
}

class _MasterDataDetailPageState extends ConsumerState<MasterDataDetailPage> {
  dynamic _item;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  String get _title {
    switch (widget.type) {
      case 'program-studi': return 'Detail Program Studi';
      case 'tahun-akademik': return 'Detail Tahun Akademik';
      case 'semester': return 'Detail Semester';
      case 'kelas': return 'Detail Kelas';
      case 'user': return 'Detail User';
      case 'dosen': return 'Detail Dosen';
      case 'mahasiswa': return 'Detail Mahasiswa';
      default: return 'Detail Data';
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(masterServiceProvider);
      final idInt = int.parse(widget.id);
      dynamic fetched;

      switch (widget.type) {
        case 'program-studi':
          final list = await service.getProgramStudis();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
        case 'tahun-akademik':
          final list = await service.getTahunAkademiks();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
        case 'semester':
          final list = await service.getSemesters();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
        case 'kelas':
          final list = await service.getKelas();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
        case 'user':
          final list = await service.getUsers();
          fetched = list.firstWhere((e) => int.parse(e.id) == idInt);
          break;
        case 'dosen':
          final list = await service.getDosens();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
        case 'mahasiswa':
          final list = await service.getMahasiswas();
          fetched = list.firstWhere((e) => e.id == idInt);
          break;
      }

      setState(() {
        _item = fetched;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildDetailRows() {
    if (_item == null) return [];

    final rows = <Widget>[];

    void addRow(String label, String value) {
      rows.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF757575))),
              ),
              Expanded(
                flex: 5,
                child: Text(value, style: const TextStyle(color: Color(0xFF1A1A1A))),
              ),
            ],
          ),
        ),
        const Divider(),
      ]);
    }

    if (_item is ProgramStudiModel) {
      final item = _item as ProgramStudiModel;
      addRow('Kode Prodi', item.kodeProdi);
      addRow('Nama Program Studi', item.namaProdi);
      addRow('Jenjang', item.jenjang);
    } else if (_item is TahunAkademikModel) {
      final item = _item as TahunAkademikModel;
      addRow('Tahun Akademik', item.tahun);
      addRow('Status', item.isActive ? 'Aktif' : 'Tidak Aktif');
    } else if (_item is SemesterModel) {
      final item = _item as SemesterModel;
      addRow('Nama Semester', item.nama);
      addRow('Status', item.isActive ? 'Aktif' : 'Tidak Aktif');
    } else if (_item is KelasModel) {
      final item = _item as KelasModel;
      addRow('Nama Kelas', item.namaKelas);
      addRow('Program Studi', item.programStudi?.namaProdi ?? '-');
      addRow('Jenjang', item.programStudi?.jenjang ?? '-');
    } else if (_item is UserModel) {
      final item = _item as UserModel;
      addRow('Nama Lengkap', item.name);
      addRow('Email', item.email);
      addRow('Role Akses', item.role);
    } else if (_item is DosenModel) {
      final item = _item as DosenModel;
      addRow('Nama Lengkap', item.user?.name ?? '-');
      addRow('Email', item.user?.email ?? '-');
      addRow('NIDN', item.nidn);
      addRow('Jabatan Fungsional', item.jabatanFungsional);
      if (item.bidangKeahlians != null) {
        final bkNames = item.bidangKeahlians!.map((e) => e['nama_bidang'].toString()).join(', ');
        addRow('Bidang Keahlian', bkNames.isNotEmpty ? bkNames : 'Belum ditentukan');
      }
    } else if (_item is MahasiswaModel) {
      final item = _item as MahasiswaModel;
      addRow('Nama Lengkap', item.user?.name ?? '-');
      addRow('Email', item.user?.email ?? '-');
      addRow('NIM', item.nim);
      addRow('Program Studi', item.programStudi?.namaProdi ?? '-');
      addRow('Kelas', item.kelas?.namaKelas ?? '-');
      addRow('Tahun Masuk', item.tahunMasuk);
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: _title,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _item == null
              ? const Center(child: Text('Data tidak ditemukan.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildDetailRows(),
                      ),
                    ),
                  ),
                ),
    );
  }
}
