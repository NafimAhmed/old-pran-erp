import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

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
  final String filterValue;
  TaskInfoFilter({required this.searchValue, this.filterValue = "All"});
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
  final List<TaskInfo> taskInfoFilterList;
  final List<TaskInfo> taskInfoList;
  TaskInfoSuccess(
      {required this.taskInfoFilterList, required this.taskInfoList});
}

final class TaskInfoError extends TaskInfoState {
  final Object error;

  TaskInfoError({required this.error});
}

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  final DataRepo _dataService;
  List<TaskInfo> _taskInfoList = [];
  TaskInfoBloc(this._dataService) : super(TaskInfoInitial()) {
    on<TaskInfoGet>((event, emit) async {
      emit(TaskInfoLoading());
      try {
        var response = await _dataService.getTaskInfoList(
          userid: event.userId,
        );
        _taskInfoList = response;

        emit(
          TaskInfoSuccess(
            taskInfoList: _taskInfoList,
            taskInfoFilterList: _filterList(
              event.searchValue,
              "All",
            ),
          ),
        );
      } catch (e) {
        emit(TaskInfoError(error: e));
      }
    });
    on<RemoveTaskInfo>((event, emit) async {
      emit(TaskInfoLoading());
      try {
        _taskInfoList.removeAt(event.index);
        emit(TaskInfoSuccess(
            taskInfoList: _taskInfoList, taskInfoFilterList: _taskInfoList));
      } catch (e) {
        emit(TaskInfoError(error: e));
      }
    });
    on<TaskInfoFilter>((event, emit) async {
      //emit(TaskInfoLoading());
      try {
        emit(TaskInfoSuccess(
            taskInfoList: _taskInfoList,
            taskInfoFilterList:
                _filterList(event.searchValue, event.filterValue)));
      } catch (error) {
        emit(TaskInfoError(error: error));
      }
    });
  }
  List<TaskInfo> _filterList(String filerText, String filterValue) {
    if (filterValue != "All") {
      var filterlist = _taskInfoList.where(
        (element) {
          return (element.parentTaskName
                  ?.toLowerCase()
                  .contains(filterValue.toLowerCase()) ??
              false);
        },
      ).toList();
      if (filerText.isNotEmpty) {
        filterlist = filterlist.where(
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
      }

      return filterlist;
    } else {
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
}
