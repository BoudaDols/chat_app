import 'package:flutter/foundation.dart';
import 'package:chat_app/models/chat_room.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/api_service.dart';
import 'package:chat_app/services/websocket_service.dart';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final WebSocketService _wsService = WebSocketService();
  List<ChatRoom> _chatRooms = [];
  Map<int, List<Message>> _messages = {};

  List<ChatRoom> get chatRooms => _chatRooms;
  List<Message> getMessages(int roomId) => _messages[roomId] ?? [];

  void initialize(String token) {
    _apiService.setToken(token);
    // _wsService.connect(token);
    // _wsService.setMessageHandler(_handleWebSocketMessage);
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    try {
      _chatRooms = await _apiService.getChatRooms();
      notifyListeners();
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }

  Future<void> fetchMessages(int roomId) async {
    try {
      final messages = await _apiService.getChatMessages(roomId);
      _messages[roomId] = messages;
      notifyListeners();
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> sendMessage(int roomId, String content, {String type = 'text'}) async {
    try {
      final message = await _apiService.sendMessage(roomId, content, type);
      _addMessage(roomId, message);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _handleWebSocketMessage(dynamic data) {
    if (data['type'] == 'message') {
      final message = Message.fromJson(data['message']);
      _addMessage(message.chatRoomId, message);
    }
  }

  void _addMessage(int roomId, Message message) {
    if (!_messages.containsKey(roomId)) {
      _messages[roomId] = [];
    }
    _messages[roomId]!.add(message);
    notifyListeners();
  }

  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }
}