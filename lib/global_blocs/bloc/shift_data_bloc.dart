import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/shift_data_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ShiftDataEvent {}

final class GetShiftData extends ShiftDataEvent {
  GetShiftData();
}

final class ResetShiftData extends ShiftDataEvent {
  ResetShiftData();
}

@immutable
sealed class ShiftDataState {}

final class ShiftDataInitial extends ShiftDataState {}

final class ShiftDataLoading extends ShiftDataState {}

final class ShiftDataSuccess extends ShiftDataState {
  final List<ShiftData> shiftList;

  ShiftDataSuccess({required this.shiftList});
}

final class ShiftDataError extends ShiftDataState {
  final Object error;

  ShiftDataError({required this.error});
}

class ShiftDataBloc extends Bloc<ShiftDataEvent, ShiftDataState> {
  final DataRepo _dataService;
  List<ShiftData> _shiftlist = [];
  ShiftDataBloc(this._dataService) : super(ShiftDataInitial()) {
    on<GetShiftData>((event, emit) async {
      emit(ShiftDataLoading());
      try {
        var response = await _dataService.getShiftData();
        _shiftlist.clear();
        _shiftlist = response;
        emit(ShiftDataSuccess(shiftList: _shiftlist));
      } catch (e) {
        emit(ShiftDataError(error: e));
      }
    });
    on<ResetShiftData>((event, emit) async {
      emit(ShiftDataInitial());
    });
  }
}
