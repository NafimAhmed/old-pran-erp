import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class TaskAssignEvent {}

final class TaskAssign extends TaskAssignEvent {
  final String userId;

  final String assigneeId;
  final String department;
  final String taskId;

  TaskAssign({
    required this.userId,
    required this.assigneeId,
    required this.department,
    required this.taskId,
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
  final DataRepo _dataService;

  TaskAssignBloc(this._dataService) : super(TaskAssignInitial()) {
    on<TaskAssign>((event, emit) async {
      emit(TaskAssignLoading());
      try {
        await _dataService.taskAssign(
            userId: event.userId,
            assigneeId: event.assigneeId,
            department: event.department,
            taskId: event.taskId);

        emit(TaskAssignSuccess());
      } catch (e) {
        emit(TaskAssignError(error: e));
      }
    });
  }
}
