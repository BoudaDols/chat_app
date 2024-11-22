import 'package:dio/dio.dart';
import 'package:chat_app/config/api_config.dart';
import 'package:chat_app/models/user.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    validateStatus: (status) => status! < 500,
  ));

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