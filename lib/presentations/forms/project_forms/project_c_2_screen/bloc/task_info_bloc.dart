import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TaskInfoEvent {}

final class TaskInfoGet extends TaskInfoEvent {
  final String userId;
  final String searchValue;
  TaskInfoGet({
    required this.userId,
    required this.searchValue,
  });
}

final class TaskInfoFilter extends TaskInfoEvent {
  final String searchValue;

  TaskInfoFilter({required this.searchValue});
}

final class RemoveTaskInfo extends TaskInfoEvent {
  final int index;

  RemoveTaskInfo({required this.index});
}

@immutable
sealed class TaskInfoState {}

final class TaskInfoInitial extends TaskInfoState {}

final class TaskInfoLoading extends TaskInfoState {}

final class TaskInfoSuccess extends TaskInfoState {
  final List<TaskInfo> taskInfoList;

  TaskInfoSuccess({required this.taskInfoList});
}

final class TaskInfoError extends TaskInfoState {
  final Object error;

  TaskInfoError({required this.error});
}

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  final DataService _dataService;
  List<TaskInfo> _taskInfoList = [];
  TaskInfoBloc(this._dataService) : super(TaskInfoInitial()) {
    on<TaskInfoGet>((event, emit) async {
      emit(TaskInfoLoading());
      try {
        var response = await _dataService.getTaskInfoList(
          userid: event.userId,
        );
        _taskInfoList = response;

        if (event.searchValue.isNotEmpty) {
          emit(TaskInfoSuccess(taskInfoList: _filterList(event.searchValue)));
        } else {
          emit(
            TaskInfoSuccess(taskInfoList: _taskInfoList),
          );
        }
      } catch (e) {
        emit(TaskInfoError(error: e));
      }
    });
    on<RemoveTaskInfo>((event, emit) async {
      emit(TaskInfoLoading());
      try {
        _taskInfoList.removeAt(event.index);
        emit(TaskInfoSuccess(taskInfoList: _taskInfoList));
      } catch (e) {
        emit(TaskInfoError(error: e));
      }
    });
    on<TaskInfoFilter>((event, emit) async {
      emit(TaskInfoLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          emit(TaskInfoSuccess(taskInfoList: _filterList(event.searchValue)));
        } else {
          emit(TaskInfoSuccess(taskInfoList: _taskInfoList));
        }
      } catch (error) {
        emit(TaskInfoError(error: error));
      }
    });
  }
  List<TaskInfo> _filterList(String filerText) {
    var filterlist = _taskInfoList.where(
      (element) {
        return (element.jobOrderNo
                    ?.toLowerCase()
                    .contains(filerText.toLowerCase()) ??
                false) ||
            (element.taskName
                    ?.toLowerCase()
                    .contains(filerText.toLowerCase()) ??
                false);
      },
    ).toList();
    return filterlist;
  }
}
