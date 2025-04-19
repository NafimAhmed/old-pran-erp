import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class GrnQrListEvent {}

final class GrnQrListGet extends GrnQrListEvent {
  final String userId;
  GrnQrListGet({required this.userId});
}

@immutable
sealed class GrnQrListState {}

final class GrnQrListInitial extends GrnQrListState {}

final class GrnQrListLoading extends GrnQrListState {}

final class GrnQrListSuccess extends GrnQrListState {
  final List<GrnQr> grnQr;

  GrnQrListSuccess({required this.grnQr});
}

final class GrnQrListError extends GrnQrListState {
  final Object error;

  GrnQrListError({required this.error});
}

class GrnQrListBloc extends Bloc<GrnQrListEvent, GrnQrListState> {
  final DataService _dataService;
  List<GrnQr> _grnQr = [];
  GrnQrListBloc(this._dataService) : super(GrnQrListInitial()) {
    on<GrnQrListGet>((event, emit) async {
      emit(GrnQrListLoading());
      try {
        var response = await _dataService.getGrnQrList(userId: event.userId);
        _grnQr.clear();
        _grnQr = response;
        emit(GrnQrListSuccess(grnQr: _grnQr));
      } catch (e) {
        emit(GrnQrListError(error: e));
      }
    });
  }
}
