import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/pendaftaran_sidang_model.dart';

final sidangServiceProvider = Provider<SidangService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SidangService(apiClient);
});

class SidangService {
  final ApiClient _apiClient;

  SidangService(this._apiClient);

  Future<List<PendaftaranSidangModel>> getStatus() async {
    final response = await _apiClient.get('/mahasiswa/pendaftaran-sidang/status');
    final List data = response.data;
    return data.map((e) => PendaftaranSidangModel.fromJson(e)).toList();
  }

  Future<PendaftaranSidangModel> submitPendaftaran({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required String jenisSidang,
    String? fileSyaratUrl,
  }) async {
    final response = await _apiClient.post('/mahasiswa/pendaftaran-sidang', data: {
      'mahasiswa_id': mahasiswaId,
      'pengajuan_judul_id': pengajuanJudulId,
      'jenis_sidang': jenisSidang,
      'file_syarat_url': fileSyaratUrl,
    });
    return PendaftaranSidangModel.fromJson(response.data);
  }

  // ==========================================
  // DOSEN ENDPOINTS
  // ==========================================

  Future<List<PendaftaranSidangModel>> getDosenSidangList() async {
    final response = await _apiClient.get('/dosen/pendaftaran-sidang');
    final List data = response.data;
    return data.map((e) => PendaftaranSidangModel.fromJson(e)).toList();
  }

  Future<void> approveSidang(int id) async {
    await _apiClient.post('/dosen/pendaftaran-sidang/$id/approve');
  }
}
