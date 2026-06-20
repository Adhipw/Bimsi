class DashboardMetric {
  const DashboardMetric({
    required this.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
  });

  final String key;
  final String label;
  final String value;
  final String hint;
  final String icon;
}

class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.description,
    required this.status,
    required this.meta,
  });

  final String title;
  final String description;
  final String status;
  final Map<String, String> meta;
}

class DashboardSummary {
  const DashboardSummary({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.generatedAt,
    required this.emptyMessage,
    required this.metrics,
    required this.items,
  });

  final String role;
  final String title;
  final String subtitle;
  final DateTime generatedAt;
  final String emptyMessage;
  final List<DashboardMetric> metrics;
  final List<DashboardItem> items;
}

