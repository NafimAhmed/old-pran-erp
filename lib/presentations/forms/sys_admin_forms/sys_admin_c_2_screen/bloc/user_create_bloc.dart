import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class UserCreateEvent {}

final class CreateUser extends UserCreateEvent {
  final String newUserId;
  final String newUserName;
  final String userId;
  final String passw;
  final String appUser;
  final String mobileNo;
  final String desigName;
  final String deptName;

  CreateUser(
      {required this.newUserId,
      required this.newUserName,
      required this.userId,
      required this.passw,
      required this.appUser,
      required this.mobileNo,
      required this.desigName,
      required this.deptName});
}

@immutable
sealed class UserCreateState {}

final class UserCreateInitial extends UserCreateState {}

final class UserCreateLoading extends UserCreateState {}

final class UserCreateSuccess extends UserCreateState {
  final List<NewUserInfo> createdUserList;

  UserCreateSuccess({required this.createdUserList});
}

final class UserCreateError extends UserCreateState {
  final Object error;

  UserCreateError({required this.error});
}

class UserCreateBloc extends Bloc<UserCreateEvent, UserCreateState> {
  final DataRepo _dataService;
  UserCreateBloc(this._dataService) : super(UserCreateInitial()) {
    on<CreateUser>((event, emit) async {
      emit(UserCreateLoading());
      try {
        var response = await _dataService.createUser(
          appUser: event.appUser,
          userId: event.userId,
          newUserId: event.newUserId,
          newUserName: event.newUserName,
          desigName: event.desigName,
          deptName: event.deptName,
          mobileNo: event.mobileNo,
          passw: event.passw,
        );
        emit(UserCreateSuccess(createdUserList: response));
      } catch (e) {
        emit(UserCreateError(error: e));
      }
    });
  }
}
