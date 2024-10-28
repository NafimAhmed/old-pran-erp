import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TransferedBatchDataEvent {}

final class TransferBatchDataGet extends TransferedBatchDataEvent {}

final class TransferBatchDataDelete extends TransferedBatchDataEvent {
  final int trnsfid;

  TransferBatchDataDelete({required this.trnsfid});
}

@immutable
sealed class TransferedBatchDataState {}

final class TransferedBatchDataInitial extends TransferedBatchDataState {}

final class TransferedBatchDataLoading extends TransferedBatchDataState {}

final class TransferedBatchDataSuccess extends TransferedBatchDataState {
  final List<TransferBatchData> transferBatchDataList;

  TransferedBatchDataSuccess({required this.transferBatchDataList});
}

final class TransferedBatchDataError extends TransferedBatchDataState {
  final Object error;

  TransferedBatchDataError({required this.error});
}

class TransferedBatchDataBloc
    extends Bloc<TransferedBatchDataEvent, TransferedBatchDataState> {
  final DataService _dataService;
  TransferedBatchDataBloc(this._dataService)
      : super(TransferedBatchDataInitial()) {
    on<TransferBatchDataGet>((event, emit) async {
      emit(TransferedBatchDataLoading());
      try {
        var response = await _dataService.getTransferBatchData();
        emit(TransferedBatchDataSuccess(transferBatchDataList: response));
      } catch (error) {
        emit(TransferedBatchDataError(error: error));
      }
    });
    on<TransferBatchDataDelete>((event, emit) async {
      emit(TransferedBatchDataLoading());
      try {
        await _dataService.tranferDelete(trnsfid: event.trnsfid);
        var batchData = await _dataService.getTransferBatchData();
        emit(TransferedBatchDataSuccess(transferBatchDataList: batchData));
      } catch (error) {
        emit(TransferedBatchDataError(error: error));
      }
    });
  }
}
