import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TaskAssignEvent {}

final class TaskAssign extends TaskAssignEvent {
  final int jobId;
  final int? pId;
  final String tsknm;
  final String tskdesc;
  final String tskasgne;
  final String startDate;
  final String endDate;

  TaskAssign({
    required this.jobId,
    required this.pId,
    required this.tsknm,
    required this.tskdesc,
    required this.tskasgne,
    required this.startDate,
    required this.endDate,
  });
}

@immutable
sealed class TaskAssignState {}

final class TaskAssignInitial extends TaskAssignState {}

final class TaskAssignLoading extends TaskAssignState {}

final class TaskAssignSuccess extends TaskAssignState {
  TaskAssignSuccess();
}

final class TaskAssignError extends TaskAssignState {
  final Object error;

  TaskAssignError({required this.error});
}

class TaskAssignBloc extends Bloc<TaskAssignEvent, TaskAssignState> {
  final DataService _dataService;

  TaskAssignBloc(this._dataService) : super(TaskAssignInitial()) {
    on<TaskAssign>((event, emit) async {
      emit(TaskAssignLoading());
      try {
        await _dataService.taskAssign(
          jobId: event.jobId,
          pId: event.pId,
          tsknm: event.tsknm,
          tskdesc: event.tskdesc,
          tskasgne: event.tskasgne,
          startDate: event.startDate,
          endDate: event.endDate,
        );

        emit(TaskAssignSuccess());
      } catch (e) {
        emit(TaskAssignError(error: e));
      }
    });
  }
}
