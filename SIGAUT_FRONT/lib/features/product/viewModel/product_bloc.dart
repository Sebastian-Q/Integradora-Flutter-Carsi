import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/product/model/product_model.dart';
import 'package:sigaut_frontend/features/product/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository = ProductRepository();

  ProductBloc() : super(StartProduct()) {

    ///LISTO
    on<AllProductsEvent>((event, emit) async {
      emit(StartLoadingState());
      List<ProductModel> listProducts = await productRepository.allProducts();
      emit(AllProductsState(listProducts: listProducts));
      emit(EndLoadingState());
    });

    ///LISTO
    on<SaveProductEvent>((event, emit) async {
      emit(StartLoadingState(message: "Guardando Producto"));
      try {
        bool response = await productRepository.createProduct(productModel: event.productModel);
        if(response) {
          emit(SuccessfulState(message: "Producto guardado exitosamente"));
        } else {
          emit(MessageState(message: "Guardado Fallido", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });

    ///LISTO
    on<EditProductEvent>((event, emit) async {
      debugPrint("EditProductEvent");
      emit(StartLoadingState(message: "Actualizando producto"));
      try {
        bool response = await productRepository.updateProduct(productModel: event.productModel);
        if(response) {
          emit(SuccessfulState(message: event.messageSuccess ?? "Producto editado exitosamente"));
        } else {
          emit(MessageState(message: "Modificación Fallida", typeMessage: AlertTypeMessage.error,));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error,));
      }
      emit(EndLoadingState());
    });

    ///LISTO
    on<DeleteProductEvent>((event, emit) async {
      emit(StartLoadingState(message: "Eliminando producto"));
      try {
        bool response = await productRepository.deleteProduct(event.id);
        if(response) {
          emit(SuccessfulState(message: "Producto eliminado exitosamente", exitWidget: false));
        } else {
          emit(MessageState(message: "Eliminación Fallida", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });
  }
}