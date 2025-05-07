import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class UserOrgEvent {}

final class UserOrgGet extends UserOrgEvent {
  final String userId;
  final String orgType;
  UserOrgGet({
    required this.userId,
    required this.orgType,
  });
}

@immutable
sealed class UserOrgState {}

final class UserOrgInitial extends UserOrgState {}

final class UserOrgLoading extends UserOrgState {}

final class UserOrgSuccess extends UserOrgState {
  final List<UserOrg> userOrg;

  UserOrgSuccess({required this.userOrg});
}

final class UserOrgError extends UserOrgState {
  final Object error;

  UserOrgError({required this.error});
}

class UserOrgBloc extends Bloc<UserOrgEvent, UserOrgState> {
  final DataRepo _dataService;
  List<UserOrg> _userOrg = [];
  UserOrgBloc(this._dataService) : super(UserOrgInitial()) {
    on<UserOrgGet>((event, emit) async {
      emit(UserOrgLoading());
      try {
        List<UserOrg> response = List.empty();
        if (event.orgType == "prod") {
          response = await _dataService.getUserOrg(userid: event.userId);
        } else if (event.orgType == "rcving") {
          response = await _dataService.getRcvingOrgs();
        }

        _userOrg.clear();
        _userOrg = response;
        emit(UserOrgSuccess(userOrg: _userOrg));
      } catch (e) {
        emit(UserOrgError(error: e));
      }
    });
  }
}
