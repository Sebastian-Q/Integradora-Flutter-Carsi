part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartUser extends UserState {}

class StartLoadingState extends UserState {
  final String? message;

  StartLoadingState({this.message = "Cargando..."});
}

class EndLoadingState extends UserState {}

class MessageState extends UserState {
  final String message;
  final AlertTypeMessage typeMessage;

  MessageState({required this.message, required this.typeMessage});
}

class SuccessfulState extends UserState {
  final String? message;
  final bool exitWidget;

  SuccessfulState({this.message = "Registro exitoso", this.exitWidget = true});
}

class ErrorState extends UserState {
  final String? message;

  ErrorState({this.message = "Error innesperado"});
}

class ProfileUserState extends UserState {
  final UserModel userModel;

  ProfileUserState({required this.userModel});
}