import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/pengajuan_judul_model.dart';
import '../models/pembimbing_model.dart';
 
final pembimbingServiceProvider = Provider<PembimbingService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PembimbingService(apiClient);
});
 
class PembimbingService {
  final ApiClient _apiClient;
 
  PembimbingService(this._apiClient);
 
  /// (Kaprodi) Mengambil daftar mahasiswa yang judulnya disetujui beserta alokasi pembimbing
  Future<List<PengajuanJudulModel>> getKaprodiMahasiswaDisetujui() async {
    final response = await _apiClient.get('/kaprodi/pembimbing/mahasiswa-disetujui');
    final List list = response.data['data'] ?? [];
    return list.map((item) => PengajuanJudulModel.fromJson(item)).toList();
  }
 
  /// (Kaprodi) Mengambil daftar dosen beserta data user, bidang keahlian, dan kuota terpakai
  Future<List<dynamic>> getKaprodiDosenList() async {
    final response = await _apiClient.get('/kaprodi/pembimbing/dosen-list');
    return response.data['data'] ?? [];
  }
 
  /// (Kaprodi) Menyimpan alokasi Pembimbing 1 dan Pembimbing 2
  Future<void> assignPembimbing({
    required int pengajuanJudulId,
    required int pembimbing1DosenId,
    int? pembimbing2DosenId,
  }) async {
    await _apiClient.post('/kaprodi/pembimbing/assign', data: {
      'pengajuan_judul_id': pengajuanJudulId,
      'pembimbing_1_dosen_id': pembimbing1DosenId,
      'pembimbing_2_dosen_id': pembimbing2DosenId,
    });
  }
 
  /// (Mahasiswa) Mengambil dosen pembimbing aktif
  Future<List<PembimbingModel>> getMahasiswaPembimbing() async {
    final response = await _apiClient.get('/mahasiswa/pembimbing');
    final List list = response.data['data'] ?? [];
    return list.map((item) => PembimbingModel.fromJson(item)).toList();
  }
 
  /// (Dosen) Mengambil daftar mahasiswa bimbingan aktif
  Future<List<PembimbingModel>> getDosenMahasiswaBimbingan() async {
    final response = await _apiClient.get('/dosen/mahasiswa-bimbingan');
    final List list = response.data['data'] ?? [];
    return list.map((item) => PembimbingModel.fromJson(item)).toList();
  }
}
