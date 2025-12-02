import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/user/model/image_file_model.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository = UserRepository();

  UserBloc() : super(StartUser()) {
    on<GetUserEvent>((event, emit) async {
      emit(StartLoadingState());
      try {
        UserModel userModel = await userRepository.getLocalUser();
        emit(ProfileUserState(userModel: userModel));
      } catch (error) {
        emit(ErrorState(message: error.toString()));
      }
      emit(EndLoadingState());
    });

    on<SaveUserEvent>((event, emit) async {
      emit(StartLoadingState(message: "Guardando usuario"));
      try {
        bool response = await userRepository.saveUser(user: event.userModel);
        if(response) {
          emit(SuccessfulState(message: "Usuario guardado exitosamente"));
        } else {
          emit(MessageState(message: "Guardado Fallido", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });

    on<EditUserEvent>((event, emit) async {
      emit(StartLoadingState(message: "Actualizando información"));
      try {
        if (event.imageFile != null) {
          String imageUrl = await userRepository.photoUser(userId: event.userModel.id, imageFile: event.imageFile!);
          event.userModel.image_url = imageUrl;
        }

        bool response = await userRepository.editUser(user: event.userModel);
        if(response) {
          if(event.updateLocal) {
            userRepository.saveLocalUser(event.userModel);
          }
          emit(SuccessfulState(message: event.messageSuccess ?? "Empleado editado exitosamente"));
        } else {
          emit(MessageState(message: "Modificación Fallida", typeMessage: AlertTypeMessage.error,));
        }
      } catch (error) {
        emit(ErrorState(message: error.toString()));
      }
      emit(EndLoadingState());
    });
  }
}