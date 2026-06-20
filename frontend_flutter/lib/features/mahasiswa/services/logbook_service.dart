import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/logbook_model.dart';

final logbookServiceProvider = Provider<LogbookService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LogbookService(apiClient);
});

class LogbookService {
  final ApiClient _apiClient;

  LogbookService(this._apiClient);

  Future<List<LogbookModel>> getLogbooks() async {
    final response = await _apiClient.get('/mahasiswa/logbook');
    final List data = response.data;
    return data.map((e) => LogbookModel.fromJson(e)).toList();
  }

  Future<LogbookModel> createLogbook({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required int dosenId,
    required String tanggalKegiatan,
    required String deskripsiKegiatan,
    String? buktiFileUrl,
  }) async {
    final response = await _apiClient.post('/mahasiswa/logbook', data: {
      'mahasiswa_id': mahasiswaId,
      'pengajuan_judul_id': pengajuanJudulId,
      'dosen_id': dosenId,
      'tanggal_kegiatan': tanggalKegiatan,
      'deskripsi_kegiatan': deskripsiKegiatan,
      'bukti_file_url': buktiFileUrl,
    });
    return LogbookModel.fromJson(response.data);
  }

  // ==========================================
  // DOSEN ENDPOINTS
  // ==========================================

  Future<void> approveLogbook(int id, String statusApproval) async {
    await _apiClient.put('/dosen/logbook/$id/approve', data: {
      'status_approval': statusApproval, // pending, approved, revised
    });
  }
}
