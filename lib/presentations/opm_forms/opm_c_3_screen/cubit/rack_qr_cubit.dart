import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class RackQrState {}

final class RackQrDataLoaded extends RackQrState {
  final List<String> rackQRDatalist;

  RackQrDataLoaded({required this.rackQRDatalist});
}

final class RackQrDataError extends RackQrState {
  final Object error;

  RackQrDataError({required this.error});
}

final class RackQrInitial extends RackQrState {}

class RackQrCubit extends Cubit<RackQrState> {
  RackQrCubit() : super(RackQrInitial());
  void setrackData({required String rackQrData}) {
    try {
      var list = rackQrData.split("\n");
      list.removeWhere(
        (element) => element == "",
      );
      var rackQRDatalist = list[0].split(",");

      emit(RackQrDataLoaded(rackQRDatalist: rackQRDatalist));
    } catch (error) {
      emit(RackQrDataError(error: error));
    }
  }

  void resetRackData() {
    emit(RackQrInitial());
  }
}
