import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class BatchCloseDataEvent {}

final class GetBatchCloseData extends BatchCloseDataEvent {
  final String userId;

  GetBatchCloseData({required this.userId});
}

@immutable
sealed class BatchCloseDataState {}

final class BatchCloseDataInitial extends BatchCloseDataState {}

final class BatchCloseDataLoading extends BatchCloseDataState {}

final class BatchCloseDataSuccess extends BatchCloseDataState {
  final List<BatchCloseData> batchCloseDataList;

  BatchCloseDataSuccess({required this.batchCloseDataList});
}

final class BatchCloseDataError extends BatchCloseDataState {
  final Object error;

  BatchCloseDataError({required this.error});
}

class BatchCloseDataBloc
    extends Bloc<BatchCloseDataEvent, BatchCloseDataState> {
  final DataRepo _dataService;
  BatchCloseDataBloc(this._dataService) : super(BatchCloseDataInitial()) {
    on<GetBatchCloseData>((event, emit) async {
      emit(BatchCloseDataLoading());
      try {
        var response =
            await _dataService.getBatchCloseData(userId: event.userId);
        emit(BatchCloseDataSuccess(batchCloseDataList: response));
      } catch (e) {
        emit(BatchCloseDataError(error: e));
      }
    });
  }
}
