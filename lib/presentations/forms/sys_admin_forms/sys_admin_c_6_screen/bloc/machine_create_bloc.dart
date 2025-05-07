import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class MachineCreateEvent {}

final class CreateMachine extends MachineCreateEvent {
  final String machinename;
  final String userId;

  CreateMachine({
    required this.machinename,
    required this.userId,
  });
}

@immutable
sealed class MachineCreateState {}

final class MachineCreateInitial extends MachineCreateState {}

final class MachineCreateLoading extends MachineCreateState {
  final String type;

  MachineCreateLoading({required this.type});
}

final class MachineCreateSuccess extends MachineCreateState {
  final List<MachineInfo> machineInfoList;
  final List<UserOrg> orgInfoList;
  final String type;
  MachineCreateSuccess({
    required this.machineInfoList,
    required this.orgInfoList,
    required this.type,
  });
}

final class MachineCreateError extends MachineCreateState {
  final Object error;

  MachineCreateError({required this.error});
}

class MachineCreateBloc extends Bloc<MachineCreateEvent, MachineCreateState> {
  final DataRepo _dataService;
  MachineCreateBloc(this._dataService) : super(MachineCreateInitial()) {
    on<CreateMachine>((event, emit) async {
      emit(MachineCreateLoading(
        type: event.machinename,
      ));
      try {
        var response = await _dataService.createMachine(
            machinename: event.machinename, userId: event.userId);
        emit(MachineCreateSuccess(
          machineInfoList: response.machineInfo ?? [],
          orgInfoList: response.orgInfo ?? [],
          type: event.machinename,
        ));
      } catch (e) {
        emit(MachineCreateError(error: e));
      }
    });
  }
}
