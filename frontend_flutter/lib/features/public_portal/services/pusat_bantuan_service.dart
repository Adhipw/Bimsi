import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/pusat_bantuan_model.dart';

final pusatBantuanServiceProvider = Provider<PusatBantuanService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PusatBantuanService(apiClient);
});

class PusatBantuanService {
  final ApiClient _apiClient;

  PusatBantuanService(this._apiClient);

  Future<List<PusatBantuanModel>> getPublicBantuan({String? kategori}) async {
    final query = <String, dynamic>{};
    if (kategori != null) query['kategori'] = kategori;
    
    final response = await _apiClient.get('/public/pusat-bantuan', queryParameters: query);
    final List data = response.data;
    return data.map((e) => PusatBantuanModel.fromJson(e)).toList();
  }
}
