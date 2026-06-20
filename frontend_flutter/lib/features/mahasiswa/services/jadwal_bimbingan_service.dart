import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/jadwal_bimbingan_model.dart';
import '../models/slot_bimbingan_model.dart';
 
final jadwalBimbinganServiceProvider = Provider<JadwalBimbinganService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return JadwalBimbinganService(apiClient);
});
 
class JadwalBimbinganService {
  final ApiClient _apiClient;
 
  JadwalBimbinganService(this._apiClient);
 
  /// (Mahasiswa) Mengambil daftar riwayat jadwal bimbingan mahasiswa
  Future<List<JadwalBimbinganModel>> getMahasiswaJadwal() async {
    final response = await _apiClient.get('/mahasiswa/jadwal');
    final List list = response.data['data'] ?? [];
    return list.map((item) => JadwalBimbinganModel.fromJson(item)).toList();
  }
 
  /// (Mahasiswa) Mengambil daftar slot waktu milik dosen pembimbing tertentu
  Future<List<SlotBimbinganModel>> getPembimbingSlots(int pembimbingId) async {
    final response = await _apiClient.get('/mahasiswa/pembimbing/$pembimbingId/slots');
    final List list = response.data['data'] ?? [];
    return list.map((item) => SlotBimbinganModel.fromJson(item)).toList();
  }
 
  /// (Mahasiswa) Mengajukan jadwal bimbingan skripsi baru
  Future<JadwalBimbinganModel> ajukanJadwal({
    required int pembimbingId,
    required int slotBimbinganId,
    required String tanggal,
  }) async {
    final response = await _apiClient.post('/mahasiswa/jadwal', data: {
      'pembimbing_id': pembimbingId,
      'slot_bimbingan_id': slotBimbinganId,
      'tanggal': tanggal,
    });
    return JadwalBimbinganModel.fromJson(response.data['data']);
  }
 
  /// (Mahasiswa) Membatalkan jadwal bimbingan yang masih berstatus menunggu (scheduled)
  Future<void> cancelJadwal(int id) async {
    await _apiClient.post('/mahasiswa/jadwal/$id/cancel');
  }
 
  /// (Dosen) Mengambil daftar ajukan bimbingan mahasiswa yang masuk
  Future<List<JadwalBimbinganModel>> getDosenJadwal() async {
    final response = await _apiClient.get('/dosen/jadwal');
    final List list = response.data['data'] ?? [];
    return list.map((item) => JadwalBimbinganModel.fromJson(item)).toList();
  }
 
  /// (Dosen) Menyetujui jadwal bimbingan mahasiswa
  Future<void> approveJadwal(int id) async {
    await _apiClient.post('/dosen/jadwal/$id/approve');
  }
 
  /// (Dosen) Menolak jadwal bimbingan mahasiswa
  Future<void> rejectJadwal(int id) async {
    await _apiClient.post('/dosen/jadwal/$id/reject');
  }
}
