import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pendaftaran_sidang_model.dart';
import '../services/sidang_service.dart';

final pendaftaranSidangListProvider = FutureProvider<List<PendaftaranSidangModel>>((ref) async {
  final service = ref.read(sidangServiceProvider);
  return await service.getStatus();
});

class SubmitPendaftaranSidangNotifier extends StateNotifier<AsyncValue<void>> {
  final SidangService _service;

  SubmitPendaftaranSidangNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> submit({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required String jenisSidang,
    String? fileSyaratUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.submitPendaftaran(
        mahasiswaId: mahasiswaId,
        pengajuanJudulId: pengajuanJudulId,
        jenisSidang: jenisSidang,
        fileSyaratUrl: fileSyaratUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final submitPendaftaranSidangProvider = StateNotifierProvider<SubmitPendaftaranSidangNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(sidangServiceProvider);
  return SubmitPendaftaranSidangNotifier(service);
});
