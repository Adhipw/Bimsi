import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/pengajuan_judul_model.dart';
 
final pengajuanJudulServiceProvider = Provider<PengajuanJudulService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PengajuanJudulService(apiClient);
});
 
class PengajuanJudulService {
  final ApiClient _apiClient;
 
  PengajuanJudulService(this._apiClient);
 
  /// Mengambil status pengajuan judul aktif milik Mahasiswa yang login
  Future<PengajuanJudulModel?> getStatus() async {
    final response = await _apiClient.get('/mahasiswa/pengajuan-judul/status');
    final data = response.data['data'];
    if (data == null) return null;
    return PengajuanJudulModel.fromJson(data);
  }
 
  /// Mengajukan judul skripsi baru (Mahasiswa)
  Future<PengajuanJudulModel> submitJudul(String judul, String? deskripsi) async {
    final response = await _apiClient.post('/mahasiswa/pengajuan-judul', data: {
      'judul': judul,
      'deskripsi': deskripsi,
    });
    return PengajuanJudulModel.fromJson(response.data['data']);
  }
 
  /// Mengirim revisi/update judul skripsi (Mahasiswa)
  Future<PengajuanJudulModel> reviseJudul(int id, String judul, String? deskripsi) async {
    final response = await _apiClient.put('/mahasiswa/pengajuan-judul/$id', data: {
      'judul': judul,
      'deskripsi': deskripsi,
    });
    return PengajuanJudulModel.fromJson(response.data['data']);
  }
 
  // ==========================================
  // KAPRODI ENDPOINTS
  // ==========================================
 
  /// Mengambil daftar semua pengajuan judul untuk Kaprodi
  Future<List<PengajuanJudulModel>> getKaprodiList({String? status, String? search}) async {
    final Map<String, dynamic> query = {};
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (search != null && search.isNotEmpty) query['search'] = search;
 
    final response = await _apiClient.get('/kaprodi/pengajuan-judul', queryParameters: query);
    final List list = response.data['data'] ?? [];
    return list.map((item) => PengajuanJudulModel.fromJson(item)).toList();
  }
 
  /// Mengambil detail pengajuan judul skripsi mahasiswa untuk Kaprodi
  Future<PengajuanJudulModel> getKaprodiDetail(int id) async {
    final response = await _apiClient.get('/kaprodi/pengajuan-judul/$id');
    return PengajuanJudulModel.fromJson(response.data['data']);
  }
 
  /// Menyetujui pengajuan judul skripsi (Kaprodi)
  Future<PengajuanJudulModel> approveJudul(int id, {String? catatan}) async {
    final response = await _apiClient.post(
      '/kaprodi/pengajuan-judul/$id/approve',
      data: catatan != null ? {'catatan': catatan} : null,
    );
    return PengajuanJudulModel.fromJson(response.data['data']);
  }
 
  /// Menolak atau meminta revisi pengajuan judul skripsi (Kaprodi)
  Future<PengajuanJudulModel> rejectJudul(int id, {required String status, required String catatan}) async {
    final response = await _apiClient.post(
      '/kaprodi/pengajuan-judul/$id/reject',
      data: {'status': status, 'catatan': catatan},
    );
    return PengajuanJudulModel.fromJson(response.data['data']);
  }
 
  /// Mengecek kemiripan judul usulan dengan judul skripsi lainnya di database (Kaprodi)
  Future<List<dynamic>> cekKemiripan(String judul, {int? excludeId}) async {
    final Map<String, dynamic> query = {'judul': judul};
    if (excludeId != null) query['exclude_id'] = excludeId;
 
    final response = await _apiClient.get('/kaprodi/pengajuan-judul/cek-kemiripan', queryParameters: query);
    return response.data['data'] ?? [];
  }
}
