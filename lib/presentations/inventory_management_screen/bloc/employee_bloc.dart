import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/employee_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class EmployeeEvent {}

final class EmployeeGet extends EmployeeEvent {}

@immutable
sealed class EmployeeState {}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

final class EmployeeSuccess extends EmployeeState {
  final List<Employee> empList;

  EmployeeSuccess({required this.empList});
}

final class EmployeeError extends EmployeeState {
  final Object error;

  EmployeeError({required this.error});
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final DataService _dataService;
  EmployeeBloc(this._dataService) : super(EmployeeInitial()) {
    on<EmployeeGet>((event, emit) async {
      emit(EmployeeLoading());
      try {
        var response = await _dataService.getEmplist();
        emit(EmployeeSuccess(empList: response));
      } catch (e) {
        emit(EmployeeError(error: e));
      }
    });
  }
}
