import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class UserQrSaveEvent {}

final class UserQrSave extends UserQrSaveEvent {
  final String userid;
  final String itemid;
  final String machine;
  final String batchid;
  final String orgid;
  final String goodQty;
  final String badQty;
  final String qty;
  final String shiftnm;
  final String shiftFromTime;
  final num? hr;
  UserQrSave({
    required this.userid,
    required this.itemid,
    required this.machine,
    required this.batchid,
    required this.orgid,
    required this.goodQty,
    required this.badQty,
    required this.qty,
    required this.shiftnm,
    required this.shiftFromTime,
    this.hr,
  });
}

@immutable
sealed class UserQrSaveState {}

final class UserQrSaveInitial extends UserQrSaveState {}

final class UserQrSaveLoading extends UserQrSaveState {}

final class UserQrSaveSuccess extends UserQrSaveState {
  final List<BatchQrData> batchQrDataList;

  UserQrSaveSuccess({required this.batchQrDataList});
}

final class UserQrSaveError extends UserQrSaveState {
  final Object error;

  UserQrSaveError({required this.error});
}

class UserQrSaveBloc extends Bloc<UserQrSaveEvent, UserQrSaveState> {
  final DataRepo _dataService;
  UserQrSaveBloc(this._dataService) : super(UserQrSaveInitial()) {
    on<UserQrSave>((event, emit) async {
      emit(UserQrSaveLoading());
      try {
        var response = await _dataService.userQrSave(
          userid: event.userid,
          itemid: event.itemid,
          machine: event.machine,
          batchid: event.batchid,
          orgid: event.orgid,
          goodQty: event.goodQty,
          badQty: event.badQty,
          qty: event.qty,
          shiftnm: event.shiftnm,
          shiftFromTime: event.shiftFromTime,
          hr: event.hr,
        );
        emit(UserQrSaveSuccess(batchQrDataList: response));
      } catch (e) {
        emit(UserQrSaveError(error: e));
      }
    });
  }
}
