import '../../../core/services/api_client.dart';
import '../models/progress_skripsi_model.dart';
import '../models/pengajuan_judul_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressSkripsiServiceProvider = Provider((ref) => ProgressSkripsiService());

class ProgressSkripsiService {
  final ApiClient _apiClient = ApiClient();

  // Mahasiswa: Get their own progress
  Future<Map<String, dynamic>> getMahasiswaProgress() async {
    try {
      final response = await _apiClient.get('/mahasiswa/progress');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        
        PengajuanJudulModel pengajuan = PengajuanJudulModel.fromJson(data['pengajuan_judul']);
        int totalPersentase = data['total_persentase'] ?? 0;
        
        List<ProgressSkripsiModel> details = [];
        if (data['progress_detail'] != null && data['progress_detail'] is List) {
          details = (data['progress_detail'] as List)
              .map((item) => ProgressSkripsiModel.fromJson(item))
              .toList();
        }

        return {
          'success': true,
          'pengajuan': pengajuan,
          'total_persentase': totalPersentase,
          'details': details,
        };
      } else {
        final error = response.data;
        return {'success': false, 'message': error['message'] ?? 'Gagal mengambil progress.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  // Kaprodi: Get monitoring progress of all students
  Future<Map<String, dynamic>> getKaprodiMonitoring({int page = 1, String search = ''}) async {
    try {
      final response = await _apiClient.get('/kaprodi/progress-mahasiswa?page=$page&search=$search');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List listData = data['data'];
        List<PengajuanJudulModel> result = listData.map((item) => PengajuanJudulModel.fromJson(item)).toList();
        
        return {
          'success': true,
          'data': result,
          'current_page': data['current_page'],
          'last_page': data['last_page'],
        };
      } else {
        final error = response.data;
        return {'success': false, 'message': error['message'] ?? 'Gagal memuat monitoring progress'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  // Dosen: Update student progress
  Future<Map<String, dynamic>> updateProgressDosen(int pengajuanJudulId, String bab, String status, String keterangan) async {
    try {
      final response = await _apiClient.put('/dosen/progress/$pengajuanJudulId', data: {
        'bab': bab,
        'status': status,
        'keterangan': keterangan,
      });

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Progress berhasil diupdate'};
      } else {
        final error = response.data;
        return {'success': false, 'message': error['message'] ?? 'Gagal update progress'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
