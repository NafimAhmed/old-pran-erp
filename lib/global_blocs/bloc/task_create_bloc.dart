import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/core/data_class/main_task.dart';

@immutable
sealed class TaskCreateEvent {}

final class TaskCreate extends TaskCreateEvent {
  final String userId;
  final MainTask mainTask;
  TaskCreate({
    required this.userId,
    required this.mainTask,
  });
}

@immutable
sealed class TaskCreateState {}

final class TaskCreateInitial extends TaskCreateState {}

final class TaskCreateLoading extends TaskCreateState {}

final class TaskCreateSuccess extends TaskCreateState {
  TaskCreateSuccess();
}

final class TaskCreateError extends TaskCreateState {
  final Object error;

  TaskCreateError({required this.error});
}

class TaskCreateBloc extends Bloc<TaskCreateEvent, TaskCreateState> {
  final DataRepo _dataService;

  TaskCreateBloc(this._dataService) : super(TaskCreateInitial()) {
    on<TaskCreate>((event, emit) async {
      emit(TaskCreateLoading());
      try {
        await _dataService.createMainTask(
          userId: event.userId,
          mainTask: event.mainTask,
        );

        emit(TaskCreateSuccess());
      } catch (e) {
        emit(TaskCreateError(error: e));
      }
    });
  }
}
