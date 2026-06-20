import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pusat_bantuan_model.dart';
import '../services/pusat_bantuan_service.dart';

final pusatBantuanListProvider = FutureProvider.family<List<PusatBantuanModel>, String?>((ref, kategori) async {
  final service = ref.read(pusatBantuanServiceProvider);
  return await service.getPublicBantuan(kategori: kategori);
});
