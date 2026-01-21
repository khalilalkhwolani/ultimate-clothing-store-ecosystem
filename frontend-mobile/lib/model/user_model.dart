class UserModel {
  final String? id;
  final String username;
  final String email;
  final String password;
  final String? role;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? memberSince;
  final String? profileImageUrl;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.role,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.memberSince,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      "role": role,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'memberSince': memberSince,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'user',
      phone: map['phone'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      memberSince: map['memberSince'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  // Optional: Override toString for easy printing/debugging
  @override
  String toString() {
    return 'UserModel{id: $id, username: ${username}, email: ${email}, role: $role}';
  }
}
