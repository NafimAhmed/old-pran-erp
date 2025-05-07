import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/operation_unit_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class OperationUnitEvent {}

final class OperationUnitGet extends OperationUnitEvent {
  OperationUnitGet();
}

@immutable
sealed class OperationUnitState {}

final class OperationUnitInitial extends OperationUnitState {}

final class OperationUnitLoading extends OperationUnitState {}

final class OperationUnitSuccess extends OperationUnitState {
  final List<OperationUnit> operationUnit;

  OperationUnitSuccess({required this.operationUnit});
}

final class OperationUnitError extends OperationUnitState {
  final Object error;

  OperationUnitError({required this.error});
}

class OperationUnitBloc extends Bloc<OperationUnitEvent, OperationUnitState> {
  final DataRepo _dataService;
  List<OperationUnit> _operationUnit = [];
  OperationUnitBloc(this._dataService) : super(OperationUnitInitial()) {
    on<OperationUnitGet>((event, emit) async {
      emit(OperationUnitLoading());
      try {
        var response = await _dataService.getOperationUnit();
        _operationUnit.clear();
        _operationUnit = response;
        emit(OperationUnitSuccess(operationUnit: _operationUnit));
      } catch (e) {
        emit(OperationUnitError(error: e));
      }
    });
  }
}
