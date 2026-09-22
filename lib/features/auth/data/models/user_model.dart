import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final String message;
  final String token;
  final UserData user;
  UserModel({required this.message, required this.token, required this.user});
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
    name: user.name,
    email: user.email,
    token: token,
    id: '',
  );
}

@JsonSerializable(explicitToJson: true)
class UserData {
  final String name;
  final String email;
  final String? id;
  final String? phone;

  UserData({required this.name, required this.email, this.id, this.phone});
  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}