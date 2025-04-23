import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class MOReqSaveEvent {}

final class MOReqSave extends MOReqSaveEvent {
  final String userId;

  final String taskStatus;
  final int taskId;
  MOReqSave({
    required this.userId,
    required this.taskStatus,
    required this.taskId,
  });
}

@immutable
sealed class MOReqSaveState {}

final class MOReqSaveInitial extends MOReqSaveState {}

final class MOReqSaveLoading extends MOReqSaveState {}

final class MOReqSaveSuccess extends MOReqSaveState {
  MOReqSaveSuccess();
}

final class MOReqSaveError extends MOReqSaveState {
  final Object error;

  MOReqSaveError({required this.error});
}

class MOReqSaveBloc extends Bloc<MOReqSaveEvent, MOReqSaveState> {
  final DataService _dataService;
  MOReqSaveBloc(this._dataService) : super(MOReqSaveInitial()) {
    on<MOReqSave>((event, emit) async {
      emit(MOReqSaveLoading());
      try {
        await _dataService.moReqSave(
            taskId: event.taskId, taskStatus: event.taskStatus);
        emit(MOReqSaveSuccess());
      } catch (e) {
        emit(MOReqSaveError(error: e));
      }
    });
  }
}
