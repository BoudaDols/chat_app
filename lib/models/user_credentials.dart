class UserCredentials {
  final String email;
  final String hashedPassword;
  final String? token;

  UserCredentials({
    required this.email,
    required this.hashedPassword,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'hashed_password': hashedPassword,
      'token': token,
    };
  }

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      email: json['email'],
      hashedPassword: json['hashed_password'],
      token: json['token'],
    );
  }
}