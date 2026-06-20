import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';

final kaprodiPengujiServiceProvider = Provider<KaprodiPengujiService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return KaprodiPengujiService(apiClient);
});

final kaprodiSidangMenungguPengujiProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.read(kaprodiPengujiServiceProvider);
  return service.getSidangMenungguPenguji();
});

class KaprodiPengujiService {
  final ApiClient _apiClient;

  KaprodiPengujiService(this._apiClient);

  Future<List<dynamic>> getSidangMenungguPenguji() async {
    final response = await _apiClient.get('/kaprodi/penguji/sidang');
    return response.data['data'] as List<dynamic>;
  }

  Future<void> assignPenguji(int sidangId, int penguji1Id, int penguji2Id) async {
    await _apiClient.post('/kaprodi/penguji/sidang/$sidangId/assign', data: {
      'penguji_1_dosen_id': penguji1Id,
      'penguji_2_dosen_id': penguji2Id,
    });
  }
}
