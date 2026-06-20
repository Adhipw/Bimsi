import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../auth/models/user_model.dart';
import '../models/program_studi_model.dart';
import '../models/tahun_akademik_model.dart';
import '../models/semester_model.dart';
import '../models/kelas_model.dart';
import '../models/dosen_model.dart';
import '../models/mahasiswa_model.dart';

final masterServiceProvider = Provider<MasterService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return MasterService(apiClient);
});

class MasterService {
  final ApiClient _apiClient;

  MasterService(this._apiClient);

  // --- PROGRAM STUDI ---
  Future<List<ProgramStudiModel>> getProgramStudis() async {
    final response = await _apiClient.get('/program-studi');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => ProgramStudiModel.fromJson(item)).toList();
  }

  Future<ProgramStudiModel> createProgramStudi(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/program-studi', data: data);
    return ProgramStudiModel.fromJson(response.data['data']);
  }

  Future<ProgramStudiModel> updateProgramStudi(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/program-studi/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return ProgramStudiModel.fromJson(response.data['data']);
  }

  Future<void> deleteProgramStudi(int id) async {
    await _apiClient.post('/program-studi/$id', data: {'_method': 'DELETE'});
  }

  // --- TAHUN AKADEMIK ---
  Future<List<TahunAkademikModel>> getTahunAkademiks() async {
    final response = await _apiClient.get('/tahun-akademik');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => TahunAkademikModel.fromJson(item)).toList();
  }

  Future<TahunAkademikModel> createTahunAkademik(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/tahun-akademik', data: data);
    return TahunAkademikModel.fromJson(response.data['data']);
  }

  Future<TahunAkademikModel> updateTahunAkademik(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/tahun-akademik/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return TahunAkademikModel.fromJson(response.data['data']);
  }

  Future<void> deleteTahunAkademik(int id) async {
    await _apiClient.post('/tahun-akademik/$id', data: {'_method': 'DELETE'});
  }

  // --- SEMESTER ---
  Future<List<SemesterModel>> getSemesters() async {
    final response = await _apiClient.get('/semester');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => SemesterModel.fromJson(item)).toList();
  }

  Future<SemesterModel> createSemester(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/semester', data: data);
    return SemesterModel.fromJson(response.data['data']);
  }

  Future<SemesterModel> updateSemester(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/semester/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return SemesterModel.fromJson(response.data['data']);
  }

  Future<void> deleteSemester(int id) async {
    await _apiClient.post('/semester/$id', data: {'_method': 'DELETE'});
  }

  // --- KELAS ---
  Future<List<KelasModel>> getKelas() async {
    final response = await _apiClient.get('/kelas');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => KelasModel.fromJson(item)).toList();
  }

  Future<KelasModel> createKelas(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/kelas', data: data);
    return KelasModel.fromJson(response.data['data']);
  }

  Future<KelasModel> updateKelas(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/kelas/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return KelasModel.fromJson(response.data['data']);
  }

  Future<void> deleteKelas(int id) async {
    await _apiClient.post('/kelas/$id', data: {'_method': 'DELETE'});
  }

  // --- USER ---
  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.get('/user');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/user', data: data);
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/user/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return UserModel.fromJson(response.data['data']);
  }

  Future<void> deleteUser(int id) async {
    await _apiClient.post('/user/$id', data: {'_method': 'DELETE'});
  }

  // --- DOSEN ---
  Future<List<DosenModel>> getDosens() async {
    final response = await _apiClient.get('/dosen');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => DosenModel.fromJson(item)).toList();
  }

  Future<DosenModel> createDosen(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/dosen', data: data);
    return DosenModel.fromJson(response.data['data']);
  }

  Future<DosenModel> updateDosen(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/dosen/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return DosenModel.fromJson(response.data['data']);
  }

  Future<void> deleteDosen(int id) async {
    await _apiClient.post('/dosen/$id', data: {'_method': 'DELETE'});
  }

  // --- MAHASISWA ---
  Future<List<MahasiswaModel>> getMahasiswas() async {
    final response = await _apiClient.get('/mahasiswa');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => MahasiswaModel.fromJson(item)).toList();
  }

  Future<MahasiswaModel> createMahasiswa(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/mahasiswa', data: data);
    return MahasiswaModel.fromJson(response.data['data']);
  }

  Future<MahasiswaModel> updateMahasiswa(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.post('/mahasiswa/$id', data: {
      ...data,
      '_method': 'PUT',
    });
    return MahasiswaModel.fromJson(response.data['data']);
  }

  Future<void> deleteMahasiswa(int id) async {
    await _apiClient.post('/mahasiswa/$id', data: {'_method': 'DELETE'});
  }
}
