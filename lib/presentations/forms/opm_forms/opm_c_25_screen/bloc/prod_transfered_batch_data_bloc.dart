import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ProdTransferedBatchDataEvent {}

final class ProdTransferBatchDataGet extends ProdTransferedBatchDataEvent {
  final String userId;

  ProdTransferBatchDataGet({required this.userId});
}

final class ProdTransferBatchDataDelete extends ProdTransferedBatchDataEvent {
  final int trnsfid;
  final String userId;
  ProdTransferBatchDataDelete({required this.trnsfid, required this.userId});
}

@immutable
sealed class ProdTransferedBatchDataState {}

final class ProdTransferedBatchDataInitial
    extends ProdTransferedBatchDataState {}

final class ProdTransferedBatchDataLoading
    extends ProdTransferedBatchDataState {}

final class ProdTransferedBatchDataSuccess
    extends ProdTransferedBatchDataState {
  final List<TransferBatchData> transferBatchDataList;

  ProdTransferedBatchDataSuccess({required this.transferBatchDataList});
}

final class ProdTransferedBatchDataError extends ProdTransferedBatchDataState {
  final Object error;

  ProdTransferedBatchDataError({required this.error});
}

class ProdTransferedBatchDataBloc
    extends Bloc<ProdTransferedBatchDataEvent, ProdTransferedBatchDataState> {
  final DataService _dataService;
  ProdTransferedBatchDataBloc(this._dataService)
      : super(ProdTransferedBatchDataInitial()) {
    on<ProdTransferBatchDataGet>((event, emit) async {
      emit(ProdTransferedBatchDataLoading());
      try {
        var response =
            await _dataService.getTransferBatchData(userId: event.userId);
        emit(ProdTransferedBatchDataSuccess(transferBatchDataList: response));
      } catch (error) {
        emit(ProdTransferedBatchDataError(error: error));
      }
    });
    on<ProdTransferBatchDataDelete>((event, emit) async {
      emit(ProdTransferedBatchDataLoading());
      try {
        await _dataService.tranferDelete(
          trnsfid: event.trnsfid,
          userId: event.userId,
        );
        var batchData =
            await _dataService.getTransferBatchData(userId: event.userId);
        emit(ProdTransferedBatchDataSuccess(transferBatchDataList: batchData));
      } catch (error) {
        emit(ProdTransferedBatchDataError(error: error));
      }
    });
  }
}
