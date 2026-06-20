import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/riwayat_bimbingan_model.dart';
import '../models/jadwal_bimbingan_model.dart';

final riwayatBimbinganServiceProvider = Provider<RiwayatBimbinganService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RiwayatBimbinganService(apiClient);
});

class RiwayatBimbinganService {
  final ApiClient _apiClient;

  RiwayatBimbinganService(this._apiClient);

  /// (Dosen) Mengambil daftar riwayat bimbingan yang telah diinput
  Future<List<RiwayatBimbinganModel>> getDosenRiwayat() async {
    final response = await _apiClient.get('/dosen/riwayat-bimbingan');
    final List list = response.data['data'] ?? [];
    return list.map((item) => RiwayatBimbinganModel.fromJson(item)).toList();
  }

  /// (Mahasiswa) Mengambil daftar riwayat bimbingan milik mahasiswa
  Future<List<RiwayatBimbinganModel>> getMahasiswaRiwayat() async {
    final response = await _apiClient.get('/mahasiswa/riwayat-bimbingan');
    final List list = response.data['data'] ?? [];
    return list.map((item) => RiwayatBimbinganModel.fromJson(item)).toList();
  }

  /// (Dosen) Mengambil daftar jadwal bimbingan berstatus approved yang belum memiliki riwayat bimbingan
  Future<List<JadwalBimbinganModel>> getDosenApprovedJadwal() async {
    final response = await _apiClient.get('/dosen/jadwal-approved');
    final List list = response.data['data'] ?? [];
    return list.map((item) => JadwalBimbinganModel.fromJson(item)).toList();
  }

  /// (Dosen) Menyimpan data riwayat bimbingan dan catatan revisi baru
  Future<RiwayatBimbinganModel> storeRiwayat({
    required int jadwalBimbinganId,
    required String catatanDosen,
    required String status,
    String? catatanMahasiswa,
  }) async {
    final response = await _apiClient.post('/dosen/riwayat-bimbingan', data: {
      'jadwal_bimbingan_id': jadwalBimbinganId,
      'catatan_dosen': catatanDosen,
      'status': status,
      'catatan_mahasiswa': catatanMahasiswa,
    });
    return RiwayatBimbinganModel.fromJson(response.data['data']);
  }
}
