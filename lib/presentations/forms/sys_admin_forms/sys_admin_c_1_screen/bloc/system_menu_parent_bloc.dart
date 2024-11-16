import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class SystemMenuPrntEvent {}

final class GetSystemMenuPrnt extends SystemMenuPrntEvent {
  final String userId;
  final String moduleName;
  GetSystemMenuPrnt({required this.userId, required this.moduleName});
}

final class ResetSystemMenuPrnt extends SystemMenuPrntEvent {
  ResetSystemMenuPrnt();
}

@immutable
sealed class SystemMenuPrntState {}

final class SystemMenuPrntInitial extends SystemMenuPrntState {}

final class SystemMenuPrntLoading extends SystemMenuPrntState {}

final class SystemMenuPrntSuccess extends SystemMenuPrntState {
  final List<SysMenuparentData> sysMenuPrntDataList;
  SystemMenuPrntSuccess({required this.sysMenuPrntDataList});
}

final class SystemMenuPrntError extends SystemMenuPrntState {
  final Object error;

  SystemMenuPrntError({required this.error});
}

class SystemMenuPrntBloc
    extends Bloc<SystemMenuPrntEvent, SystemMenuPrntState> {
  final DataService _dataService;
  SystemMenuPrntBloc(this._dataService) : super(SystemMenuPrntInitial()) {
    on<GetSystemMenuPrnt>((event, emit) async {
      emit(SystemMenuPrntLoading());
      try {
        var response = await _dataService.getSystemMenuParent(
            userId: event.userId, moduleName: event.moduleName);
        emit(SystemMenuPrntSuccess(sysMenuPrntDataList: response));
      } catch (e) {
        emit(SystemMenuPrntError(error: e));
      }
    });
    on<ResetSystemMenuPrnt>((event, emit) async {
      emit(SystemMenuPrntInitial());
    });
  }
}
