import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TransferBatchEvent {}

final class TransferBatch extends TransferBatchEvent {
  final String batchId;
  final String itemId;
  final String rackId;

  TransferBatch(
      {required this.batchId, required this.itemId, required this.rackId});
}

@immutable
sealed class TransferBatchState {}

final class TransferBatchInitial extends TransferBatchState {}

final class TransferBatchLoading extends TransferBatchState {}

final class TransferBatchSuccess extends TransferBatchState {}

final class TransferBatchError extends TransferBatchState {
  final Object error;

  TransferBatchError({required this.error});
}

class TransferBatchBloc extends Bloc<TransferBatchEvent, TransferBatchState> {
  final DataService _dataService;
  TransferBatchBloc(this._dataService) : super(TransferBatchInitial()) {
    on<TransferBatch>((event, emit) async {
      emit(TransferBatchLoading());
      try {
        var response = await _dataService.transferBatch(
            event.batchId, event.itemId, event.rackId);
        emit(TransferBatchSuccess());
      } catch (error) {
        emit(TransferBatchError(error: error));
      }
    });
  }
}
