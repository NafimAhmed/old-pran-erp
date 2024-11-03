import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class InterOrgTranferEvent {}

final class InterOrgTransfer extends InterOrgTranferEvent {
  final String userid;
  final String trackid;
  final String itemid;
  final String rqty;
  final String batchid;
  final String split;

  InterOrgTransfer({
    required this.userid,
    required this.trackid,
    required this.itemid,
    required this.rqty,
    required this.batchid,
    required this.split,
  });
}

@immutable
sealed class InterOrgTransferState {}

final class InterOrgTransferInitial extends InterOrgTransferState {}

final class InterOrgTransferLoading extends InterOrgTransferState {
  final String splitFlag;

  InterOrgTransferLoading({required this.splitFlag});
}

final class InterOrgTransferSuccess extends InterOrgTransferState {}

final class InterOrgTransferError extends InterOrgTransferState {
  final Object error;

  InterOrgTransferError({required this.error});
}

class InterOrgTransferBloc
    extends Bloc<InterOrgTranferEvent, InterOrgTransferState> {
  final DataService _dataService;
  InterOrgTransferBloc(this._dataService) : super(InterOrgTransferInitial()) {
    on<InterOrgTransfer>((event, emit) async {
      emit(InterOrgTransferLoading(splitFlag: event.split));
      try {
        await _dataService.interOrgTransfer(
          userid: event.userid,
          trackid: event.trackid,
          itemid: event.itemid,
          rqty: event.rqty,
          batchid: event.batchid,
        );
        emit(InterOrgTransferSuccess());
      } catch (error) {
        emit(InterOrgTransferError(error: error));
      }
    });
  }
}
