import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class OrgEvent {}

final class OrgGet extends OrgEvent {}

@immutable
sealed class OrgState {}

final class OrgInitial extends OrgState {}

final class OrgLoading extends OrgState {}

final class OrgSuccess extends OrgState {
  final List<UserOrg> userOrgList;

  OrgSuccess({required this.userOrgList});
}

final class OrgError extends OrgState {
  final Object error;

  OrgError({required this.error});
}

class OrgBloc extends Bloc<OrgEvent, OrgState> {
  final DataRepo _dataService;
  OrgBloc(this._dataService) : super(OrgInitial()) {
    on<OrgGet>((event, emit) async {
      emit(OrgLoading());
      try {
        var response = await _dataService.getOrgs();
        emit(OrgSuccess(userOrgList: response));
      } catch (e) {
        emit(OrgError(error: e));
      }
    });
  }
}
