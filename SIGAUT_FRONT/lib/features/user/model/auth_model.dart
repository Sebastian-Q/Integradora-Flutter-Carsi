import 'package:sigaut_frontend/features/user/model/user_model.dart';

class AuthModel {
  String token;
  String tokenType;
  UserModel user;

  AuthModel({required this.token, required this.tokenType, required this.user});

  AuthModel.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        tokenType = json["tokenType"],
        user = UserModel.fromJson(json["user"]);

  Map<String, dynamic> toMap() {
    return {
      "token": token,
      "tokenType": tokenType,
      "user": user,
    };
  }
}