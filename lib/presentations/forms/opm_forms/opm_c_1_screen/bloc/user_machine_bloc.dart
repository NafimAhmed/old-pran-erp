import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/prod_basic_data_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class UserMachineEvent {}

final class UserMachineGet extends UserMachineEvent {
  final String userId;

  UserMachineGet({required this.userId});
}

final class MachineSelected extends UserMachineEvent {
  final UserMachine? selectedLov;

  MachineSelected({required this.selectedLov});
}

@immutable
sealed class UserMachineState {}

final class LovInitial extends UserMachineState {}

final class UserMachineLoading extends UserMachineState {}

final class UserMachineLoaded extends UserMachineState {
  final List<UserMachine> userMachineList;
  final UserMachine? selectedmachine;

  UserMachineLoaded(
      {required this.userMachineList, required this.selectedmachine});
}

final class UserMachineError extends UserMachineState {
  final Object error;

  UserMachineError({required this.error});
}

class UserMachineBloc extends Bloc<UserMachineEvent, UserMachineState> {
  final DataService _dataService;
  List<UserMachine> _userMachineList = [];
  UserMachine? _selectedMachine;
  UserMachineBloc(this._dataService) : super(LovInitial()) {
    on<UserMachineGet>((event, emit) async {
      emit(UserMachineLoading());
      try {
        var response = await _dataService.getUserMachine(userId: event.userId);
        _userMachineList.clear();
        _userMachineList = response;
        emit(
          UserMachineLoaded(
            userMachineList: _userMachineList,
            selectedmachine: _selectedMachine,
          ),
        );
      } catch (error) {
        emit(UserMachineError(error: error));
      }
    });
    on<MachineSelected>((event, emit) async {
      _selectedMachine = event.selectedLov;
      emit(UserMachineLoaded(
          userMachineList: _userMachineList,
          selectedmachine: _selectedMachine));
    });
  }
}
