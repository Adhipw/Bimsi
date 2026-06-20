import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/helpers/storage_helper.dart';
import '../../../core/services/api_client.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthService(apiClient);
});

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post('/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data;
    if (data['status'] == 'success') {
      final userData = data['data']['user'];
      final token = data['data']['token'];

      final user = UserModel.fromJson(userData);

      await StorageHelper.saveToken(token);
      await StorageHelper.saveRole(user.role);

      return user;
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/logout');
    } catch (_) {
      // Abaikan error saat logout agar tetap membersihkan session lokal
    } finally {
      await StorageHelper.clearAll();
    }
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get('/profile');
    final data = response.data;
    if (data['status'] == 'success') {
      return UserModel.fromJson(data['data']['user']);
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil profil');
    }
  }
}
