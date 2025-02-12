import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/po_job_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class PoJobListEvent {}

final class PoJobListGet extends PoJobListEvent {
  final String userId;
  final String jobpono;
  PoJobListGet({
    required this.userId,
    required this.jobpono,
  });
}

final class PoJobListReset extends PoJobListEvent {
  PoJobListReset();
}

@immutable
sealed class PoJobListState {}

final class PoJobListInitial extends PoJobListState {}

final class PoJobListLoading extends PoJobListState {}

final class PoJobListSuccess extends PoJobListState {
  final List<PoJob> poJobList;
  PoJobListSuccess({required this.poJobList});
}

final class PoJobListError extends PoJobListState {
  final Object error;

  PoJobListError({required this.error});
}

class PoJobListBloc extends Bloc<PoJobListEvent, PoJobListState> {
  final DataService _dataService;

  PoJobListBloc(this._dataService) : super(PoJobListInitial()) {
    on<PoJobListGet>((event, emit) async {
      emit(PoJobListLoading());
      try {
        var response = await _dataService.getPoJobList(
          userId: event.userId,
          jobpono: event.jobpono,
        );

        emit(PoJobListSuccess(poJobList: response));
      } catch (e) {
        emit(PoJobListError(error: e));
      }
    });
    on<PoJobListReset>((event, emit) async {
      emit(PoJobListInitial());
    });
  }
}
