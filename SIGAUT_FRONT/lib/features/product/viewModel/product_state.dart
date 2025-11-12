part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartProduct extends ProductState {}

class StartLoadingState extends ProductState {
  final String? message;

  StartLoadingState({this.message = "Cargando productos"});
}

class EndLoadingState extends ProductState {}

class MessageState extends ProductState {
  final String message;
  final AlertTypeMessage typeMessage;

  MessageState({required this.message, required this.typeMessage});
}

class SuccessfulState extends ProductState {
  final String? message;
  final bool exitWidget;

  SuccessfulState({this.message = "Guardado exitoso", this.exitWidget = true});
}

class ErrorState extends ProductState {
  final String? message;

  ErrorState({this.message = "Error innesperado"});
}

class AllProductsState extends ProductState {
  final List<ProductModel> listProducts;

  AllProductsState({required this.listProducts});
}

