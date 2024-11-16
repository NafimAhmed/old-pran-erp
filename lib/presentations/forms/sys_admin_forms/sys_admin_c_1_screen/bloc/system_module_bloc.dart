import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class SystemModuleEvent {}

final class GetSystemModule extends SystemModuleEvent {
  final String userId;

  GetSystemModule({required this.userId});
}

@immutable
sealed class SystemModuleState {}

final class SystemModuleInitial extends SystemModuleState {}

final class SystemModuleLoading extends SystemModuleState {}

final class SystemModuleSuccess extends SystemModuleState {
  final List<SysModuleData> sysModuleDataList;
  SystemModuleSuccess({required this.sysModuleDataList});
}

final class SystemModuleError extends SystemModuleState {
  final Object error;

  SystemModuleError({required this.error});
}

class SystemModuleBloc extends Bloc<SystemModuleEvent, SystemModuleState> {
  final DataService _dataService;
  SystemModuleBloc(this._dataService) : super(SystemModuleInitial()) {
    on<GetSystemModule>((event, emit) async {
      emit(SystemModuleLoading());
      try {
        var response = await _dataService.getSystemModule(userId: event.userId);
        emit(SystemModuleSuccess(sysModuleDataList: response));
      } catch (e) {
        emit(SystemModuleError(error: e));
      }
    });
  }
}
