import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';

final turnitinServiceProvider = Provider<TurnitinService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return TurnitinService(apiClient);
});

final turnitinMenungguProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.read(turnitinServiceProvider);
  return service.getMenungguVerifikasi();
});

class TurnitinService {
  final ApiClient _apiClient;

  TurnitinService(this._apiClient);

  Future<List<dynamic>> getMenungguVerifikasi() async {
    final response = await _apiClient.get('/admin/turnitin/menunggu');
    return response.data['data'] as List<dynamic>;
  }

  Future<void> verifikasi(int sidangId, String status) async {
    await _apiClient.post('/admin/turnitin/$sidangId/verifikasi', data: {
      'turnitin_status': status,
    });
  }
}
