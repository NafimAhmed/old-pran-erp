import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class GrnQrSaveEvent {}

final class GrnQrSave extends GrnQrSaveEvent {
  final String userId;
  final int orgId;
  final int itemId;
  final num goodQty;
  final num qty;
  final num badQty;
  final String jobOrderNo;
  final String prId;
  GrnQrSave({
    required this.userId,
    required this.orgId,
    required this.itemId,
    required this.goodQty,
    required this.qty,
    required this.badQty,
    required this.jobOrderNo,
    required this.prId,
  });
}

@immutable
sealed class GrnQrSaveState {}

final class GrnQrSaveInitial extends GrnQrSaveState {}

final class GrnQrSaveLoading extends GrnQrSaveState {}

final class GrnQrSaveSuccess extends GrnQrSaveState {}

final class GrnQrSaveError extends GrnQrSaveState {
  final Object error;

  GrnQrSaveError({required this.error});
}

class GrnQrSaveBloc extends Bloc<GrnQrSaveEvent, GrnQrSaveState> {
  final DataService _dataService;

  GrnQrSaveBloc(this._dataService) : super(GrnQrSaveInitial()) {
    on<GrnQrSave>((event, emit) async {
      emit(GrnQrSaveLoading());
      try {
        await _dataService.getGrnQrSave(
            userId: event.userId,
            orgId: event.orgId,
            itemId: event.itemId,
            goodQty: event.goodQty,
            qty: event.qty,
            badQty: event.badQty,
            jobOrderNo: event.jobOrderNo,
            prId: event.prId);

        emit(GrnQrSaveSuccess());
      } catch (e) {
        emit(GrnQrSaveError(error: e));
      }
    });
  }
}
