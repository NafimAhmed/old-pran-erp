import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/purchase_requisition_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class PurchaseReqEvent {}

final class PurchaseReqGet extends PurchaseReqEvent {
  final String userId;
  PurchaseReqGet({required this.userId});
}

@immutable
sealed class PurchaseReqState {}

final class PurchaseReqInitial extends PurchaseReqState {}

final class PurchaseReqLoading extends PurchaseReqState {}

final class PurchaseReqSuccess extends PurchaseReqState {
  final List<PurchaseRequisition> purReqList;

  PurchaseReqSuccess({required this.purReqList});
}

final class PurchaseReqError extends PurchaseReqState {
  final Object error;

  PurchaseReqError({required this.error});
}

class PurchaseReqBloc extends Bloc<PurchaseReqEvent, PurchaseReqState> {
  final DataRepo _dataService;
  PurchaseReqBloc(this._dataService) : super(PurchaseReqInitial()) {
    on<PurchaseReqGet>((event, emit) async {
      emit(PurchaseReqLoading());
      try {
        var response =
            await _dataService.getPurchaseRequisitionList(userId: event.userId);

        emit(PurchaseReqSuccess(purReqList: response));
      } catch (e) {
        emit(PurchaseReqError(error: e));
      }
    });
  }
}
