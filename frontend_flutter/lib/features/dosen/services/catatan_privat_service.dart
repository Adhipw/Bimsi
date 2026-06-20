import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/catatan_privat_model.dart';

final catatanPrivatServiceProvider = Provider<CatatanPrivatService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CatatanPrivatService(apiClient);
});

class CatatanPrivatService {
  final ApiClient _apiClient;

  CatatanPrivatService(this._apiClient);

  Future<CatatanPrivatModel?> getCatatan(int mahasiswaId) async {
    final response = await _apiClient.get('/dosen/catatan-privat/$mahasiswaId');
    if (response.data == null) return null;
    return CatatanPrivatModel.fromJson(response.data);
  }

  Future<CatatanPrivatModel> saveCatatan({
    required int mahasiswaId,
    required String catatan,
  }) async {
    final response = await _apiClient.post('/dosen/catatan-privat', data: {
      'mahasiswa_id': mahasiswaId,
      'catatan': catatan,
    });
    return CatatanPrivatModel.fromJson(response.data);
  }
}
