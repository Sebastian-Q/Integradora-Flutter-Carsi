import 'package:dio/dio.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  late final Dio dio;

  Api() {
    dio = _createDioWithInterceptor();
  }

  /// Crea una instancia de Dio con interceptor para añadir el token
  Dio _createDioWithInterceptor() {
    final dio = Dio(
      BaseOptions(
        baseUrl: urlBack, // <-- tu baseUrl
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(responseBody: true, requestBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtiene el token desde SharedPreferences (puedes cambiarlo si lo guardas en otro lado)
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Puedes manejar errores globales (401, 500, etc.)
          if (e.response?.statusCode == 401) {
            // Ejemplo: redirigir a login o refrescar token
            print('⚠️ Token inválido o expirado');
          }
          return handler.next(e);
        },
      ),
    ]);

    return dio;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await dio.delete(path, data: data);
  }
}