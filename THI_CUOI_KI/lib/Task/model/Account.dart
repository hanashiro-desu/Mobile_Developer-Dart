import 'dart:convert';

class Account {
  final String userId;
  final String username;
  final String email;
  final String password;
  final String? avatar;
  final String lastLogin;
  final String createdAt;
  final String role;

  Account({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    this.avatar,
    required this.lastLogin,
    required this.createdAt,
    required this.role,
  });
// Phương thức factory để tạo một đối tượng Account từ Map (thường là JSON từ API)
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      password: map['password'],
      email: map['email'] ?? '',
      avatar: map['avatar'],
      lastLogin: map['lastLogin'] ?? '',
      createdAt: map['createdAt'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
// Phương thức chuyển đối tượng Account thành Map để gửi lên API hoặc lưu trữ
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
      'role': role,
    };
  }

  String toJSON() {
    return jsonEncode(toMap());
  }
// Phương thức tạo bản sao của đối tượng Account với một số thuộc tính có thể thay đổi
  Account copyWith({
    String? userId,
    String? username,
    String? password,
    String? email,
    String? avatar,
    String? lastLogin,
    String? createdAt,
    String? role,
  }) {
    return Account(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }
// Phương thức toString() giúp in ra mô tả ngắn gọn của đối tượng Account,
  @override
  String toString() {
    return 'Account(userId: $userId, username: $username, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Account &&
        other.userId == userId &&
        other.username == username &&
        other.password == password &&
        other.email == email &&
        other.avatar == avatar &&
        other.lastLogin == lastLogin &&
        other.createdAt == createdAt &&
        other.role == role;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
    username.hashCode ^
    password.hashCode ^
    email.hashCode ^
    avatar.hashCode ^
    lastLogin.hashCode ^
    createdAt.hashCode ^
    role.hashCode;
  }
}
