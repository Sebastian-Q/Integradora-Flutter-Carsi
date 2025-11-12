import 'package:sigaut_frontend/features/category/model/category_model.dart';

class ProductModel {
  int id = 0;
  String name = "";
  double price = 0.0;
  String barCode = "";
  String description = "";
  double stock = 0.0;
  double quantityMinima = 0.0;
  double accountSale = 0;
  CategoryModel? category;
  int? idUser;

  ProductModel();

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        barCode = json["barCode"] ?? "",
        price = json["price"],
        description = json["description"],
        stock = json["stock"],
        quantityMinima = json["quantityMinima"],
        category = CategoryModel.fromJson(json["category"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "barCode": barCode,
      "price": price,
      "description": description,
      "stock": stock,
      "quantityMinima": quantityMinima,
      "accountSale": accountSale,
      "category": category?.toMap(),
    };
  }

  Map<String, dynamic> toSaveMap() {
    return {
      "name": name,
      "barCode": barCode,
      "price": price,
      "description": description,
      "stock": stock,
      "quantityMinima": quantityMinima,
      "accountSale": accountSale,
      "idCategory": category?.id,
      "idUser": idUser,
    };
  }
}