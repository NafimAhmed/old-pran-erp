import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_po_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class GrnPOListEvent {}

final class GrnPOListGet extends GrnPOListEvent {
  final String jobOrderNo;
  GrnPOListGet({required this.jobOrderNo});
}

@immutable
sealed class GrnPOListState {}

final class GrnPOListInitial extends GrnPOListState {}

final class GrnPOListLoading extends GrnPOListState {}

final class GrnPOListSuccess extends GrnPOListState {
  final List<GrnPO> grnPOList;

  GrnPOListSuccess({required this.grnPOList});
}

final class GrnPOListError extends GrnPOListState {
  final Object error;

  GrnPOListError({required this.error});
}

class GrnPOListBloc extends Bloc<GrnPOListEvent, GrnPOListState> {
  final DataService _dataService;
  List<GrnPO> _grnPOList = [];
  GrnPOListBloc(this._dataService) : super(GrnPOListInitial()) {
    on<GrnPOListGet>((event, emit) async {
      emit(GrnPOListLoading());
      try {
        var response =
            await _dataService.getGrnPOList(jobOrderNo: event.jobOrderNo);
        _grnPOList.clear();
        _grnPOList = response;
        emit(GrnPOListSuccess(grnPOList: _grnPOList));
      } catch (e) {
        emit(GrnPOListError(error: e));
      }
    });
  }
}
