import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JobDetailsEvent {}

final class JobDetailsGet extends JobDetailsEvent {
  final String userId;
  final String jobOrderno;
  JobDetailsGet({required this.userId, required this.jobOrderno});
}

@immutable
sealed class JobDetailsState {}

final class JobDetailsInitial extends JobDetailsState {}

final class JobDetailsLoading extends JobDetailsState {}

final class JobDetailsSuccess extends JobDetailsState {
  final List<JobDetail> jobDetailsList;

  JobDetailsSuccess({required this.jobDetailsList});
}

final class JobDetailsError extends JobDetailsState {
  final Object error;

  JobDetailsError({required this.error});
}

class JobDetailsBloc extends Bloc<JobDetailsEvent, JobDetailsState> {
  final DataService _dataService;
  JobDetailsBloc(this._dataService) : super(JobDetailsInitial()) {
    on<JobDetailsGet>((event, emit) async {
      emit(JobDetailsLoading());
      try {
        var response = await _dataService.getJobDtlDrillDw(
            userid: event.userId, jobOrderNo: event.jobOrderno);
        emit(JobDetailsSuccess(jobDetailsList: response));
      } catch (error) {
        emit(JobDetailsError(error: error));
      }
    });
  }
}
