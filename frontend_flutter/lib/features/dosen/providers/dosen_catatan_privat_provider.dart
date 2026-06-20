import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/catatan_privat_model.dart';
import '../services/catatan_privat_service.dart';

final catatanPrivatProvider = FutureProvider.family<CatatanPrivatModel?, int>((ref, mahasiswaId) async {
  final service = ref.read(catatanPrivatServiceProvider);
  return await service.getCatatan(mahasiswaId);
});

class SaveCatatanNotifier extends StateNotifier<AsyncValue<void>> {
  final CatatanPrivatService _service;

  SaveCatatanNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> save(int mahasiswaId, String catatan) async {
    state = const AsyncValue.loading();
    try {
      await _service.saveCatatan(mahasiswaId: mahasiswaId, catatan: catatan);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final saveCatatanProvider = StateNotifierProvider<SaveCatatanNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(catatanPrivatServiceProvider);
  return SaveCatatanNotifier(service);
});
