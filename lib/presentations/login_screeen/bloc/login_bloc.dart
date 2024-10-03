import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class LoginEvent {}

final class Login extends LoginEvent {
  final int staffId;
  final String password;

  Login({required this.staffId, required this.password});
}

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {
  final Object error;

  LoginError({required this.error});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<Login>((event, emit) async {
      emit(LoginLoading());
      try {
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            emit(LoginSuccess());
            // emit(LoginError(error: ""));
          },
        );
      } catch (e) {
        emit(LoginError(error: e));
      }
    });
  }
}
