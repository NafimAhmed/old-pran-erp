import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TaskListEvent {}

final class TaskListGet extends TaskListEvent {
  final String userId;
  final String searchValue;
  TaskListGet({
    required this.userId,
    required this.searchValue,
  });
}

final class RemoveTask extends TaskListEvent {
  RemoveTask({required this.index});
  final int index;
}

final class TaskListFilter extends TaskListEvent {
  final String searchValue;

  TaskListFilter({required this.searchValue});
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
    on<TaskListGet>((event, emit) async {
      emit(TaskListLoading());
      try {
        var response = await _dataService.getTaskList(userId: event.userId);
        _dataList = response;
        if (event.searchValue.isNotEmpty) {
          emit(TaskListSuccess(taskList: _filterList(event.searchValue)));
        } else {
          emit(
            TaskListSuccess(taskList: _dataList),
          );
        }
      } catch (e) {
        emit(TaskListError(error: e));
      }
    });
    on<RemoveTask>((event, emit) async {
      _dataList.removeAt(event.index);
      emit(
        TaskListSuccess(taskList: _dataList),
      );
    });
    on<TaskListFilter>((event, emit) async {
      emit(TaskListLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          emit(TaskListSuccess(taskList: _filterList(event.searchValue)));
        } else {
          emit(TaskListSuccess(taskList: _dataList));
        }
      } catch (error) {
        emit(TaskListError(error: error));
      }
    });
  }
  List<Task> _filterList(String filerText) {
    var filterlist = _dataList.where(
      (element) {
        return element.jobOrderNo
                ?.toLowerCase()
                .contains(filerText.toLowerCase()) ??
            false;
      },
    ).toList();
    return filterlist;
  }
}
