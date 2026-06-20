import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> fetchDashboard(String rolePath);
}

