import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_shift_change_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class BatchShiftChangeDataEvent {}

final class GetBatch extends BatchShiftChangeDataEvent {
  final String userId;
  final int orgId;
  final String batchNo;

  GetBatch({required this.userId, required this.orgId, required this.batchNo});
}

@immutable
sealed class BatchShiftChangeDataState {}

final class BatchShiftChangeDataInitial extends BatchShiftChangeDataState {}

final class BatchShiftChangeDataLoading extends BatchShiftChangeDataState {}

final class BatchShiftChangeDataSuccess extends BatchShiftChangeDataState {
  final BatchShiftChangeResponse batchShiftChangedata;

  BatchShiftChangeDataSuccess({required this.batchShiftChangedata});
}

final class BatchShiftChangeDataError extends BatchShiftChangeDataState {
  final Object error;

  BatchShiftChangeDataError({required this.error});
}

class BatchShiftChangeDataBloc
    extends Bloc<BatchShiftChangeDataEvent, BatchShiftChangeDataState> {
  final DataRepo _dataService;
  BatchShiftChangeDataBloc(this._dataService)
      : super(BatchShiftChangeDataInitial()) {
    on<GetBatch>((event, emit) async {
      emit(BatchShiftChangeDataLoading());
      try {
        var response = await _dataService.getBatchShiftData(
          userId: event.userId,
          orgId: event.orgId,
          batchNo: event.batchNo,
        );
        emit(BatchShiftChangeDataSuccess(batchShiftChangedata: response));
      } catch (e) {
        emit(BatchShiftChangeDataError(error: e));
      }
    });
  }
}
