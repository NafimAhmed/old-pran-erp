import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class QrUserChildMenuEvent {}

final class GetQrUserChildMenu extends QrUserChildMenuEvent {
  final String newUserId;
  final String creatorId;
  final String routeName;

  GetQrUserChildMenu({
    required this.newUserId,
    required this.creatorId,
    required this.routeName,
  });
}

@immutable
sealed class QrUserChildMenuState {}

final class QrUserChildMenuInitial extends QrUserChildMenuState {}

final class QrUserChildMenuLoading extends QrUserChildMenuState {}

final class QrUserChildMenuSuccess extends QrUserChildMenuState {
  final List<QrUserChildMenu> qrUserChildMenu;

  QrUserChildMenuSuccess({required this.qrUserChildMenu});
}

final class QrUserChildMenuError extends QrUserChildMenuState {
  final Object error;

  QrUserChildMenuError({required this.error});
}

class QrUserChildMenuBloc
    extends Bloc<QrUserChildMenuEvent, QrUserChildMenuState> {
  final DataRepo _dataService;
  QrUserChildMenuBloc(this._dataService) : super(QrUserChildMenuInitial()) {
    on<GetQrUserChildMenu>((event, emit) async {
      emit(QrUserChildMenuLoading());
      try {
        var response = await _dataService.getQrUserChildMenu(
          newUserId: event.newUserId,
          creatorId: event.creatorId,
          routeName: event.routeName,
        );
        emit(QrUserChildMenuSuccess(qrUserChildMenu: response));
      } catch (e) {
        emit(QrUserChildMenuError(error: e));
      }
    });
  }
}
