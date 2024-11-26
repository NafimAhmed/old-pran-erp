import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class RePrintQrEvent {}

final class GetRePrintQrData extends RePrintQrEvent {
  final String lotNo;

  GetRePrintQrData({required this.lotNo});
}

final class Reset extends RePrintQrEvent {}

@immutable
sealed class RePrintQrState {}

final class RePrintQrInitial extends RePrintQrState {}

final class RePrintQrLoading extends RePrintQrState {}

final class RePrintQrSuccess extends RePrintQrState {
  final List<RqrData> rQrDataList;

  RePrintQrSuccess({required this.rQrDataList});
}

final class RePrintQrError extends RePrintQrState {
  final Object error;

  RePrintQrError({required this.error});
}

class RePrintQrBloc extends Bloc<RePrintQrEvent, RePrintQrState> {
  final DataService _dataService;
  RePrintQrBloc(this._dataService) : super(RePrintQrInitial()) {
    on<GetRePrintQrData>((event, emit) async {
      emit(RePrintQrLoading());

      try {
        var response = await _dataService.getRePrintData(pTrno: event.lotNo);
        emit(RePrintQrSuccess(rQrDataList: response));
      } catch (e) {
        emit(RePrintQrError(error: e));
      }
    });
    on<Reset>((event, emit) async {
      emit(RePrintQrInitial());
    });
  }
}
