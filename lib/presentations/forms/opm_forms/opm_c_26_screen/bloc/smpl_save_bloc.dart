import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/model/sample_item.dart';

@immutable
sealed class SmplSaveEvent {}

final class SmplSave extends SmplSaveEvent {
  final int rcvOrg;
  final String customerCode;
  final String customerName;
  final String rcvDate;
  final String smplSender;
  final String note;
  final String assignee;
  final String userId;
  final List<SampleItem> items;
  SmplSave(
      {required this.rcvOrg,
      required this.customerCode,
      required this.customerName,
      required this.rcvDate,
      required this.smplSender,
      required this.note,
      required this.items,
      required this.assignee,
      required this.userId});
}

@immutable
sealed class SmplSaveState {}

final class SmplSaveInitial extends SmplSaveState {}

final class SmplSaveLoading extends SmplSaveState {}

final class SmplSaveSuccess extends SmplSaveState {
  final String headerId;
  SmplSaveSuccess({required this.headerId});
}

final class SmplSaveError extends SmplSaveState {
  final Object error;

  SmplSaveError({required this.error});
}

class SmplSaveBloc extends Bloc<SmplSaveEvent, SmplSaveState> {
  final DataService _dataService;

  SmplSaveBloc(this._dataService) : super(SmplSaveInitial()) {
    on<SmplSave>((event, emit) async {
      emit(SmplSaveLoading());
      try {
        var headerId = await _dataService.smplColHdrSave(
          customerCode: event.customerCode,
          customerName: event.customerName,
          note: event.note,
          rcvDate: event.rcvDate,
          rcvOrg: event.rcvOrg,
          smplSender: event.smplSender,
          assignee: event.assignee,
          userId: event.userId,
        );
        if (headerId.isNotEmpty) {
          for (int i = 0; i < event.items.length; i++) {
            await _dataService.smplColHdrDtlSave(
                headerId: int.parse(headerId),
                itemCode: event.items[i].itemCode,
                itemName: event.items[i].itemName,
                qty: event.items[i].qty,
                unit: event.items[i].unit);
          }
        }
        emit(SmplSaveSuccess(headerId: headerId));
      } catch (e) {
        emit(SmplSaveError(error: e));
      }
    });
  }
}
