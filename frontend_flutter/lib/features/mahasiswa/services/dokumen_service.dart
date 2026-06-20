import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/dokumen_skripsi_model.dart';

final dokumenServiceProvider = Provider<DokumenService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return DokumenService(apiClient);
});

class DokumenService {
  final ApiClient _apiClient;

  DokumenService(this._apiClient);

  /// (Mahasiswa) Mengambil daftar dokumen skripsi mahasiswa
  Future<List<DokumenSkripsiModel>> getMahasiswaDokumen() async {
    final response = await _apiClient.get('/mahasiswa/dokumen');
    final List list = response.data['data'] ?? [];
    return list.map((item) => DokumenSkripsiModel.fromJson(item)).toList();
  }

  /// (Dosen) Mengambil daftar dokumen bimbingan mahasiswa yang masuk
  Future<List<DokumenSkripsiModel>> getDosenDokumen() async {
    final response = await _apiClient.get('/dosen/dokumen-bimbingan');
    final List list = response.data['data'] ?? [];
    return list.map((item) => DokumenSkripsiModel.fromJson(item)).toList();
  }

  /// (Mahasiswa) Mengunggah dokumen skripsi baru (Multipart Request)
  Future<void> uploadDokumen({
    required String filePath,
    required String fileName,
    required String jenisDokumen,
    String? catatanRevisi,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
      'jenis_dokumen': jenisDokumen,
      if (catatanRevisi != null && catatanRevisi.trim().isNotEmpty)
        'catatan_revisi': catatanRevisi.trim(),
    });

    await _apiClient.post(
      '/mahasiswa/dokumen',
      data: formData,
    );
  }

  /// (Dosen) Memberikan ulasan / review dan mengubah status dokumen
  Future<void> reviewDokumen({
    required int versiDokumenId,
    required String komentar,
    required String status,
  }) async {
    await _apiClient.post('/dosen/dokumen/review', data: {
      'versi_dokumen_id': versiDokumenId,
      'komentar': komentar.trim(),
      'status': status,
    });
  }
}
