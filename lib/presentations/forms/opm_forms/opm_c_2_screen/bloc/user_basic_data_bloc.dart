import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class UserBasicDataEvent {}

final class UserBasicDataGet extends UserBasicDataEvent {
  final String userId;
  final String orgid;
  UserBasicDataGet({
    required this.userId,
    required this.orgid,
  });
}

@immutable
sealed class UserBasicDataState {}

final class UserBasicDataInitial extends UserBasicDataState {}

final class UserBasicDataLoading extends UserBasicDataState {}

final class UserBasicDataSuccess extends UserBasicDataState {
  final UserBasicDataResponse userBasicData;

  UserBasicDataSuccess({required this.userBasicData});
}

final class UserBasicDataError extends UserBasicDataState {
  final Object error;

  UserBasicDataError({required this.error});
}

class UserBasicDataBloc extends Bloc<UserBasicDataEvent, UserBasicDataState> {
  final DataService _dataService;
  UserBasicDataBloc(this._dataService) : super(UserBasicDataInitial()) {
    on<UserBasicDataGet>((event, emit) async {
      emit(UserBasicDataLoading());
      try {
        var response = await _dataService.getUserBasicData(
          userid: event.userId,
          orgid: event.orgid,
        );

        emit(
          UserBasicDataSuccess(
            userBasicData: response,
          ),
        );
      } catch (e) {
        emit(UserBasicDataError(error: e));
      }
    });
  }
}
