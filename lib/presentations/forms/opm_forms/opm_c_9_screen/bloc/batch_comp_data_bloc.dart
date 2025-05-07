import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class BatchCompDataEvent {}

final class GetBatchCompData extends BatchCompDataEvent {
  final String userId;

  GetBatchCompData({required this.userId});
}

@immutable
sealed class BatchCompDataState {}

final class BatchCompDataInitial extends BatchCompDataState {}

final class BatchCompDataLoading extends BatchCompDataState {}

final class BatchCompDataSuccess extends BatchCompDataState {
  final List<BatchCompData> batchCompDataList;

  BatchCompDataSuccess({required this.batchCompDataList});
}

final class BatchCompDataError extends BatchCompDataState {
  final Object error;

  BatchCompDataError({required this.error});
}

class BatchCompDataBloc extends Bloc<BatchCompDataEvent, BatchCompDataState> {
  final DataRepo _dataService;
  BatchCompDataBloc(this._dataService) : super(BatchCompDataInitial()) {
    on<GetBatchCompData>((event, emit) async {
      emit(BatchCompDataLoading());
      try {
        var response =
            await _dataService.getBatchCompData(userId: event.userId);
        emit(BatchCompDataSuccess(batchCompDataList: response));
      } catch (e) {
        emit(BatchCompDataError(error: e));
      }
    });
  }
}
