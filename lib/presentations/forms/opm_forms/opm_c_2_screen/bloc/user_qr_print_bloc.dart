import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class UserQrPrintEvent {}

final class GetUserQrPrintData extends UserQrPrintEvent {
  final String userid;
  final String orgid;

  GetUserQrPrintData({required this.userid, required this.orgid});
}

@immutable
sealed class UserQrPrintState {}

final class UserQrPrintInitial extends UserQrPrintState {}

final class UserQrPrintLoading extends UserQrPrintState {}

final class UserQrPrintSuccess extends UserQrPrintState {
  final List<UserBatchQrData> userBatchQrDataList;

  UserQrPrintSuccess({required this.userBatchQrDataList});
}

final class UserQrPrintError extends UserQrPrintState {
  final Object error;

  UserQrPrintError({required this.error});
}

class UserQrPrintBloc extends Bloc<UserQrPrintEvent, UserQrPrintState> {
  final DataService _dataService;
  UserQrPrintBloc(this._dataService) : super(UserQrPrintInitial()) {
    on<GetUserQrPrintData>((event, emit) async {
      emit(UserQrPrintLoading());
      try {
        var response = await _dataService.getUserQrPrintData(
            userid: event.userid, orgid: event.orgid);
        emit(UserQrPrintSuccess(userBatchQrDataList: response));
      } catch (e) {
        emit(UserQrPrintError(error: e));
      }
    });
  }
}
