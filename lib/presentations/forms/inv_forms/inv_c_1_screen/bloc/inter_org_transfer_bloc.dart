import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class InterOrgTranferEvent {}

final class InterOrgTransfer extends InterOrgTranferEvent {
  final String userid;
  final String itemlotno;
  final String torackid;

  final String trnid;
  InterOrgTransfer({
    required this.userid,
    required this.itemlotno,
    required this.torackid,
    required this.trnid,
  });
}

@immutable
sealed class InterOrgTransferState {}

final class InterOrgTransferInitial extends InterOrgTransferState {}

final class InterOrgTransferLoading extends InterOrgTransferState {}

final class InterOrgTransferSuccess extends InterOrgTransferState {}

final class InterOrgTransferError extends InterOrgTransferState {
  final Object error;

  InterOrgTransferError({required this.error});
}

class InterOrgTransferBloc
    extends Bloc<InterOrgTranferEvent, InterOrgTransferState> {
  final DataRepo _dataService;
  InterOrgTransferBloc(this._dataService) : super(InterOrgTransferInitial()) {
    on<InterOrgTransfer>((event, emit) async {
      emit(InterOrgTransferLoading());
      try {
        await _dataService.interOrgTransfer(
          userid: event.userid,
          itemlotno: event.itemlotno,
          torackid: event.torackid,
          trnid: event.trnid,
        );
        emit(InterOrgTransferSuccess());
      } catch (error) {
        emit(InterOrgTransferError(error: error));
      }
    });
  }
}
