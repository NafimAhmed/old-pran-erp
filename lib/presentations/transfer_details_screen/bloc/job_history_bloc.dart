import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JobHistoryEvent {}

final class JobHistoryGet extends JobHistoryEvent {}

@immutable
sealed class JobHistoryState {}

final class JobHistoryInitial extends JobHistoryState {}

final class JobHistoryLoading extends JobHistoryState {}

final class JobHistorySuccess extends JobHistoryState {
  final List<JobHistory> jobHistoryList;

  JobHistorySuccess({required this.jobHistoryList});
}

final class JobHistoryError extends JobHistoryState {
  final Object error;

  JobHistoryError({required this.error});
}

class JobHistoryBloc extends Bloc<JobHistoryEvent, JobHistoryState> {
  final DataService _dataService;
  JobHistoryBloc(this._dataService) : super(JobHistoryInitial()) {
    on<JobHistoryGet>((event, emit) async {
      emit(JobHistoryLoading());
      try {
        var response = await _dataService.getJobHistory();
        emit(JobHistorySuccess(jobHistoryList: response));
      } catch (error) {
        emit(JobHistoryError(error: error));
      }
    });
  }
}
