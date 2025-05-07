import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/purchase_requisition_details_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class PurchaseReqDtlEvent {}

final class PurchaseReqDtlGet extends PurchaseReqDtlEvent {
  final int headerId;
  PurchaseReqDtlGet({required this.headerId});
}

@immutable
sealed class PurchaseReqDtlState {}

final class PurchaseReqDtlInitial extends PurchaseReqDtlState {}

final class PurchaseReqDtlLoading extends PurchaseReqDtlState {}

final class PurchaseReqDtlSuccess extends PurchaseReqDtlState {
  final List<PurchaseRequisitionDetail> purReqDtlList;

  PurchaseReqDtlSuccess({required this.purReqDtlList});
}

final class PurchaseReqDtlError extends PurchaseReqDtlState {
  final Object error;

  PurchaseReqDtlError({required this.error});
}

class PurchaseReqDtlBloc
    extends Bloc<PurchaseReqDtlEvent, PurchaseReqDtlState> {
  final DataRepo _dataService;
  PurchaseReqDtlBloc(this._dataService) : super(PurchaseReqDtlInitial()) {
    on<PurchaseReqDtlGet>((event, emit) async {
      emit(PurchaseReqDtlLoading());
      try {
        var response = await _dataService.getPurchaseRequisitionDetails(
            headerId: event.headerId);

        emit(PurchaseReqDtlSuccess(purReqDtlList: response));
      } catch (e) {
        emit(PurchaseReqDtlError(error: e));
      }
    });
  }
}
