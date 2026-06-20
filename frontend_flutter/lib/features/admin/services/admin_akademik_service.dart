import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

final adminAkademikServiceProvider = Provider<AdminAkademikService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AdminAkademikService(apiClient);
});

final adminSidangMenungguJadwalProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.read(adminAkademikServiceProvider);
  return service.getMenungguJadwal();
});

class AdminAkademikService {
  final ApiClient _apiClient;

  AdminAkademikService(this._apiClient);

  Future<List<dynamic>> getMenungguJadwal() async {
    final response = await _apiClient.get('/admin/sidang/menunggu-jadwal');
    return response.data['data'] as List<dynamic>;
  }

  Future<List<dynamic>> getRuangans() async {
    final response = await _apiClient.get('/admin/sidang/ruangans');
    return response.data['data'] as List<dynamic>;
  }

  Future<void> plotJadwal({
    required int sidangId,
    required String tanggal,
    required String waktuMulai,
    required String waktuSelesai,
    required int ruanganId,
  }) async {
    await _apiClient.post('/admin/sidang/$sidangId/plot-jadwal', data: {
      'tanggal_sidang': tanggal,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'ruangan_id': ruanganId,
    });
  }

  Future<void> downloadPdf(String url, String filename) async {
    final token = await _apiClient.getToken();
    final fullUrl = '${_apiClient.baseUrl}$url?token=$token';
    
    try {
      final uri = Uri.parse(fullUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $fullUrl');
      }
    } catch (e) {
      throw Exception('Launch error: $e');
    }
  }
}
