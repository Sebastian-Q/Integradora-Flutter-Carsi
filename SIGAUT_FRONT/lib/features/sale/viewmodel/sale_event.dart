part of 'sale_bloc.dart';

abstract class SaleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetSaleEvent extends SaleEvent {
  final int id;

  GetSaleEvent({required this.id});
}

class AllSalesEvent extends SaleEvent {
  final String? startDate;
  final String? endDate;

  AllSalesEvent({this.startDate, this.endDate});
}

class SaveSaleEvent extends SaleEvent {
  final SaleModel saleModel;

  SaveSaleEvent({required this.saleModel});
}

class AddProductSaleEvent extends SaleEvent {
  final String codeBar;

  AddProductSaleEvent({required this.codeBar});
}

class RemoveProductSaleEvent extends SaleEvent {
  final ProductModel productModel;

  RemoveProductSaleEvent({required this.productModel});
}