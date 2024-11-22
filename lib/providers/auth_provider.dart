import 'package:flutter/foundation.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  final AuthService _authService = AuthService();

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;

  Future<void> login(String email, String password) async {
    try {
      final result = await _authService.login(email, password);
      _user = result['user'];
      _token = result['token'];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final result = await _authService.register(name, email, password);
      _user = result['user'];
      _token = result['token'];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}