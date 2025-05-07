import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ExAutoTaskSaveEvent {}

final class ExAutoTaskSave extends ExAutoTaskSaveEvent {
  final String vUser;

  final String vStatus;

  final String vNote;

  final int taskId;

  final String vCustomerPo;

  final String vJobOrderNo;

  final String vFdate;

  final String vTdate;

  final String vAdate;

  ExAutoTaskSave({
    required this.vUser,
    required this.vStatus,
    required this.vNote,
    required this.taskId,
    required this.vCustomerPo,
    required this.vJobOrderNo,
    required this.vFdate,
    required this.vTdate,
    required this.vAdate,
  });
}

@immutable
sealed class ExAutoTaskSaveState {}

final class ExAutoTaskSaveInitial extends ExAutoTaskSaveState {}

final class ExAutoTaskSaveLoading extends ExAutoTaskSaveState {}

final class ExAutoTaskSaveSuccess extends ExAutoTaskSaveState {
  ExAutoTaskSaveSuccess();
}

final class ExAutoTaskSaveError extends ExAutoTaskSaveState {
  final Object error;

  ExAutoTaskSaveError({required this.error});
}

class ExAutoTaskSaveBloc
    extends Bloc<ExAutoTaskSaveEvent, ExAutoTaskSaveState> {
  final DataRepo _dataService;

  ExAutoTaskSaveBloc(this._dataService) : super(ExAutoTaskSaveInitial()) {
    on<ExAutoTaskSave>((event, emit) async {
      emit(ExAutoTaskSaveLoading());

      try {
        await _dataService.saveTaskStatusToExAuto(
          vUser: event.vUser,
          vStatus: event.vStatus,
          vNote: event.vNote,
          taskId: event.taskId,
          vCustomerPo: event.vCustomerPo,
          vJobOrderNo: event.vJobOrderNo,
          vFdate: event.vFdate,
          vTdate: event.vTdate,
          vAdate: event.vAdate,
        );

        emit(ExAutoTaskSaveSuccess());
      } catch (e) {
        emit(ExAutoTaskSaveError(error: e));
      }
    });
  }
}
