import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final laporanServiceProvider = Provider((ref) => LaporanService());

class LaporanService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getMahasiswaSkripsi() async {
    final response = await _apiClient.get('/kaprodi/laporan/mahasiswa-skripsi');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['success'] == true) {
        return data['data'];
      }
      throw Exception(data['message'] ?? 'Gagal memuat laporan');
    }
    throw Exception('Gagal memuat laporan, status: ${response.statusCode}');
  }

  Future<void> exportLaporan(String type) async {
    try {
      final response = await _apiClient.get('/kaprodi/laporan/mahasiswa-skripsi?export=$type');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['download_url'] != null) {
          final url = Uri.parse(data['download_url']);
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            throw Exception('Could not launch $url');
          }
        } else {
          throw Exception('Gagal men-generate laporan $type');
        }
      } else {
        throw Exception('Gagal men-generate laporan $type, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal export: $e');
    }
  }
}
