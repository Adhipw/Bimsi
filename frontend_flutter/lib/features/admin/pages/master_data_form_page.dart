import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/master_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/program_studi_model.dart';
import '../models/kelas_model.dart';
import '../../../shared/layouts/responsive_scaffold.dart';

class MasterDataFormPage extends ConsumerStatefulWidget {
  final String type;
  final String? id;

  const MasterDataFormPage({super.key, required this.type, this.id});

  @override
  ConsumerState<MasterDataFormPage> createState() => _MasterDataFormPageState();
}

class _MasterDataFormPageState extends ConsumerState<MasterDataFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;

  // Controllers for general inputs
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Program Studi specific
  final _kodeProdiController = TextEditingController();
  final _namaProdiController = TextEditingController();
  final _jenjangController = TextEditingController();

  // Tahun Akademik specific
  final _tahunController = TextEditingController();
  bool _isActive = true;

  // Semester specific
  final _namaSemesterController = TextEditingController();

  // Kelas specific
  final _namaKelasController = TextEditingController();
  int? _selectedProgramStudiId;

  // Dosen specific
  final _nidnController = TextEditingController();
  final _jabatanFungsionalController = TextEditingController();

  // Mahasiswa specific
  final _nimController = TextEditingController();
  final _tahunMasukController = TextEditingController();
  int? _selectedKelasId;

  // Drops options
  List<ProgramStudiModel> _prodis = [];
  List<KelasModel> _kelasItems = [];

  bool get _isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();
    _loadDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _kodeProdiController.dispose();
    _namaProdiController.dispose();
    _jenjangController.dispose();
    _tahunController.dispose();
    _namaSemesterController.dispose();
    _namaKelasController.dispose();
    _nidnController.dispose();
    _jabatanFungsionalController.dispose();
    _nimController.dispose();
    _tahunMasukController.dispose();
    super.dispose();
  }

  Future<void> _loadDependencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(masterServiceProvider);

      // Load program studis and kelas for dropdowns if needed
      if (widget.type == 'kelas' || widget.type == 'mahasiswa') {
        _prodis = await service.getProgramStudis();
      }
      if (widget.type == 'mahasiswa') {
        _kelasItems = await service.getKelas();
      }

      // If Edit, load existing item
      if (_isEdit) {
        final idInt = int.parse(widget.id!);
        switch (widget.type) {
          case 'program-studi':
            final list = await service.getProgramStudis();
            final item = list.firstWhere((e) => e.id == idInt);
            _kodeProdiController.text = item.kodeProdi;
            _namaProdiController.text = item.namaProdi;
            _jenjangController.text = item.jenjang;
            break;
          case 'tahun-akademik':
            final list = await service.getTahunAkademiks();
            final item = list.firstWhere((e) => e.id == idInt);
            _tahunController.text = item.tahun;
            _isActive = item.isActive;
            break;
          case 'semester':
            final list = await service.getSemesters();
            final item = list.firstWhere((e) => e.id == idInt);
            _namaSemesterController.text = item.nama;
            _isActive = item.isActive;
            break;
          case 'kelas':
            final list = await service.getKelas();
            final item = list.firstWhere((e) => e.id == idInt);
            _namaKelasController.text = item.namaKelas;
            _selectedProgramStudiId = item.programStudiId;
            break;
          case 'user':
            final list = await service.getUsers();
            final item = list.firstWhere((e) => int.parse(e.id) == idInt);
            _nameController.text = item.name;
            _emailController.text = item.email;
            break;
          case 'dosen':
            final list = await service.getDosens();
            final item = list.firstWhere((e) => e.id == idInt);
            _nameController.text = item.user?.name ?? '';
            _emailController.text = item.user?.email ?? '';
            _nidnController.text = item.nidn;
            _jabatanFungsionalController.text = item.jabatanFungsional;
            break;
          case 'mahasiswa':
            final list = await service.getMahasiswas();
            final item = list.firstWhere((e) => e.id == idInt);
            _nameController.text = item.user?.name ?? '';
            _emailController.text = item.user?.email ?? '';
            _nimController.text = item.nim;
            _selectedProgramStudiId = item.programStudiId;
            _selectedKelasId = item.kelasId;
            _tahunMasukController.text = item.tahunMasuk;
            break;
        }
      }
    } catch (e) {
      _showSnackbar('Gagal memuat data: $e', Colors.redAccent);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg.replaceAll('Exception: ', '')), backgroundColor: color),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final service = ref.read(masterServiceProvider);
      final idInt = _isEdit ? int.parse(widget.id!) : 0;
      Map<String, dynamic> data = {};

      switch (widget.type) {
        case 'program-studi':
          data = {
            'kode_prodi': _kodeProdiController.text,
            'nama_prodi': _namaProdiController.text,
            'jenjang': _jenjangController.text,
          };
          _isEdit ? await service.updateProgramStudi(idInt, data) : await service.createProgramStudi(data);
          break;
        case 'tahun-akademik':
          data = {
            'tahun': _tahunController.text,
            'is_active': _isActive,
          };
          _isEdit ? await service.updateTahunAkademik(idInt, data) : await service.createTahunAkademik(data);
          break;
        case 'semester':
          data = {
            'nama': _namaSemesterController.text,
            'is_active': _isActive,
          };
          _isEdit ? await service.updateSemester(idInt, data) : await service.createSemester(data);
          break;
        case 'kelas':
          data = {
            'nama_kelas': _namaKelasController.text,
            'program_studi_id': _selectedProgramStudiId,
          };
          _isEdit ? await service.updateKelas(idInt, data) : await service.createKelas(data);
          break;
        case 'user':
          data = {
            'name': _nameController.text,
            'email': _emailController.text,
            'role': 'admin',
          };
          if (!_isEdit || _passwordController.text.isNotEmpty) {
            data['password'] = _passwordController.text;
          }
          _isEdit ? await service.updateUser(idInt, data) : await service.createUser(data);
          break;
        case 'dosen':
          data = {
            'name': _nameController.text,
            'email': _emailController.text,
            'nidn': _nidnController.text,
            'jabatan_fungsional': _jabatanFungsionalController.text,
          };
          if (!_isEdit || _passwordController.text.isNotEmpty) {
            data['password'] = _passwordController.text;
          }
          _isEdit ? await service.updateDosen(idInt, data) : await service.createDosen(data);
          break;
        case 'mahasiswa':
          data = {
            'name': _nameController.text,
            'email': _emailController.text,
            'nim': _nimController.text,
            'program_studi_id': _selectedProgramStudiId,
            'kelas_id': _selectedKelasId,
            'tahun_masuk': _tahunMasukController.text,
          };
          if (!_isEdit || _passwordController.text.isNotEmpty) {
            data['password'] = _passwordController.text;
          }
          _isEdit ? await service.updateMahasiswa(idInt, data) : await service.createMahasiswa(data);
          break;
      }

      _showSnackbar('Data berhasil disimpan', Colors.green);
      if (mounted) context.pop();
    } catch (e) {
      _showSnackbar('Gagal menyimpan data: $e', Colors.redAccent);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  List<Widget> _buildFormFields() {
    switch (widget.type) {
      case 'program-studi':
        return [
          CustomTextField(
            label: 'Kode Prodi',
            controller: _kodeProdiController,
            hint: 'Contoh: IF',
            validator: (v) => v == null || v.isEmpty ? 'Kode prodi wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Nama Program Studi',
            controller: _namaProdiController,
            hint: 'Contoh: Informatika',
            validator: (v) => v == null || v.isEmpty ? 'Nama prodi wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Jenjang',
            controller: _jenjangController,
            hint: 'Contoh: S1',
            validator: (v) => v == null || v.isEmpty ? 'Jenjang wajib diisi' : null,
          ),
        ];
      case 'tahun-akademik':
        return [
          CustomTextField(
            label: 'Tahun Akademik',
            controller: _tahunController,
            hint: 'Contoh: 2025/2026',
            validator: (v) => v == null || v.isEmpty ? 'Tahun akademik wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Status Aktif'),
            subtitle: const Text('Menjadikan ini sebagai tahun akademik aktif saat ini'),
            value: _isActive,
            onChanged: (v) {
              setState(() {
                _isActive = v;
              });
            },
          ),
        ];
      case 'semester':
        return [
          CustomTextField(
            label: 'Nama Semester',
            controller: _namaSemesterController,
            hint: 'Contoh: Ganjil',
            validator: (v) => v == null || v.isEmpty ? 'Nama semester wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Status Aktif'),
            subtitle: const Text('Menjadikan ini sebagai semester aktif saat ini'),
            value: _isActive,
            onChanged: (v) {
              setState(() {
                _isActive = v;
              });
            },
          ),
        ];
      case 'kelas':
        return [
          CustomTextField(
            label: 'Nama Kelas',
            controller: _namaKelasController,
            hint: 'Contoh: 12.6A.01',
            validator: (v) => v == null || v.isEmpty ? 'Nama kelas wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          const Text('Program Studi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _selectedProgramStudiId,
            items: _prodis.map((p) => DropdownMenuItem(value: p.id, child: Text(p.namaProdi))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedProgramStudiId = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (v) => v == null ? 'Pilih program studi' : null,
          ),
        ];
      case 'user':
        return [
          CustomTextField(
            label: 'Nama Lengkap',
            controller: _nameController,
            hint: 'Nama lengkap pengguna',
            validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            hint: 'email@domain.com',
            validator: (v) => v == null || !v.contains('@') ? 'Masukkan email valid' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            hint: _isEdit ? 'Biarkan kosong jika tidak diubah' : 'Minimal 8 karakter',
            obscureText: true,
            validator: (v) {
              if (!_isEdit && (v == null || v.length < 8)) {
                return 'Password minimal 8 karakter';
              }
              if (_isEdit && v != null && v.isNotEmpty && v.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
        ];
      case 'dosen':
        return [
          CustomTextField(
            label: 'Nama Lengkap',
            controller: _nameController,
            hint: 'Nama lengkap beserta gelar',
            validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            hint: 'email@domain.com',
            validator: (v) => v == null || !v.contains('@') ? 'Masukkan email valid' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            hint: _isEdit ? 'Biarkan kosong jika tidak diubah' : 'Minimal 8 karakter',
            obscureText: true,
            validator: (v) {
              if (!_isEdit && (v == null || v.length < 8)) {
                return 'Password minimal 8 karakter';
              }
              if (_isEdit && v != null && v.isNotEmpty && v.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'NIDN',
            controller: _nidnController,
            hint: 'Nomor Induk Dosen Nasional',
            validator: (v) => v == null || v.isEmpty ? 'NIDN wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Jabatan Fungsional',
            controller: _jabatanFungsionalController,
            hint: 'Contoh: Lektor, Asisten Ahli',
            validator: (v) => v == null || v.isEmpty ? 'Jabatan fungsional wajib diisi' : null,
          ),
        ];
      case 'mahasiswa':
        return [
          CustomTextField(
            label: 'Nama Lengkap',
            controller: _nameController,
            hint: 'Nama lengkap mahasiswa',
            validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            hint: 'email@domain.com',
            validator: (v) => v == null || !v.contains('@') ? 'Masukkan email valid' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            hint: _isEdit ? 'Biarkan kosong jika tidak diubah' : 'Minimal 8 karakter',
            obscureText: true,
            validator: (v) {
              if (!_isEdit && (v == null || v.length < 8)) {
                return 'Password minimal 8 karakter';
              }
              if (_isEdit && v != null && v.isNotEmpty && v.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'NIM',
            controller: _nimController,
            hint: 'Nomor Induk Mahasiswa',
            validator: (v) => v == null || v.isEmpty ? 'NIM wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          const Text('Program Studi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _selectedProgramStudiId,
            items: _prodis.map((p) => DropdownMenuItem(value: p.id, child: Text(p.namaProdi))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedProgramStudiId = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (v) => v == null ? 'Pilih program studi' : null,
          ),
          const SizedBox(height: 16),
          const Text('Kelas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _selectedKelasId,
            items: _kelasItems.map((k) => DropdownMenuItem(value: k.id, child: Text(k.namaKelas))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedKelasId = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (v) => v == null ? 'Pilih kelas' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Tahun Masuk',
            controller: _tahunMasukController,
            hint: 'Contoh: 2022',
            validator: (v) => v == null || v.isEmpty ? 'Tahun masuk wajib diisi' : null,
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: _isEdit ? 'Edit ${widget.type}' : 'Tambah ${widget.type}',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ..._buildFormFields(),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Simpan',
                          isLoading: _isSaving,
                          onPressed: _save,
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
