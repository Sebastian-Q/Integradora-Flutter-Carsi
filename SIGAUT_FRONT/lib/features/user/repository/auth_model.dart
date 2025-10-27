import 'package:sigaut_frontend/features/user/model/user_model.dart';

class AuthModel {
  late String token;
  late String tokenType;
  late UserModel userModel;

  AuthModel();

  AuthModel.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        tokenType = json["tokenType"],
        userModel = UserModel.fromJson(json["user"]);

  Map<String, dynamic> toMap() {
    return {
      "token": token,
      "tokenType": tokenType,
      "user": userModel.toMap(),
    };
  }
}