import 'package:dio/dio.dart';

import '../auth/auth_storage.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

class ApiClient {
  ApiClient({
    String? baseUrl,
    AuthStorage? authStorage,
    bool enableLogging = true,
    List<Interceptor> extraInterceptors = const [],
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            validateStatus: (status) => status != null && status < 600,
          ),
        ) {
    dio.interceptors.add(AuthInterceptor(authStorage));
    if (enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }
    dio.interceptors.addAll(extraInterceptors);
  }

  final Dio dio;
}
