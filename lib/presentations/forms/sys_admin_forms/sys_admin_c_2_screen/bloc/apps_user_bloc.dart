import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class AppsUserEvent {}

final class GetAppsUserEvent extends AppsUserEvent {}

@immutable
sealed class AppsUserState {}

final class AppsUserInitial extends AppsUserState {}

final class AppsUserLoading extends AppsUserState {}

final class AppsUserSuccess extends AppsUserState {
  final List<AppsUserData> appsDataList;

  AppsUserSuccess({required this.appsDataList});
}

final class AppsUserError extends AppsUserState {
  final Object error;

  AppsUserError({required this.error});
}

class AppsUserBloc extends Bloc<AppsUserEvent, AppsUserState> {
  final DataRepo _dataService;
  AppsUserBloc(this._dataService) : super(AppsUserInitial()) {
    on<GetAppsUserEvent>((event, emit) async {
      emit(AppsUserLoading());
      try {
        var response = await _dataService.getAppsUser();
        emit(AppsUserSuccess(appsDataList: response));
      } catch (e) {
        emit(AppsUserError(error: e));
      }
    });
  }
}
