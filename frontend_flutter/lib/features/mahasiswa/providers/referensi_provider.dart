import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/referensi_model.dart';
import '../services/referensi_service.dart';

final referensiListProvider = FutureProvider<List<ReferensiModel>>((ref) async {
  final service = ref.read(referensiServiceProvider);
  return await service.getReferensiList();
});

class AddReferensiNotifier extends StateNotifier<AsyncValue<void>> {
  final ReferensiService _service;

  AddReferensiNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> add({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required String judulArtikel,
    String? penulis,
    String? tahunTerbit,
    String? urlTautan,
    required String tipeReferensi,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.addReferensi(
        mahasiswaId: mahasiswaId,
        pengajuanJudulId: pengajuanJudulId,
        judulArtikel: judulArtikel,
        penulis: penulis,
        tahunTerbit: tahunTerbit,
        urlTautan: urlTautan,
        tipeReferensi: tipeReferensi,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> remove(int id) async {
    try {
      await _service.deleteReferensi(id);
    } catch (e) {
      // ignore
    }
  }
}

final addReferensiProvider = StateNotifierProvider<AddReferensiNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(referensiServiceProvider);
  return AddReferensiNotifier(service);
});
