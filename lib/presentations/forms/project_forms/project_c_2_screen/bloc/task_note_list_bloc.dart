import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_note_list_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class TaskNoteListEvent {}

final class TaskNoteListGet extends TaskNoteListEvent {
  final String userId;
  final int taskId;

  TaskNoteListGet({required this.userId, required this.taskId});
}

@immutable
sealed class TaskNoteListState {}

final class TaskNoteListInitial extends TaskNoteListState {}

final class TaskNoteListLoading extends TaskNoteListState {}

final class TaskNoteListSuccess extends TaskNoteListState {
  final List<TaskNote> taskNoteList;

  TaskNoteListSuccess({required this.taskNoteList});
}

final class TaskNoteListError extends TaskNoteListState {
  final Object error;

  TaskNoteListError({required this.error});
}

class TaskNoteListBloc extends Bloc<TaskNoteListEvent, TaskNoteListState> {
  final DataRepo _dataService;
  TaskNoteListBloc(this._dataService) : super(TaskNoteListInitial()) {
    on<TaskNoteListGet>((event, emit) async {
      emit(TaskNoteListLoading());
      try {
        var response = await _dataService.getTaskNoteList(
            userId: event.userId, taskId: event.taskId);
        emit(TaskNoteListSuccess(taskNoteList: response));
      } catch (e) {
        emit(TaskNoteListError(error: e));
      }
    });
  }
}
