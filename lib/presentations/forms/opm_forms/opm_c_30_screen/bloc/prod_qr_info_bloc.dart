import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ProdQrInfoEvent {}

final class ProdQrInfoSend extends ProdQrInfoEvent {
  final String itemId;
  final String batchId;
  final String qty;
  final String goodQty;
  final String badQty;
  final String machine;

  ProdQrInfoSend({
    required this.itemId,
    required this.batchId,
    required this.qty,
    required this.goodQty,
    required this.badQty,
    required this.machine,
  });
}

@immutable
sealed class ProdQrInfoState {}

final class ProdQrInfoInitial extends ProdQrInfoState {}

final class ProdQrInfoLoading extends ProdQrInfoState {}

final class ProdQrInfoSuccess extends ProdQrInfoState {}

final class ProdQrInfoError extends ProdQrInfoState {
  final Object error;

  ProdQrInfoError({required this.error});
}

class ProdQrInfoBloc extends Bloc<ProdQrInfoEvent, ProdQrInfoState> {
  final DataRepo _dataService;
  ProdQrInfoBloc(this._dataService) : super(ProdQrInfoInitial()) {
    on<ProdQrInfoSend>((event, emit) async {
      emit(ProdQrInfoLoading());
      try {
        await _dataService.sendProdQrInfo(
          event.itemId,
          event.batchId,
          event.qty,
          event.goodQty,
          event.badQty,
          event.machine,
        );
        emit(ProdQrInfoSuccess());
      } catch (e) {
        emit(ProdQrInfoError(error: e));
      }
    });
  }
}
