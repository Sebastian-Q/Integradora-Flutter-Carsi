import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/user/model/image_file_model.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/auth_model.dart';

class UserRepository {
  final Api api = Api();

  final fcm = FirebaseMessaging.instance;

  /// Obtener token del dispositivo
  Future<String> generateDeviceToken() async {
    String? token = await fcm.getToken();
    return token ?? "";
  }

  Future<String> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('device') ?? '';
    return token;
  }

  Future<UserModel> getLocalUser() async {
    UserModel user = UserModel();
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user'); // Leer el JSON
    if (userJson != null) {
      user = UserModel.fromJson(json.decode(userJson));
    }
    return user;
  }

  Future<String> getLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return token;
  }

  void saveLocalUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toMap()));
  }

  void saveLocalToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void saveTokenDevice(String device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device', device);
  }

  void deleteLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  void deleteLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String> login({required String username, required String password}) async {
    try {
      final device = await generateDeviceToken();
      debugPrint("FCM TOKEN: $device");

      final response = await api.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          'device': device
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final auth = AuthModel.fromJson(data["data"]);

        saveLocalToken(auth.token);
        saveLocalUser(auth.userModel);
        saveTokenDevice(device);

        return "exito";
      } else {
        return "Usuario o contraseña incorrectos";
      }
    } on DioException catch (e) {
      debugPrint("Error: $e");
      return "Usuario o contraseña incorrectos";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<bool> saveUser({required UserModel user}) async {
    try {
      final response = await api.post(urlUser, data: user.toSave());
      debugPrint("response.data: ${response.data["data"]}");
      /// Bloqueado para que funcione bien todo xd
      /*AuthModel auth = AuthModel.fromJson(response.data["data"]);
      saveLocalToken(auth.token);
      saveLocalUser(auth.userModel);*/
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al guardar usuario: $e");
    }
  }

  Future<bool> editUser({required UserModel user}) async {
    try {
      final response = await api.put(urlUser, data: user.toMap());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String> photoUser({required int userId, required ImageFileModel imageFile}) async {
    try {
      final file = imageFile.file!;

      debugPrint("ENTRO AQUI: $file");

      final fileName = file.path.split("/").last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: DioMediaType.parse(imageFile.contentType),
        ),
      });

      final response = await api.post(
        "$urlUser/$userId/profile-picture",
        data: formData,
      );

      debugPrint("RESPONSE: $response");
      debugPrint("RESPONSE: ${response.data}");
      debugPrint("RESPONSE: ${response.data["data"]}");

      return response.data["data"];
    } catch (e) {
      print("Error subiendo imagen: $e");
      return e.toString();
    }
  }

}