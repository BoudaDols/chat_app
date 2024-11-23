class User {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String status;
  final DateTime? lastSeen;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.status,
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      status: json['status'] as String? ?? 'offline',
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'status': status,
      'last_seen': lastSeen?.toIso8601String(),
    };
  }
}