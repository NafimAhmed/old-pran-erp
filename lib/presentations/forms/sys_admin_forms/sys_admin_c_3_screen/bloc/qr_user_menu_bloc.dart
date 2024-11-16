import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class QrUserMenuEvent {}

final class GetQrUserMenu extends QrUserMenuEvent {
  final String newUserId;
  final String creatorId;

  GetQrUserMenu({required this.newUserId, required this.creatorId});
}

@immutable
sealed class QrUserMenuState {}

final class QrUserMenuInitial extends QrUserMenuState {}

final class QrUserMenuLoading extends QrUserMenuState {}

final class QrUserMenuSuccess extends QrUserMenuState {
  final List<QrModuleData> qrUserMenu;

  QrUserMenuSuccess({required this.qrUserMenu});
}

final class QrUserMenuError extends QrUserMenuState {
  final Object error;

  QrUserMenuError({required this.error});
}

class QrUserMenuBloc extends Bloc<QrUserMenuEvent, QrUserMenuState> {
  final DataService _dataService;
  QrUserMenuBloc(this._dataService) : super(QrUserMenuInitial()) {
    on<GetQrUserMenu>((event, emit) async {
      emit(QrUserMenuLoading());
      try {
        var response = await _dataService.getQrUserMenu(
          newUserId: event.newUserId,
          creatorId: event.creatorId,
        );
        emit(QrUserMenuSuccess(qrUserMenu: response));
      } catch (e) {
        emit(QrUserMenuError(error: e));
      }
    });
  }
}
