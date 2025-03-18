import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class PurchaseReqDtlUpdtEvent {}

final class PurchaseReqDtlUpdate extends PurchaseReqDtlUpdtEvent {
  final int headerId;
  final int itemId;
  final int qty;
  PurchaseReqDtlUpdate({
    required this.headerId,
    required this.itemId,
    required this.qty,
  });
}

@immutable
sealed class PurchaseReqDtlUpdtState {}

final class PurchaseReqDtlUpdtInitial extends PurchaseReqDtlUpdtState {}

final class PurchaseReqDtlUpdtLoading extends PurchaseReqDtlUpdtState {}

final class PurchaseReqDtlUpdtSuccess extends PurchaseReqDtlUpdtState {
  final GenericResponse response;

  PurchaseReqDtlUpdtSuccess({required this.response});
}

final class PurchaseReqDtlUpdtError extends PurchaseReqDtlUpdtState {
  final Object error;

  PurchaseReqDtlUpdtError({required this.error});
}

class PurchaseReqDtlUpdtBloc
    extends Bloc<PurchaseReqDtlUpdtEvent, PurchaseReqDtlUpdtState> {
  final DataService _dataService;
  PurchaseReqDtlUpdtBloc(this._dataService)
      : super(PurchaseReqDtlUpdtInitial()) {
    on<PurchaseReqDtlUpdate>((event, emit) async {
      emit(PurchaseReqDtlUpdtLoading());
      try {
        var response = await _dataService.updatePurReqDtl(
          headerId: event.headerId,
          itemId: event.itemId,
          qty: event.qty,
        );

        emit(PurchaseReqDtlUpdtSuccess(response: response));
      } catch (e) {
        emit(PurchaseReqDtlUpdtError(error: e));
      }
    });
  }
}
