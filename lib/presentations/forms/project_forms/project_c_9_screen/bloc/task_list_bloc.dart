import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TaskListEvent {}

final class GetTaskList extends TaskListEvent {
  final String userId;

  GetTaskList({
    required this.userId,
  });
}

final class removeTask extends TaskListEvent {
  removeTask({required this.index});
  final int index;
}

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListLoading extends TaskListState {}

final class TaskListSuccess extends TaskListState {
  TaskListSuccess({required this.taskList});
  final List<Task> taskList;
}

final class TaskListError extends TaskListState {
  final Object error;

  TaskListError({required this.error});
}

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final DataService _dataService;
  List<Task> _dataList = [];
  TaskListBloc(this._dataService) : super(TaskListInitial()) {
    on<GetTaskList>((event, emit) async {
      emit(TaskListLoading());
      try {
        var response = await _dataService.getTaskList(userId: event.userId);
        _dataList = response;
        emit(
          TaskListSuccess(taskList: _dataList),
        );
      } catch (e) {
        emit(TaskListError(error: e));
      }
    });
    on<removeTask>((event, emit) async {
      _dataList.removeAt(event.index);
      emit(
        TaskListSuccess(taskList: _dataList),
      );
    });
  }
}
