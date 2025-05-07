import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class LoginEvent {}

final class Login extends LoginEvent {
  final int staffId;
  final String password;

  Login({required this.staffId, required this.password});
}

final class Logout extends LoginEvent {}

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final UserInfoModel userInfoModel;

  LoginSuccess({required this.userInfoModel});
}

final class LoginError extends LoginState {
  final Object error;

  LoginError({required this.error});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DataRepo _dataService;
  LoginBloc(this._dataService) : super(LoginInitial()) {
    on<Login>((event, emit) async {
      emit(LoginLoading());
      try {
        var response = await _dataService.authenticate(
          userid: event.staffId.toString(),
          passw: event.password,
        );
        var user = UserInfoModel(
          userId: response.userId!,
          userName: response.userName!,
          mobileNo: response.mobileNo!,
          userDesg: response.userDesg!,
          userDept: response.userDept!,
        );
        await _dataService.saveUserToLocal(
          userInfoModel: user,
        );
        emit(
          LoginSuccess(
            userInfoModel: user,
          ),
        );
      } catch (e) {
        emit(LoginError(error: e));
      }
    });
    on<Logout>((event, emit) async {
      emit(LoginLoading());
      try {
        await _dataService.clearUserFrmLocal();
        emit(LoginInitial());
      } catch (e) {
        emit(LoginError(error: e));
      }
    });
  }
}
