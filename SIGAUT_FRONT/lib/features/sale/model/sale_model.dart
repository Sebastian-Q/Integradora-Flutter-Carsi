import 'package:sigaut_frontend/features/product/model/product_model.dart';

class SaleModel {
  int id = 0;
  double total = 0.0;
  double amountSale = 0.0;
  DateTime dateSale = DateTime.now();
  String? employee;
  String? payMethod;
  List<ProductModel> productList = [];
  int? idUser;

  SaleModel();

  SaleModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        total = json["total"],
        amountSale = json["amountSale"],
        dateSale = DateTime.parse(json["dateSale"]),
        employee = json["employee"],
        payMethod = json["payMethod"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "total": total,
      "amountSale": amountSale,
      "dateSale": dateSale.toIso8601String(),
      "employee": employee,
      "payMethod": payMethod,
      "productsList": productList.map((product) => product.toMap()).toList()
    };
  }

  Map<String, dynamic> toSaveMap() {
    return {
      "total": total,
      "amountSale": amountSale,
      "dateSale": dateSale.toIso8601String(),
      "employee": employee,
      "payMethod": payMethod,
      "productsList": productList.map((product) => product.toMap()).toList(),
      "idUser": idUser
    };
  }
}