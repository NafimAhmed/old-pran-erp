import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class BatchCompDtlDataEvent {}

final class GetBatchCompDtlData extends BatchCompDtlDataEvent {
  final String userId;
  final String batchId;
  final int listIndex;
  GetBatchCompDtlData(
      {required this.userId, required this.batchId, required this.listIndex});
}

@immutable
sealed class BatchCompDtlDataState {}

final class BatchCompDtlDataInitial extends BatchCompDtlDataState {}

final class BatchCompDtlDataLoading extends BatchCompDtlDataState {
  final int listIndex;

  BatchCompDtlDataLoading({required this.listIndex});
}

final class BatchCompDtlDataSuccess extends BatchCompDtlDataState {
  final List<SkuDtlData> skuDtlDataList;

  BatchCompDtlDataSuccess({required this.skuDtlDataList});
}

final class BatchCompDtlDataError extends BatchCompDtlDataState {
  final Object error;

  BatchCompDtlDataError({required this.error});
}

class BatchCompDtlDataBloc
    extends Bloc<BatchCompDtlDataEvent, BatchCompDtlDataState> {
  final DataService _dataService;
  BatchCompDtlDataBloc(this._dataService) : super(BatchCompDtlDataInitial()) {
    on<GetBatchCompDtlData>((event, emit) async {
      emit(BatchCompDtlDataLoading(listIndex: event.listIndex));
      try {
        var response = await _dataService.getBatchCompDtlData(
            userId: event.userId, batchid: event.batchId);
        emit(BatchCompDtlDataSuccess(skuDtlDataList: response));
      } catch (e) {
        emit(BatchCompDtlDataError(error: e));
      }
    });
  }
}
