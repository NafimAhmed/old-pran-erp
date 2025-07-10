import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';

@immutable
sealed class GrnItemQrState {}

final class GrnItemQrDataLoaded extends GrnItemQrState {
  final GrnQr grnQr;

  GrnItemQrDataLoaded({required this.grnQr});
}

final class GrnItemQrDataError extends GrnItemQrState {
  final Object error;

  GrnItemQrDataError({required this.error});
}

final class GrnItemQrInitial extends GrnItemQrState {}

class GrnItemQrCubit extends Cubit<GrnItemQrState> {
  GrnItemQrCubit() : super(GrnItemQrInitial());
  void setItemData({required String grnItemQrData}) {
    try {
      var list = grnItemQrData.split("\n");
      GrnQr grnQr = GrnQr();
      grnQr = grnQr.copyWith(
        trnid: list[0],
        orgId: int.parse(list[1]),
        qty: num.parse(list[2]),
        inventoryItemId: int.parse(list[3]),
        itemCode: list[4].split("-")[0],
        itemName: list[4].split("-")[1],
        subInv: list[5],
        locatorDesc: list[6],
        locatorId: int.parse(list[7]),
      );

      emit(GrnItemQrDataLoaded(grnQr: grnQr));
    } catch (error) {
      emit(GrnItemQrDataError(error: error));
    }
  }

  void resetItemData() {
    emit(GrnItemQrInitial());
  }
}
