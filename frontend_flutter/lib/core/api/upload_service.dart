import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_endpoints.dart';
import 'api_response.dart';

class UploadService {
  UploadService(this._client);

  final ApiClient _client;

  Future<ApiResponse<Map<String, dynamic>>> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    Map<String, dynamic>? fields,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
      'mimeType': mimeType,
      if (fields != null) ...fields,
    });

    final response = await _client.dio.post<Map<String, dynamic>>(
      ApiEndpoints.upload,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ApiResponse<Map<String, dynamic>>.fromJson(
      (response.data ?? <String, dynamic>{}),
      dataParser: (json) => (json as Map).cast<String, dynamic>(),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getSignedUrl({
    required String path,
    required int expiresInSeconds,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      ApiEndpoints.signedUrl,
      data: <String, dynamic>{
        'path': path,
        'expiresInSeconds': expiresInSeconds,
      },
    );

    return ApiResponse<Map<String, dynamic>>.fromJson(
      (response.data ?? <String, dynamic>{}),
      dataParser: (json) => (json as Map).cast<String, dynamic>(),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteFile({
    required String path,
  }) async {
    final response = await _client.dio.delete<Map<String, dynamic>>(
      ApiEndpoints.deleteFile,
      data: <String, dynamic>{'path': path},
    );

    return ApiResponse<Map<String, dynamic>>.fromJson(
      (response.data ?? <String, dynamic>{}),
      dataParser: (json) => (json as Map).cast<String, dynamic>(),
    );
  }
}
