import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigaut_frontend/core/api/api.dart';
import 'package:sigaut_frontend/features/product/model/product_model.dart';
import 'package:sigaut_frontend/features/sale/model/sale_model.dart';
import 'package:sigaut_frontend/core/utils/urls.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

class SaleRepository {
  final Api api = Api();
  static SaleRepository? _instance;

  factory SaleRepository() => _instance ??= SaleRepository._();

  SaleRepository._();

  Future<List<SaleModel>> getSales({String? startDate, String? endDate}) async {
    List<SaleModel> listSales = [];
    try {
      final response = await api.get(startDate != null && endDate != null ? '$urlBack$urlSale?startDate=$startDate&endDate=$endDate' : '$urlBack$urlSale');
      debugPrint("response.data: ${response.data["data"]}");
      if (response.data != null) {
        listSales = List<SaleModel>.from(
            (response.data["data"]).map((json) => SaleModel.fromJson(json))
        );
      }
    } on DioException catch (e) {
      final errorMessage = getDioErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Error al obtener categorias: $e");
    }
    return listSales;
  }

  Future<bool> createSale({required SaleModel saleModel}) async {
    try {
      final response = await api.post('$urlBack$urlSale', data: saleModel.toSaveMap());
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

  Future<ProductModel> addProduct({required String codeBar}) async {
    ProductModel productModel = ProductModel();
    try {
      final response = await api.get('$urlBack$urlProduct/barcode/$codeBar');
      debugPrint("response.data: ${response.data["data"]}");
      if (response.statusCode == 200) {
        productModel = ProductModel.fromJson(response.data["data"]);
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint("ERROR: $error");
    }
    return productModel;
  }
}