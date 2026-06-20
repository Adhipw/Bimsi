import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_response.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<DashboardSummaryModel> fetchDashboard(String rolePath) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(_endpointForRole(rolePath));
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson((response.data ?? <String, dynamic>{}));
    if ((response.statusCode ?? 500) >= 400 || !apiResponse.success) {
      throw ApiException(
        message: apiResponse.message.isNotEmpty ? apiResponse.message : 'Dashboard gagal dimuat.',
        statusCode: response.statusCode,
      );
    }
    final data = apiResponse.data ?? <String, dynamic>{};
    return DashboardSummaryModel.fromJson(data);
  }

  String _endpointForRole(String rolePath) {
    switch (rolePath) {
      case 'mahasiswa':
        return ApiEndpoints.dashboardMahasiswa;
      case 'dosen':
        return ApiEndpoints.dashboardDosen;
      case 'koordinator':
        return ApiEndpoints.dashboardKoordinator;
      case 'admin':
        return ApiEndpoints.dashboardAdmin;
      case 'super_admin':
        return ApiEndpoints.dashboardSuperAdmin;
      default:
        return ApiEndpoints.dashboardMahasiswa;
    }
  }
}
