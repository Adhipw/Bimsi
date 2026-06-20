import 'package:dio/dio.dart';

import '../auth/auth_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor([AuthStorage? storage]) : _storage = storage ?? AuthStorage();

  final AuthStorage _storage;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

