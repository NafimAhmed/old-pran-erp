import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class QrUserMenuPermissionEvent {}

final class GetQrUserMenuPermission extends QrUserMenuPermissionEvent {
  final String userId;
  final String newUserId;
  final String menuId;
  GetQrUserMenuPermission(
      {required this.userId, required this.newUserId, required this.menuId});
}

@immutable
sealed class QrUserMenuPermissionState {}

final class QrUserMenuPermissionInitial extends QrUserMenuPermissionState {}

final class QrUserMenuPermissionLoading extends QrUserMenuPermissionState {}

final class QrUserMenuPermissionSuccess extends QrUserMenuPermissionState {}

final class QrUserMenuPermissionError extends QrUserMenuPermissionState {
  final Object error;

  QrUserMenuPermissionError({required this.error});
}

class QrUserMenuPermissionBloc
    extends Bloc<QrUserMenuPermissionEvent, QrUserMenuPermissionState> {
  final DataService _dataService;
  QrUserMenuPermissionBloc(this._dataService)
      : super(QrUserMenuPermissionInitial()) {
    on<GetQrUserMenuPermission>((event, emit) async {
      emit(QrUserMenuPermissionLoading());
      try {
        await _dataService.giveUserMenuPermission(
          newUserId: event.newUserId,
          menuId: event.menuId,
          userId: event.userId,
        );
        emit(QrUserMenuPermissionSuccess());
      } catch (e) {
        emit(QrUserMenuPermissionError(error: e));
      }
    });
  }
}
