import 'message.dart';
import 'user.dart';

class ChatRoom {
  final int id;
  final String name;
  final String type;
  final List<User> participants;
  final Message? lastMessage;

  ChatRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.participants,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      participants: (json['participants'] as List)
          .map((p) => User.fromJson(p))
          .toList(),
      lastMessage: json['last_message'] != null 
        ? Message.fromJson(json['last_message']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
    };
  }
}