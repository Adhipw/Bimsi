import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mahasiswa/services/logbook_service.dart';

class ApproveLogbookNotifier extends StateNotifier<AsyncValue<void>> {
  final LogbookService _service;

  ApproveLogbookNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> approve(int id, String status) async {
    state = const AsyncValue.loading();
    try {
      await _service.approveLogbook(id, status);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final approveLogbookProvider = StateNotifierProvider<ApproveLogbookNotifier, AsyncValue<void>>((ref) {
  final service = ref.read(logbookServiceProvider);
  return ApproveLogbookNotifier(service);
});
