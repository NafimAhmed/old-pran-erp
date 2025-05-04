import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/smpl_qr_list_response.dart';

@immutable
sealed class SmplItemQrState {}

final class SmplItemQrDataLoaded extends SmplItemQrState {
  final SampleColQr sampleColQr;

  SmplItemQrDataLoaded({required this.sampleColQr});
}

final class SmplItemQrDataError extends SmplItemQrState {
  final Object error;

  SmplItemQrDataError({required this.error});
}

final class SmplItemQrInitial extends SmplItemQrState {}

class SmplItemQrCubit extends Cubit<SmplItemQrState> {
  SmplItemQrCubit() : super(SmplItemQrInitial());
  void setItemData({required String smplItemQrData}) {
    try {
      var list = smplItemQrData.split("\n");
      SampleColQr sampleColQr = SampleColQr();
      sampleColQr = sampleColQr.copyWith(
        id: int.parse(list[3]),
        itemName: list[0],
        qty: num.parse(list[1]),
        unit: list[2],
      );

      emit(SmplItemQrDataLoaded(sampleColQr: sampleColQr));
    } catch (error) {
      emit(SmplItemQrDataError(error: error));
    }
  }

  void resetItemData() {
    emit(SmplItemQrInitial());
  }
}
