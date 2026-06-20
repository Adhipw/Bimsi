import '../../domain/entities/dashboard_summary.dart';

class DashboardMetricModel extends DashboardMetric {
  const DashboardMetricModel({
    required super.key,
    required super.label,
    required super.value,
    required super.hint,
    required super.icon,
  });

  factory DashboardMetricModel.fromJson(Map<String, dynamic> json) {
    return DashboardMetricModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      hint: json['hint']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'dashboard',
    );
  }
}

class DashboardItemModel extends DashboardItem {
  const DashboardItemModel({
    required super.title,
    required super.description,
    required super.status,
    required super.meta,
  });

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) {
    return DashboardItemModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      meta: (json['meta'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          ) ??
          <String, String>{},
    );
  }
}

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.role,
    required super.title,
    required super.subtitle,
    required super.generatedAt,
    required super.emptyMessage,
    required super.metrics,
    required super.items,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    final metrics = (json['metrics'] as List<dynamic>? ?? const [])
        .map((item) => DashboardMetricModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();
    final items = (json['items'] as List<dynamic>? ?? const [])
        .map((item) => DashboardItemModel.fromJson((item as Map).cast<String, dynamic>()))
        .toList();

    return DashboardSummaryModel(
      role: json['role']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      generatedAt: DateTime.tryParse(json['generatedAt']?.toString() ?? '') ?? DateTime.now(),
      emptyMessage: json['emptyMessage']?.toString() ?? '',
      metrics: metrics,
      items: items,
    );
  }
}

