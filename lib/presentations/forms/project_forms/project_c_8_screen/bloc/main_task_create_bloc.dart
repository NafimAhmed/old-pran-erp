import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/presentations/forms/project_forms/project_c_8_screen/data_class/main_task.dart';

@immutable
sealed class MainTaskCreateEvent {}

final class MainTaskCreate extends MainTaskCreateEvent {
  final String userId;
  final MainTask mainTask;
  MainTaskCreate({
    required this.userId,
    required this.mainTask,
  });
}

@immutable
sealed class MainTaskCreateState {}

final class MainTaskCreateInitial extends MainTaskCreateState {}

final class MainTaskCreateLoading extends MainTaskCreateState {}

final class MainTaskCreateSuccess extends MainTaskCreateState {
  MainTaskCreateSuccess();
}

final class MainTaskCreateError extends MainTaskCreateState {
  final Object error;

  MainTaskCreateError({required this.error});
}

class MainTaskCreateBloc
    extends Bloc<MainTaskCreateEvent, MainTaskCreateState> {
  final DataService _dataService;

  MainTaskCreateBloc(this._dataService) : super(MainTaskCreateInitial()) {
    on<MainTaskCreate>((event, emit) async {
      emit(MainTaskCreateLoading());
      try {
        await _dataService.createMainTask(
          userId: event.userId,
          mainTask: event.mainTask,
        );

        emit(MainTaskCreateSuccess());
      } catch (e) {
        emit(MainTaskCreateError(error: e));
      }
    });
  }
}
