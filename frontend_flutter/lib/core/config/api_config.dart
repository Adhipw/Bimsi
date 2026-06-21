import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Fallback default Laravel local dev server
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';
      }
    } catch (_) {
      // Fallback untuk platform web/lainnya jika Platform.isAndroid melempar UnsupportedError
    }
    return 'http://127.0.0.1:8080/api';
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
