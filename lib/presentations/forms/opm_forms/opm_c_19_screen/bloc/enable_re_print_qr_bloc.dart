import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class EnableRePrintQrEvent {}

final class EnableRePrintQrData extends EnableRePrintQrEvent {
  final String lotNo;
  final String qrType;

  EnableRePrintQrData({required this.lotNo, required this.qrType});
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
  final DataRepo _dataService;
  EnableRePrintQrBloc(this._dataService) : super(EnableRePrintQrInitial()) {
    on<EnableRePrintQrData>((event, emit) async {
      emit(EnableRePrintQrLoading());

      try {
        await _dataService.enableRePrint(
          pTrno: event.lotNo,
          qrType: event.qrType,
        );
        emit(EnableRePrintQrSuccess());
      } catch (e) {
        emit(EnableRePrintQrError(error: e));
      }
    });
  }
}
