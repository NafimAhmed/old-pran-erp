import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class AddTaskNoteEvent {}

final class AddTaskNote extends AddTaskNoteEvent {
  final String userId;

  final String taskNote;
  final int taskId;
  AddTaskNote({
    required this.userId,
    required this.taskNote,
    required this.taskId,
  });
}

@immutable
sealed class AddTaskNoteState {}

final class AddTaskNoteInitial extends AddTaskNoteState {}

final class AddTaskNoteLoading extends AddTaskNoteState {}

final class AddTaskNoteSuccess extends AddTaskNoteState {
  AddTaskNoteSuccess();
}

final class AddTaskNoteError extends AddTaskNoteState {
  final Object error;

  AddTaskNoteError({required this.error});
}

class AddTaskNoteBloc extends Bloc<AddTaskNoteEvent, AddTaskNoteState> {
  final DataService _dataService;
  AddTaskNoteBloc(this._dataService) : super(AddTaskNoteInitial()) {
    on<AddTaskNote>((event, emit) async {
      emit(AddTaskNoteLoading());
      try {
        await _dataService.addTaskNote(
            userId: event.userId,
            tasknote: event.taskNote,
            taskId: event.taskId);
        emit(AddTaskNoteSuccess());
      } catch (e) {
        emit(AddTaskNoteError(error: e));
      }
    });
  }
}
