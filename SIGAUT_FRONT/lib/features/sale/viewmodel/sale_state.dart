part of 'sale_bloc.dart';

abstract class SaleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartLoadingState extends SaleState {
  final String? message;

  StartLoadingState({this.message = "Cargando ventas"});
}

class EndLoadingState extends SaleState {}

class MessageState extends SaleState {
  final String message;
  final AlertTypeMessage typeMessage;

  MessageState({required this.message, required this.typeMessage});
}

class SuccessfulState extends SaleState {
  final String? message;
  final bool exitWidget;

  SuccessfulState({this.message = "Venda completada exitosamente", this.exitWidget = true});
}

class ErrorState extends SaleState {
  final String? message;

  ErrorState({this.message = "Error innesperado"});
}

class StartSale extends SaleState {}

class AllSalesState extends SaleState {
  final List<SaleModel> listSales;

  AllSalesState({required this.listSales});
}

class AddProductSaleState extends SaleState {
  final ProductModel productModel;

  AddProductSaleState({required this.productModel});
}

class RemoveProductSaleState extends SaleState {
  final ProductModel productModel;

  RemoveProductSaleState({required this.productModel});
}