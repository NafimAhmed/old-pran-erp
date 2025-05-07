import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_jo_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class GrnJobOrderListEvent {}

final class GrnJobOrderListGet extends GrnJobOrderListEvent {
  final String reqNo;
  GrnJobOrderListGet({required this.reqNo});
}

@immutable
sealed class GrnJobOrderListState {}

final class GrnJobOrderListInitial extends GrnJobOrderListState {}

final class GrnJobOrderListLoading extends GrnJobOrderListState {}

final class GrnJobOrderListSuccess extends GrnJobOrderListState {
  final List<GrnJO> grnJOList;

  GrnJobOrderListSuccess({required this.grnJOList});
}

final class GrnJobOrderListError extends GrnJobOrderListState {
  final Object error;

  GrnJobOrderListError({required this.error});
}

class GrnJobOrderListBloc
    extends Bloc<GrnJobOrderListEvent, GrnJobOrderListState> {
  final DataRepo _dataService;
  List<GrnJO> _grnJOList = [];
  GrnJobOrderListBloc(this._dataService) : super(GrnJobOrderListInitial()) {
    on<GrnJobOrderListGet>((event, emit) async {
      emit(GrnJobOrderListLoading());
      try {
        var response = await _dataService.getGrnJOList(reqNo: event.reqNo);
        _grnJOList.clear();
        _grnJOList = response;
        emit(GrnJobOrderListSuccess(grnJOList: _grnJOList));
      } catch (e) {
        emit(GrnJobOrderListError(error: e));
      }
    });
  }
}
