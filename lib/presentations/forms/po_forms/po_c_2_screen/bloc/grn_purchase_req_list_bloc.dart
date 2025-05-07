import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/models/grn_purchase_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class GrnPurchaseReqListEvent {}

final class GrnPurchaseReqListGet extends GrnPurchaseReqListEvent {
  final int orgId;
  GrnPurchaseReqListGet({required this.orgId});
}

@immutable
sealed class GrnPurchaseReqListState {}

final class GrnPurchaseReqListInitial extends GrnPurchaseReqListState {}

final class GrnPurchaseReqListLoading extends GrnPurchaseReqListState {}

final class GrnPurchaseReqListSuccess extends GrnPurchaseReqListState {
  final List<GrnPurchaseReqNumber> purchaseReqNumber;

  GrnPurchaseReqListSuccess({required this.purchaseReqNumber});
}

final class GrnPurchaseReqListError extends GrnPurchaseReqListState {
  final Object error;

  GrnPurchaseReqListError({required this.error});
}

class GrnPurchaseReqListBloc
    extends Bloc<GrnPurchaseReqListEvent, GrnPurchaseReqListState> {
  final DataRepo _dataService;
  List<GrnPurchaseReqNumber> _purchaseReqNumList = [];
  GrnPurchaseReqListBloc(this._dataService)
      : super(GrnPurchaseReqListInitial()) {
    on<GrnPurchaseReqListGet>((event, emit) async {
      emit(GrnPurchaseReqListLoading());
      try {
        var response =
            await _dataService.getGrnPurchaseReqList(ordId: event.orgId);
        _purchaseReqNumList.clear();
        _purchaseReqNumList = response;
        emit(GrnPurchaseReqListSuccess(purchaseReqNumber: _purchaseReqNumList));
      } catch (e) {
        emit(GrnPurchaseReqListError(error: e));
      }
    });
  }
}
