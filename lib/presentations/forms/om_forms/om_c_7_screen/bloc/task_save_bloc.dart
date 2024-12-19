import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TaskSaveEvent {}

final class TaskSave extends TaskSaveEvent {
  final String userId;

  final String taskStatus;
  final int taskId;
  TaskSave({
    required this.userId,
    required this.taskStatus,
    required this.taskId,
  });
}

@immutable
sealed class TaskSaveState {}

final class TaskSaveInitial extends TaskSaveState {}

final class TaskSaveLoading extends TaskSaveState {}

final class TaskSaveSuccess extends TaskSaveState {
  TaskSaveSuccess();
}

final class TaskSaveError extends TaskSaveState {
  final Object error;

  TaskSaveError({required this.error});
}

class TaskSaveBloc extends Bloc<TaskSaveEvent, TaskSaveState> {
  final DataService _dataService;
  TaskSaveBloc(this._dataService) : super(TaskSaveInitial()) {
    on<TaskSave>((event, emit) async {
      emit(TaskSaveLoading());
      try {
        await _dataService.saveTaskStatus(
            userid: event.userId,
            taskStatus: event.taskStatus,
            taskId: event.taskId);
        emit(TaskSaveSuccess());
      } catch (e) {
        emit(TaskSaveError(error: e));
      }
    });
  }
}
