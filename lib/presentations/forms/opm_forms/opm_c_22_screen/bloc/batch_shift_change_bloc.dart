import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class BatchShiftChangeEvent {}

final class ChangeBatchShift extends BatchShiftChangeEvent {
  final String userId;
  final String lotNo;
  final String shiftName;
  final String machineName;
  final String manPower;

  ChangeBatchShift(
      {required this.userId,
      required this.lotNo,
      required this.shiftName,
      required this.machineName,
      required this.manPower});
}

@immutable
sealed class BatchShiftChangeState {}

final class BatchShiftChangeInitial extends BatchShiftChangeState {}

final class BatchShiftChangeLoading extends BatchShiftChangeState {}

final class BatchShiftChangeSuccess extends BatchShiftChangeState {
  BatchShiftChangeSuccess();
}

final class BatchShiftChangeError extends BatchShiftChangeState {
  final Object error;

  BatchShiftChangeError({required this.error});
}

class BatchShiftChangeBloc
    extends Bloc<BatchShiftChangeEvent, BatchShiftChangeState> {
  final DataService _dataService;
  BatchShiftChangeBloc(this._dataService) : super(BatchShiftChangeInitial()) {
    on<ChangeBatchShift>((event, emit) async {
      emit(BatchShiftChangeLoading());
      try {
        await _dataService.batchShiftChange(
            userId: event.userId,
            lotNo: event.lotNo,
            shiftName: event.shiftName,
            machineName: event.machineName,
            manPower: event.manPower);
        emit(BatchShiftChangeSuccess());
      } catch (e) {
        emit(BatchShiftChangeError(error: e));
      }
    });
  }
}
