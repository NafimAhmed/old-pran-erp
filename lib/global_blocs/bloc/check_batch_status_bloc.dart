import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_status_check_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class CheckBatchStatusEvent {}

final class CheckBatchStatus extends CheckBatchStatusEvent {
  CheckBatchStatus({required this.lotNo, required this.userId});
  final String userId;
  final String lotNo;
}

final class ResetCheckBatchStatus extends CheckBatchStatusEvent {
  ResetCheckBatchStatus();
}

@immutable
sealed class CheckBatchStatusState {}

final class CheckBatchStatusInitial extends CheckBatchStatusState {}

final class CheckBatchStatusLoading extends CheckBatchStatusState {}

final class CheckBatchStatusSuccess extends CheckBatchStatusState {
  final BatchStatusCheck batchStatus;

  CheckBatchStatusSuccess({required this.batchStatus});
}

final class CheckBatchStatusError extends CheckBatchStatusState {
  final Object error;

  CheckBatchStatusError({required this.error});
}

class CheckBatchStatusBloc
    extends Bloc<CheckBatchStatusEvent, CheckBatchStatusState> {
  final DataService _dataService;

  CheckBatchStatusBloc(this._dataService) : super(CheckBatchStatusInitial()) {
    on<CheckBatchStatus>((event, emit) async {
      emit(CheckBatchStatusLoading());
      try {
        var response = await _dataService.getBatchStatus(
          lotNo: event.lotNo,
          userId: event.userId,
        );

        emit(CheckBatchStatusSuccess(batchStatus: response));
      } catch (e) {
        emit(CheckBatchStatusError(error: e));
      }
    });
    on<ResetCheckBatchStatus>((event, emit) async {
      emit(CheckBatchStatusInitial());
    });
  }
}
