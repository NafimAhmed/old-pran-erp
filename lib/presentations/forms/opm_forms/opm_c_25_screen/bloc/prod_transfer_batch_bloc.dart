import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ProdTransferBatchEvent {}

final class ProdTransferBatch extends ProdTransferBatchEvent {
  final String pTrnid;
  final String userid;
  final String rackId;

  ProdTransferBatch({
    required this.pTrnid,
    required this.userid,
    required this.rackId,
  });
}

@immutable
sealed class ProdTransferBatchState {}

final class ProdTransferBatchInitial extends ProdTransferBatchState {}

final class ProdTransferBatchLoading extends ProdTransferBatchState {}

final class ProdTransferBatchSuccess extends ProdTransferBatchState {}

final class ProdTransferBatchError extends ProdTransferBatchState {
  final Object error;

  ProdTransferBatchError({required this.error});
}

class ProdTransferBatchBloc
    extends Bloc<ProdTransferBatchEvent, ProdTransferBatchState> {
  final DataRepo _dataService;
  ProdTransferBatchBloc(this._dataService) : super(ProdTransferBatchInitial()) {
    on<ProdTransferBatch>((event, emit) async {
      emit(ProdTransferBatchLoading());
      try {
        await _dataService.prodTransfer(
          pTrnId: event.pTrnid,
          rackId: event.rackId,
          userId: event.userid,
        );
        emit(ProdTransferBatchSuccess());
      } catch (error) {
        emit(ProdTransferBatchError(error: error));
      }
    });
  }
}
