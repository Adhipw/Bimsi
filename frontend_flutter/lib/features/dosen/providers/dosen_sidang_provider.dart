import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/models/pendaftaran_sidang_model.dart';
import '../../mahasiswa/services/sidang_service.dart';

final dosenSidangListProvider = FutureProvider<List<PendaftaranSidangModel>>((ref) async {
  final service = ref.read(sidangServiceProvider);
  return await service.getDosenSidangList();
});

class ApproveSidangNotifier extends StateNotifier<AsyncValue<void>> {
  final SidangService _service;

  ApproveSidangNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> approve(int id) async {
    state = const AsyncValue.loading();
    try {
      await _service.approveSidang(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final approveSidangProvider = StateNotifierProvider<ApproveSidangNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(sidangServiceProvider);
  return ApproveSidangNotifier(service);
});
