import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/referensi_model.dart';

final referensiServiceProvider = Provider<ReferensiService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ReferensiService(apiClient);
});

class ReferensiService {
  final ApiClient _apiClient;

  ReferensiService(this._apiClient);

  Future<List<ReferensiModel>> getReferensiList() async {
    final response = await _apiClient.get('/mahasiswa/referensi');
    final List data = response.data;
    return data.map((e) => ReferensiModel.fromJson(e)).toList();
  }

  Future<ReferensiModel> addReferensi({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required String judulArtikel,
    String? penulis,
    String? tahunTerbit,
    String? urlTautan,
    required String tipeReferensi,
  }) async {
    final response = await _apiClient.post('/mahasiswa/referensi', data: {
      'mahasiswa_id': mahasiswaId,
      'pengajuan_judul_id': pengajuanJudulId,
      'judul_artikel': judulArtikel,
      'penulis': penulis,
      'tahun_terbit': tahunTerbit,
      'url_tautan': urlTautan,
      'tipe_referensi': tipeReferensi,
    });
    return ReferensiModel.fromJson(response.data);
  }

  Future<void> deleteReferensi(int id) async {
    await _apiClient.delete('/mahasiswa/referensi/$id');
  }
}
