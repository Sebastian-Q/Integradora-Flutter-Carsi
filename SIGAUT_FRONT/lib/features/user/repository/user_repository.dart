import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/auth_model.dart';

class UserRepository {
  final Api api = Api();

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
      final response = await api.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint("AUTH: ${data["data"]}");
        final auth = AuthModel.fromJson(data["data"]);
        debugPrint("AUTH: ${auth.toMap()}");
        saveLocalToken(auth.token);
        saveLocalUser(auth.userModel);
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
      AuthModel auth = AuthModel.fromJson(response.data["data"]);
      saveLocalToken(auth.token);
      saveLocalUser(auth.userModel);
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
}