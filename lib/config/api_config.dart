class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api';
  static const String wsUrl = 'ws://localhost:8000/ws';
  static String token = '';

  static void setToken(String newToken) {
    token = newToken;
  }
}