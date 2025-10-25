import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';

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

  void saveLocalUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toMap()));
  }

  void deleteLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
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
        final user = UserModel.fromJson(data);

        // Guardar el token en local
        //final prefs = await SharedPreferences.getInstance();
        //await prefs.setString('token', user.jwtToken?.accessToken ?? '');
        saveLocalUser(user);
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
      UserModel userSave = UserModel.fromJson(response.data["data"]);
      debugPrint("userSave: ${userSave.toMap()}");
      saveLocalUser(userSave);
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