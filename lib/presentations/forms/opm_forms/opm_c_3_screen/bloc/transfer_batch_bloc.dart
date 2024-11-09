import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TransferBatchEvent {}

final class TransferBatch extends TransferBatchEvent {
  final String pTrnid;
  final String userid;
  final String rackId;
  final String rqty;
  final String split;

  TransferBatch(
      {required this.pTrnid,
      required this.userid,
      required this.rackId,
      required this.rqty,
      required this.split});
}

@immutable
sealed class TransferBatchState {}

final class TransferBatchInitial extends TransferBatchState {}

final class TransferBatchLoading extends TransferBatchState {
  final String splitFlag;

  TransferBatchLoading({required this.splitFlag});
}

final class TransferBatchSuccess extends TransferBatchState {}

final class TransferBatchError extends TransferBatchState {
  final Object error;

  TransferBatchError({required this.error});
}

class TransferBatchBloc extends Bloc<TransferBatchEvent, TransferBatchState> {
  final DataService _dataService;
  TransferBatchBloc(this._dataService) : super(TransferBatchInitial()) {
    on<TransferBatch>((event, emit) async {
      emit(TransferBatchLoading(splitFlag: event.split));
      try {
        var response = await _dataService.transferBatch(
          pTrnid: event.pTrnid,
          userid: event.userid,
          rackId: event.rackId,
          rqty: event.rqty,
          split: event.split,
        );
        emit(TransferBatchSuccess());
      } catch (error) {
        emit(TransferBatchError(error: error));
      }
    });
  }
}
