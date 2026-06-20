class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic> meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? dataParser,
  }) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: dataParser == null ? rawData as T? : dataParser(rawData),
      meta: (json['meta'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
    );
  }
}

