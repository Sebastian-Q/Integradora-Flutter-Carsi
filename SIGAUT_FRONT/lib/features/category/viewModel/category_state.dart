part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartCategory extends CategoryState {}

class StartLoadingState extends CategoryState {
  final String? message;

  StartLoadingState({this.message = "Cargando categorias"});
}

class EndLoadingState extends CategoryState {}

class MessageState extends CategoryState {
  final String message;
  final AlertTypeMessage typeMessage;

  MessageState({required this.message, required this.typeMessage});
}

class SuccessfulState extends CategoryState {
  final String? message;
  final bool exitWidget;

  SuccessfulState({this.message = "Guardado exitoso", this.exitWidget = true});
}

class ErrorState extends CategoryState {
  final String? message;

  ErrorState({this.message = "Error innesperado"});
}

class AllCategoriesState extends CategoryState {
  final List<CategoryModel> listCategories;

  AllCategoriesState({required this.listCategories});
}