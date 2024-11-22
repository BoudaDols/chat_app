class Message {
  final int id;
  final int chatRoomId;
  final int userId;
  final String content;
  final String type;
  final DateTime? readAt;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.content,
    required this.type,
    this.readAt,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatRoomId: json['chat_room_id'],
      userId: json['user_id'],
      content: json['content'],
      type: json['type'],
      readAt: json['read_at'] != null 
        ? DateTime.parse(json['read_at']) 
        : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'user_id': userId,
      'content': content,
      'type': type,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}