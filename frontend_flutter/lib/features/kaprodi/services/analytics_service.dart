import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AnalyticsService(apiClient);
});

final kaprodiAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(analyticsServiceProvider);
  return service.getKaprodiAnalytics();
});

class AnalyticsService {
  final ApiClient _apiClient;

  AnalyticsService(this._apiClient);

  Future<Map<String, dynamic>> getKaprodiAnalytics() async {
    final response = await _apiClient.get('/kaprodi/dashboard-analytics');
    return response.data['data'];
  }
}
