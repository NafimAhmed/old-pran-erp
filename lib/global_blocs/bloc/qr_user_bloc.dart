import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class QrUserEvent {}

final class GetQrUsers extends QrUserEvent {}

@immutable
sealed class QrUserState {}

final class QrUserInitial extends QrUserState {}

final class QrUserLoading extends QrUserState {}

final class QrUserSuccess extends QrUserState {
  final List<QrUserData> qrUsers;

  QrUserSuccess({required this.qrUsers});
}

final class QrUserError extends QrUserState {
  final Object error;

  QrUserError({required this.error});
}

class QrUserBloc extends Bloc<QrUserEvent, QrUserState> {
  final DataService _dataService;
  QrUserBloc(this._dataService) : super(QrUserInitial()) {
    on<GetQrUsers>((event, emit) async {
      emit(QrUserLoading());
      try {
        var response = await _dataService.getQrUsers();
        emit(QrUserSuccess(qrUsers: response));
      } catch (e) {
        emit(QrUserError(error: e));
      }
    });
  }
}
