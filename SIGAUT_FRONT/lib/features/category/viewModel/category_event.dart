part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCategoryEvent extends CategoryEvent {
  final int id;

  GetCategoryEvent({required this.id});
}

class AllCategoriesEvent extends CategoryEvent {}

class SaveCategoryEvent extends CategoryEvent {
  final CategoryModel categoryModel;

  SaveCategoryEvent({required this.categoryModel});
}

class EditCategoryEvent extends CategoryEvent {
  final CategoryModel categoryModel;
  final String? messageSuccess;

  EditCategoryEvent({required this.categoryModel, this.messageSuccess});
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  DeleteCategoryEvent({required this.id});
}
