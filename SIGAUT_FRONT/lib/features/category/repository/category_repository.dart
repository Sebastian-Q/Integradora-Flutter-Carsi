import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/features/category/model/category_model.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

class CategoryRepository {
  final Api api = Api();

  static CategoryRepository? _instance;

  factory CategoryRepository() => _instance ??= CategoryRepository._();

  CategoryRepository._();

  Future<List<CategoryModel>> allCategories() async {
    List<CategoryModel> listCategories = [];
    try {
      final response = await api.get(urlCategory);
      debugPrint("response.data: ${response.data["data"]}");
      if (response.data != null) {
        listCategories = List<CategoryModel>.from(
            (response.data["data"]).map((json) => CategoryModel.fromJson(json))
        );
      }
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al obtener categorias: $e");
    }
    return listCategories;
  }

  Future<bool> createCategory({required CategoryModel categoryModel}) async {
    try {
      final response = await api.post(urlCategory, data: categoryModel.toSaveMap());
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

  Future<bool> updateCategory({required CategoryModel categoryModel}) async {
    try {
      final response = await api.put(urlCategory, data: categoryModel.toMap());
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

  Future<bool> deleteCategory({required int id}) async {
    try {
      final response = await api.delete("$urlCategory/$id");
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