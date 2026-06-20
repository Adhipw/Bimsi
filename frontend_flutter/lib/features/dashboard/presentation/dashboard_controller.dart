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

final dashboardSummaryProvider = FutureProvider.family<DashboardSummary, UserRole>((ref, role) async {
  final useCase = ref.watch(getDashboardSummaryUseCaseProvider);
  return useCase(_rolePath(role));
});

String _rolePath(UserRole role) {
  switch (role) {
    case UserRole.mahasiswa:
      return 'mahasiswa';
    case UserRole.dosen:
      return 'dosen';
    case UserRole.koordinator:
      return 'koordinator';
    case UserRole.admin:
      return 'admin';
    case UserRole.superAdmin:
      return 'super_admin';
  }
}

