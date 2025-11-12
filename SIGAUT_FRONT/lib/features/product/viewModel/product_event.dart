part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetProductEvent extends ProductEvent {
  final int id;

  GetProductEvent({required this.id});
}

class AllProductsEvent extends ProductEvent {}

class SaveProductEvent extends ProductEvent {
  final ProductModel productModel;

  SaveProductEvent({required this.productModel});
}

class EditProductEvent extends ProductEvent {
  final ProductModel productModel;
  final String? messageSuccess;

  EditProductEvent({required this.productModel, this.messageSuccess});
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  DeleteProductEvent({required this.id});
}
