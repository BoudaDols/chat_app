// class ApiConfig {
//   static const String baseUrl = 'http://localhost:8000/api';
//   static const String wsUrl = 'ws://localhost:6001/ws';
//   static String token = '';
//
//   static void setToken(String newToken) {
//     token = newToken;
//   }
// }


class ApiConfig {
  // Use localhost for Android emulator to access host machine's localhost
  static const String baseUrl = 'http://localhost:8000/api';

  // WebSocket URL using Laravel WebSockets
  static const String wsUrl = 'ws://localhost:6001/app/11a05d841601613d2c4d';

  static String token = '';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  static void setToken(String newToken) {
    token = newToken;
  }
}