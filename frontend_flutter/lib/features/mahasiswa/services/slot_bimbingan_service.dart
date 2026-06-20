import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/slot_bimbingan_model.dart';
 
final slotBimbinganServiceProvider = Provider<SlotBimbinganService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SlotBimbinganService(apiClient);
});
 
class SlotBimbinganService {
  final ApiClient _apiClient;
 
  SlotBimbinganService(this._apiClient);
 
  /// Mengambil ketersediaan slot bimbingan milik Dosen yang login
  Future<List<SlotBimbinganModel>> getDosenSlots() async {
    final response = await _apiClient.get('/dosen/slots');
    final List list = response.data['data'] ?? [];
    return list.map((item) => SlotBimbinganModel.fromJson(item)).toList();
  }
 
  /// Menambahkan ketersediaan slot bimbingan baru (Dosen)
  Future<SlotBimbinganModel> createSlot({
    required String hari,
    required String jamMulai,
    required String jamSelesai,
    required int kuota,
  }) async {
    final response = await _apiClient.post('/dosen/slots', data: {
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'kuota': kuota,
    });
    return SlotBimbinganModel.fromJson(response.data['data']);
  }
 
  /// Menghapus ketersediaan slot bimbingan (Dosen)
  Future<void> deleteSlot(int id) async {
    await _apiClient.delete('/dosen/slots/$id');
  }
}
