import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class LocatorTransferEvent {}

final class LocatorTransfer extends LocatorTransferEvent {
  final String userid;
  final String torackid;
  final String trnid;
  LocatorTransfer({
    required this.userid,
    required this.torackid,
    required this.trnid,
  });
}

@immutable
sealed class LocatorTransferState {}

final class LocatorTransferInitial extends LocatorTransferState {}

final class LocatorTransferLoading extends LocatorTransferState {}

final class LocatorTransferSuccess extends LocatorTransferState {}

final class LocatorTransferError extends LocatorTransferState {
  final Object error;

  LocatorTransferError({required this.error});
}

class LocatorTransferBloc
    extends Bloc<LocatorTransferEvent, LocatorTransferState> {
  final DataService _dataService;
  LocatorTransferBloc(this._dataService) : super(LocatorTransferInitial()) {
    on<LocatorTransfer>((event, emit) async {
      emit(LocatorTransferLoading());
      try {
        await _dataService.locatorTranfer(
          userid: event.userid,
          torackid: event.torackid,
          trnid: event.trnid,
        );
        emit(LocatorTransferSuccess());
      } catch (error) {
        emit(LocatorTransferError(error: error));
      }
    });
  }
}
