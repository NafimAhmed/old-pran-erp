import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class SysMenuCreateEvent {}

final class CreateSysMenu extends SysMenuCreateEvent {
  final String userId;
  final String pMenuName;
  final String pMenuType;
  final String pModule;
  final String? pParent;

  CreateSysMenu({
    required this.userId,
    required this.pMenuName,
    required this.pMenuType,
    required this.pModule,
    required this.pParent,
  });
}

@immutable
sealed class SysMenuCreateState {}

final class SysMenuCreateInitial extends SysMenuCreateState {}

final class SysMenuCreateLoading extends SysMenuCreateState {}

final class SysMenuCreateSuccess extends SysMenuCreateState {}

final class SysMenuCreateError extends SysMenuCreateState {
  final Object error;

  SysMenuCreateError({required this.error});
}

class SysMenuCreateBloc extends Bloc<SysMenuCreateEvent, SysMenuCreateState> {
  final DataRepo _dataService;
  SysMenuCreateBloc(this._dataService) : super(SysMenuCreateInitial()) {
    on<CreateSysMenu>((event, emit) async {
      emit(SysMenuCreateLoading());
      try {
        await _dataService.sysCreateMenu(
          userId: event.userId,
          pMenuName: event.pMenuName,
          pMenuType: event.pMenuType,
          pModule: event.pModule,
          pParent: event.pParent,
        );
        emit(SysMenuCreateSuccess());
      } catch (e) {
        emit(SysMenuCreateError(error: e));
      }
    });
  }
}
