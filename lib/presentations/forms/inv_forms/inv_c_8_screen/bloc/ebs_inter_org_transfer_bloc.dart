import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class EbsInterOrgTranEvent {}

final class EbsInterOrgTran extends EbsInterOrgTranEvent {
  final String userid;
  final String itemlotno;
  final String torackid;

  final String trnid;
  EbsInterOrgTran({
    required this.userid,
    required this.itemlotno,
    required this.torackid,
    required this.trnid,
  });
}

final class EbsInterOrgTranNew extends EbsInterOrgTranEvent {
  final String pTrnid;
  final String userid;
  final String rackId;
  final String pQty;
  final int pItemId;
  final int pOrgId;
  final int pFlocatorId;

  EbsInterOrgTranNew({
    required this.pTrnid,
    required this.userid,
    required this.rackId,
    required this.pQty,
    required this.pItemId,
    required this.pOrgId,
    required this.pFlocatorId,
  });
}

@immutable
sealed class EbsInterOrgTranState {}

final class EbsInterOrgTranInitial extends EbsInterOrgTranState {}

final class EbsInterOrgTranLoading extends EbsInterOrgTranState {}

final class EbsInterOrgTranSuccess extends EbsInterOrgTranState {}

final class EbsInterOrgTranError extends EbsInterOrgTranState {
  final Object error;

  EbsInterOrgTranError({required this.error});
}

class EbsInterOrgTranBloc
    extends Bloc<EbsInterOrgTranEvent, EbsInterOrgTranState> {
  final DataRepo _dataService;
  EbsInterOrgTranBloc(this._dataService) : super(EbsInterOrgTranInitial()) {
    on<EbsInterOrgTran>((event, emit) async {
      emit(EbsInterOrgTranLoading());
      try {
        await _dataService.ebsInterOrgTransfer(
          userid: event.userid,
          itemlotno: event.itemlotno,
          torackid: event.torackid,
          trnid: event.trnid,
        );
        emit(EbsInterOrgTranSuccess());
      } catch (error) {
        emit(EbsInterOrgTranError(error: error));
      }
    });

    on<EbsInterOrgTranNew>((event, emit) async {
      emit(EbsInterOrgTranLoading());
      try {
        await _dataService.prodTransferNew(
          pTrnId: event.pTrnid,
          rackId: event.rackId,
          userId: event.userid,
          pQty: event.pQty,
          pItemId: event.pItemId,
          pOrgId: event.pOrgId,
          pFlocatorId: event.pFlocatorId,
        );
        emit(EbsInterOrgTranSuccess());
      } catch (error) {
        emit(EbsInterOrgTranError(error: error));
      }
    });
  }
}
