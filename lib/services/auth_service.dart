import 'package:dio/dio.dart';
import 'package:chat_app/config/api_config.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/models/user_credentials.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    validateStatus: (status) => status! < 500,
  ));

  final StorageService _storage;

  AuthService() : _storage = StorageService();

  Future<void> saveUserCredentials(UserCredentials credentials) async {
    // Store sensitive data in secure storage
    await _storage.storeSecureData('user_email', credentials.email);
    await _storage.storeSecureData('user_password', credentials.hashedPassword);
    if (credentials.token != null) {
      await _storage.storeSecureData('auth_token', credentials.token!);
    }

    // Store session data
    await _storage.storeUserSession({
      'email': credentials.email,
      'is_logged_in': true,
      'last_login': DateTime.now().toIso8601String(),
    });
  }

  Future<bool> isLoggedIn() async {
    final session = await _storage.getUserSession();
    return session?['is_logged_in'] ?? false;
  }

  Future<UserCredentials?> getUserCredentials() async {
    final email = await _storage.getSecureData('user_email');
    final hashedPassword = await _storage.getSecureData('user_password');
    final token = await _storage.getSecureData('auth_token');

    if (email == null || hashedPassword == null) return null;

    return UserCredentials(
      email: email,
      hashedPassword: hashedPassword,
      token: token,
    );
  }

  Future<void> clearUserCredentials() async {
    // Clear secure storage
    await _storage.deleteSecureData('user_email');
    await _storage.deleteSecureData('user_password');
    await _storage.deleteSecureData('auth_token');

    // Clear session data
    await _storage.clearUserSession();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return {
          'user': User.fromJson(response.data['user']),
          'token': response.data['token'],
        };
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register(
    String name, 
    String email, 
    String password
  ) async {
    // print("");
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        return {
          'user': User.fromJson(response.data['user']),
          'token': response.data['token'],
        };
      }
      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}