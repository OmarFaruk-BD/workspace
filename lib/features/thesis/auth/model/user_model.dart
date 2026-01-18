import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final String? role;
  final String? position;
  final String? department;
  final String? birthDate;
  final String? imageUrl;
  final String? approved;
  final DateTime? createdAt;
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.position,
    this.role,
    this.department,
    this.birthDate,
    this.imageUrl,
    this.approved,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isEmployee => role == 'employee';

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? position,
    String? role,
    String? department,
    String? birthDate,
    String? imageUrl,
    String? approved,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      position: position ?? this.position,
      role: role ?? this.role,
      department: department ?? this.department,
      birthDate: birthDate ?? this.birthDate,
      imageUrl: imageUrl ?? this.imageUrl,
      approved: approved ?? this.approved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'position': position,
      'role': role,
      'department': department,
      'birthDate': birthDate,
      'imageUrl': imageUrl,
      'approved': approved,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      department: map['department'] != null
          ? map['department'] as String
          : null,
      birthDate: map['birthDate'] != null ? map['birthDate'] as String : null,
      imageUrl: map['avatar'] != null ? map['avatar'] as String : null,
      approved: map['approved'] != null ? map['approved'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, position: $position, department: $department, birthDate: $birthDate, avatar: $imageUrl, approved: $approved createdAt: $createdAt role: $role)';
  }
}
