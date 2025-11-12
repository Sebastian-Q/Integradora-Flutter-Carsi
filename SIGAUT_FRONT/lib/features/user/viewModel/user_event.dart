part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvent {
  final int id;

  GetUserEvent({required this.id});
}

class SaveUserEvent extends UserEvent {
  final UserModel userModel;

  SaveUserEvent({required this.userModel});
}

class EditUserEvent extends UserEvent {
  final UserModel userModel;
  final String? messageSuccess;
  final bool updateLocal;

  EditUserEvent({required this.userModel, this.messageSuccess, this.updateLocal = false});
}