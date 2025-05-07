import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_info_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class JobOrderInfoEvent {}

final class JobOrderInfoGet extends JobOrderInfoEvent {
  final String userId;
  final String jobOrderno;
  final String itemId;
  JobOrderInfoGet(
      {required this.userId, required this.jobOrderno, required this.itemId});
}

@immutable
sealed class JobOrderInfoState {}

final class JobOrderInfoInitial extends JobOrderInfoState {}

final class JobOrderInfoLoading extends JobOrderInfoState {}

final class JobOrderInfoSuccess extends JobOrderInfoState {
  final List<JobOrderInfo> jobOrderInfoList;

  JobOrderInfoSuccess({required this.jobOrderInfoList});
}

final class JobOrderInfoError extends JobOrderInfoState {
  final Object error;

  JobOrderInfoError({required this.error});
}

class JobOrderInfoBloc extends Bloc<JobOrderInfoEvent, JobOrderInfoState> {
  final DataRepo _dataService;
  JobOrderInfoBloc(this._dataService) : super(JobOrderInfoInitial()) {
    on<JobOrderInfoGet>((event, emit) async {
      emit(JobOrderInfoLoading());
      try {
        var response = await _dataService.getJobOrderInfo(
            userId: event.userId,
            itemId: event.itemId,
            jobOrderNo: event.jobOrderno);
        emit(JobOrderInfoSuccess(jobOrderInfoList: response));
      } catch (error) {
        emit(JobOrderInfoError(error: error));
      }
    });
  }
}
