import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JobOrderHistoryEvent {}

final class GetJobOrderHistory extends JobOrderHistoryEvent {
  final String userId;

  GetJobOrderHistory({required this.userId});
}

@immutable
sealed class JobOrderHistoryState {}

final class JobOrderHistoryInitial extends JobOrderHistoryState {}

final class JobOrderHistoryLoading extends JobOrderHistoryState {}

final class JobOrderHistorySuccess extends JobOrderHistoryState {
  final List<JobOrderData> jobOrderDataList;

  JobOrderHistorySuccess({required this.jobOrderDataList});
}

final class JobOrderHistoryError extends JobOrderHistoryState {
  final Object error;

  JobOrderHistoryError({required this.error});
}

class JobOrderHistoryBloc
    extends Bloc<JobOrderHistoryEvent, JobOrderHistoryState> {
  final DataService _dataService;
  JobOrderHistoryBloc(this._dataService) : super(JobOrderHistoryInitial()) {
    on<GetJobOrderHistory>((event, emit) async {
      emit(JobOrderHistoryLoading());
      try {
        var response =
            await _dataService.getJobOrderSumHistory(userId: event.userId);
        emit(JobOrderHistorySuccess(jobOrderDataList: response));
      } catch (e) {
        emit(JobOrderHistoryError(error: e));
      }
    });
  }
}
