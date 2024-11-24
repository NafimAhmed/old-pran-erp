import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/machine_assign_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class MachineAssignEvent {}

final class AsignMachine extends MachineAssignEvent {
  final String machinename;
  final String userId;
  final String orgId;

  AsignMachine(
      {required this.machinename, required this.userId, required this.orgId});
}

@immutable
sealed class MachineAssignState {}

final class MachineAssignInitial extends MachineAssignState {}

final class MachineAssignLoading extends MachineAssignState {}

final class MachineAssignSuccess extends MachineAssignState {
  final List<OrgMachineInfo> orgMachineInfoList;

  MachineAssignSuccess({required this.orgMachineInfoList});
}

final class MachineAssignError extends MachineAssignState {
  final Object error;

  MachineAssignError({required this.error});
}

class MachineAssignBloc extends Bloc<MachineAssignEvent, MachineAssignState> {
  final DataService _dataService;
  MachineAssignBloc(this._dataService) : super(MachineAssignInitial()) {
    on<AsignMachine>((event, emit) async {
      emit(MachineAssignLoading());
      try {
        var response = await _dataService.assignMachineToOrg(
            machinename: event.machinename,
            orgId: event.orgId,
            userId: event.userId);
        emit(MachineAssignSuccess(orgMachineInfoList: response));
      } catch (e) {
        emit(MachineAssignError(error: e));
      }
    });
  }
}
