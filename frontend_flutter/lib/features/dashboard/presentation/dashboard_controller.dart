import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../auth/application/auth_session_controller.dart';
import '../data/datasources/dashboard_remote_data_source.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/entities/dashboard_summary.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/usecases/get_dashboard_summary_usecase.dart';

final dashboardApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(enableLogging: true);
});

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource(ref.watch(dashboardApiClientProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
});

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummaryUseCase>((ref) {
  return GetDashboardSummaryUseCase(ref.watch(dashboardRepositoryProvider));
});

final dashboardSummaryProvider = FutureProvider.family<DashboardSummary, String>((ref, role) async {
  final useCase = ref.watch(getDashboardSummaryUseCaseProvider);
  return useCase(_rolePath(role));
});

String _rolePath(String role) {
  switch (role) {
    case 'mahasiswa':
      return 'mahasiswa';
    case 'dosen':
      return 'dosen';
    case 'koordinator':
      return 'koordinator';
    case 'admin':
      return 'admin';
    case 'superAdmin':
      return 'super_admin';
    default:
      return 'mahasiswa';
  }
}

