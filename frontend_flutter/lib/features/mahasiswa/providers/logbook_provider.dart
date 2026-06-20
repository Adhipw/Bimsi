import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/logbook_model.dart';
import '../services/logbook_service.dart';

final logbookListProvider = FutureProvider<List<LogbookModel>>((ref) async {
  final service = ref.read(logbookServiceProvider);
  return await service.getLogbooks();
});

class CreateLogbookNotifier extends StateNotifier<AsyncValue<void>> {
  final LogbookService _service;

  CreateLogbookNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> submit({
    required int mahasiswaId,
    required int pengajuanJudulId,
    required int dosenId,
    required String tanggalKegiatan,
    required String deskripsiKegiatan,
    String? buktiFileUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.createLogbook(
        mahasiswaId: mahasiswaId,
        pengajuanJudulId: pengajuanJudulId,
        dosenId: dosenId,
        tanggalKegiatan: tanggalKegiatan,
        deskripsiKegiatan: deskripsiKegiatan,
        buktiFileUrl: buktiFileUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final createLogbookProvider = StateNotifierProvider<CreateLogbookNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(logbookServiceProvider);
  return CreateLogbookNotifier(service);
});
