import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TempBatchDataEvent {}

final class TempBatchDataGet extends TempBatchDataEvent {}

@immutable
sealed class TempBatchDataState {}

final class TempBatchDataInitial extends TempBatchDataState {}

final class TempBatchDataLoading extends TempBatchDataState {}

final class TempBatchDataSuccess extends TempBatchDataState {
  final List<TempBatchData> tempBatchDataList;

  TempBatchDataSuccess({required this.tempBatchDataList});
}

final class TempBatchDataError extends TempBatchDataState {
  final Object error;

  TempBatchDataError({required this.error});
}

class TempBatchDataBloc extends Bloc<TempBatchDataEvent, TempBatchDataState> {
  final DataService _dataService;
  TempBatchDataBloc(this._dataService) : super(TempBatchDataInitial()) {
    on<TempBatchDataGet>((event, emit) async {
      emit(TempBatchDataLoading());
      try {
        emit(TempBatchDataLoading());
        var response = await _dataService.getTempBatchData();
        emit(TempBatchDataSuccess(tempBatchDataList: response));
      } catch (e) {
        emit(TempBatchDataError(error: e));
      }
    });
  }
}
