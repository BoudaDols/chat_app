import 'package:dio/dio.dart';
import 'package:chat_app/config/api_config.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/message.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      validateStatus: (status) => status! < 500,
    ));
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final response = await _dio.get('/chat-rooms');
      return (response.data['data'] as List)
          .map((room) => ChatRoom.fromJson(room))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch chat rooms: ${e.toString()}');
    }
  }

  Future<List<Message>> getChatMessages(int roomId) async {
    try {
      final response = await _dio.get('/chat-rooms/$roomId/messages');
      return (response.data['data'] as List)
          .map((message) => Message.fromJson(message))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch messages: ${e.toString()}');
    }
  }

  Future<Message> sendMessage(int roomId, String content, String type) async {
    try {
      final response = await _dio.post('/chat-rooms/$roomId/messages', data: {
        'content': content,
        'type': type,
      });
      return Message.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
}