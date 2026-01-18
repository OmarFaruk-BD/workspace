import 'dart:convert';

import 'package:workspace/features/thesis/auth/model/user_model.dart';

class RegistrationModel {
  final String? accessToken;
  final UserModel? user;

  RegistrationModel({
    this.accessToken,
    this.user,
  });

  RegistrationModel copyWith({
    String? accessToken,
    String? tokenType,
    num? expiresIn,
    UserModel? user,
  }) => RegistrationModel(
    accessToken: accessToken ?? this.accessToken,
    user: user ?? this.user,
  );

  factory RegistrationModel.fromJson(String str) =>
      RegistrationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegistrationModel.fromMap(Map<String, dynamic> json) =>
      RegistrationModel(
        accessToken: json["access_token"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "user": user?.toMap(),
  };
}
