import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/parent_task_list.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class PrntTaskListEvent {}

final class PrntTaskListGet extends PrntTaskListEvent {
  final String userId;
  final int projectId;
  PrntTaskListGet({
    required this.userId,
    required this.projectId,
  });
}

final class PrntTaskListReset extends PrntTaskListEvent {
  PrntTaskListReset();
}

@immutable
sealed class PrntTaskListState {}

final class PrntTaskListInitial extends PrntTaskListState {}

final class PrntTaskListLoading extends PrntTaskListState {}

final class PrntTaskListSuccess extends PrntTaskListState {
  final List<ParentTask> prntTaskList;
  PrntTaskListSuccess({required this.prntTaskList});
}

final class PrntTaskListError extends PrntTaskListState {
  final Object error;

  PrntTaskListError({required this.error});
}

class PrntTaskListBloc extends Bloc<PrntTaskListEvent, PrntTaskListState> {
  final DataRepo _dataService;

  PrntTaskListBloc(this._dataService) : super(PrntTaskListInitial()) {
    on<PrntTaskListGet>((event, emit) async {
      emit(PrntTaskListLoading());
      try {
        var response = await _dataService.getParentTaskList(
          userId: event.userId,
          projectId: event.projectId,
        );

        emit(PrntTaskListSuccess(prntTaskList: response));
      } catch (e) {
        emit(PrntTaskListError(error: e));
      }
    });
    on<PrntTaskListReset>((event, emit) async {
      emit(PrntTaskListInitial());
    });
  }
}
