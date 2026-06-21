import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<String> uploadAvatar(XFile imageFile) async {
    try {
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeSplit = mimeType.split('/');
      final bytes = await imageFile.readAsBytes();

      FormData formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(
          bytes,
          filename: imageFile.name,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      });

      final response = await _apiClient.post(
        '/profile/avatar',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['avatar_url'];
      } else {
        throw Exception(response.data['message'] ?? 'Gagal upload foto profil');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
      }
      throw Exception('Error: $e');
    }
  }
}
