import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

import 'package:sigaut_frontend/features/product/model/product_model.dart';

class ProductRepository {
  final Api api = Api();

  static ProductRepository? _instance;

  factory ProductRepository() => _instance ??= ProductRepository._();

  ProductRepository._();

  ///LISTO
  Future<List<ProductModel>> allProducts() async {
    List<ProductModel> listProducts = [];
    try {
      final response = await api.get(urlProduct);
      debugPrint("response.data: ${response.data["data"]}");
      if (response.data != null) {
        listProducts = List<ProductModel>.from(
            (response.data["data"]).map((json) => ProductModel.fromJson(json))
        );
      }
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al obtener categorias: $e");
    }
    return listProducts;
  }

  ///LISTO
  Future<bool> createProduct({required ProductModel productModel}) async {
    try {
      final response = await api.post(urlProduct, data: productModel.toSaveMap());
      debugPrint("response.data: ${response.data["data"]}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al guardar categoria: $e");
    }
  }

  ///LISTO
  Future<bool> updateProduct({required ProductModel productModel}) async {
    try {
      final response = await api.put(urlProduct, data: productModel.toMap());
      debugPrint("response.data: ${response.data["data"]}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al guardar categoria: $e");
    }
  }

  ///LISTO
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await api.delete("$urlProduct/$id");
      debugPrint("response.data: ${response.data["data"]}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al eliminar categoria: $e");
    }
  }
}