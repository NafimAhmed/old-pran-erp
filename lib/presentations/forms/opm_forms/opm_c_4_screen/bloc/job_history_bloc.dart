import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class JobHistoryEvent {}

final class JobHistoryGet extends JobHistoryEvent {
  final String userId;
  final String jobNo;
  JobHistoryGet({required this.userId, required this.jobNo});
}

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
  final DataRepo _dataService;
  List<JobHistory> _jobHistoryList = [];
  JobHistoryBloc(this._dataService) : super(JobHistoryInitial()) {
    on<JobHistoryGet>((event, emit) async {
      emit(JobHistoryLoading());
      try {
        var response = await _dataService.getJobHistory(
            userId: event.userId, jobNo: event.jobNo);
        _jobHistoryList.clear();
        _jobHistoryList = response;
        emit(JobHistorySuccess(jobHistoryList: response));
      } catch (error) {
        emit(JobHistoryError(error: error));
      }
    });
  }
}
