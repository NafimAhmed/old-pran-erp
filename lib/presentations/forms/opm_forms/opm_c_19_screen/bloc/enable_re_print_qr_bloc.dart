import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class EnableRePrintQrEvent {}

final class EnableRePrintQrData extends EnableRePrintQrEvent {
  final String lotNo;

  EnableRePrintQrData({required this.lotNo});
}

@immutable
sealed class EnableRePrintQrState {}

final class EnableRePrintQrInitial extends EnableRePrintQrState {}

final class EnableRePrintQrLoading extends EnableRePrintQrState {}

final class EnableRePrintQrSuccess extends EnableRePrintQrState {}

final class EnableRePrintQrError extends EnableRePrintQrState {
  final Object error;

  EnableRePrintQrError({required this.error});
}

class EnableRePrintQrBloc
    extends Bloc<EnableRePrintQrEvent, EnableRePrintQrState> {
  final DataService _dataService;
  EnableRePrintQrBloc(this._dataService) : super(EnableRePrintQrInitial()) {
    on<EnableRePrintQrData>((event, emit) async {
      emit(EnableRePrintQrLoading());

      try {
        await _dataService.enableRePrint(pTrno: event.lotNo);
        emit(EnableRePrintQrSuccess());
      } catch (e) {
        emit(EnableRePrintQrError(error: e));
      }
    });
  }
}
