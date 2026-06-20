import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final Object? details;

  factory ApiException.fromDioException(DioException error) {
    final response = error.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        message: data['message']?.toString() ?? error.message ?? 'Terjadi kesalahan jaringan',
        statusCode: response?.statusCode,
        code: data['code']?.toString(),
        details: data['errors'] ?? data['details'],
      );
    }

    return ApiException(
      message: error.message ?? 'Terjadi kesalahan jaringan',
      statusCode: response?.statusCode,
      code: error.type.name,
      details: data,
    );
  }

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, code: $code, message: $message)';
  }
}

