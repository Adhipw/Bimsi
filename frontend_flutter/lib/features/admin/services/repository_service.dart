import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';

final repositoryServiceProvider = Provider<RepositoryService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RepositoryService(apiClient);
});

final publicRepositoryProvider = FutureProvider.family<Map<String, dynamic>, String?>((ref, search) async {
  final service = ref.read(repositoryServiceProvider);
  return service.getPublicList(search: search);
});

class RepositoryService {
  final ApiClient _apiClient;

  RepositoryService(this._apiClient);

  Future<Map<String, dynamic>> getPublicList({String? search}) async {
    final params = search != null && search.isNotEmpty ? '?search=$search' : '';
    final response = await _apiClient.get('/public/repository$params');
    return response.data['data'];
  }

  Future<void> publish({
    required int sidangId,
    required String abstrak,
    required String url,
  }) async {
    await _apiClient.post('/admin/repository/publish', data: {
      'pendaftaran_sidang_id': sidangId,
      'abstrak': abstrak,
      'file_dokumen_akhir_url': url,
    });
  }
}
