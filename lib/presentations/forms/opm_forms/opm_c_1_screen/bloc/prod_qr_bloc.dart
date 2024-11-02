import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class ProdQrEvent {}

final class ProdQrDataGet extends ProdQrEvent {
  final String qrData;

  ProdQrDataGet({required this.qrData});
}

final class ProdQrDataReset extends ProdQrEvent {}

@immutable
sealed class ProdQrState {}

final class ProdQrInitial extends ProdQrState {}

final class ProdQrLoaded extends ProdQrState {
  final String batchId;
  final String itemId;
  ProdQrLoaded({required this.batchId, required this.itemId});
}

final class ProdQrError extends ProdQrState {
  final Object error;

  ProdQrError({required this.error});
}

class ProdQrBloc extends Bloc<ProdQrEvent, ProdQrState> {
  ProdQrBloc() : super(ProdQrInitial()) {
    on<ProdQrDataGet>((event, emit) {
      try {
        var list = event.qrData.split("\n");
        list.removeWhere(
          (element) => element == "",
        );
        var targetDatalist = list[0].split(",");
        emit(ProdQrLoaded(
            batchId: targetDatalist[0], itemId: targetDatalist[1]));
      } catch (e) {
        emit(ProdQrError(error: e));
      }
    });
    on<ProdQrDataReset>((event, emit) {
      emit(ProdQrInitial());
    });
  }
}
