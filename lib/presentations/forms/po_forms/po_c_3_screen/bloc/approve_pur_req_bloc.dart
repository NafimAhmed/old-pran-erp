import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ApprovePurReqEvent {}

final class ApprovePurReq extends ApprovePurReqEvent {
  final int sl;
  ApprovePurReq({required this.sl});
}

@immutable
sealed class ApprovePurReqState {}

final class ApprovePurReqInitial extends ApprovePurReqState {}

final class ApprovePurReqLoading extends ApprovePurReqState {}

final class ApprovePurReqSuccess extends ApprovePurReqState {
  final GenericResponse response;

  ApprovePurReqSuccess({required this.response});
}

final class ApprovePurReqError extends ApprovePurReqState {
  final Object error;

  ApprovePurReqError({required this.error});
}

class ApprovePurReqBloc extends Bloc<ApprovePurReqEvent, ApprovePurReqState> {
  final DataService _dataService;
  ApprovePurReqBloc(this._dataService) : super(ApprovePurReqInitial()) {
    on<ApprovePurReq>((event, emit) async {
      emit(ApprovePurReqLoading());
      try {
        var response = await _dataService.approvePurReq(sl: event.sl);

        emit(ApprovePurReqSuccess(response: response));
      } catch (e) {
        emit(ApprovePurReqError(error: e));
      }
    });
  }
}
