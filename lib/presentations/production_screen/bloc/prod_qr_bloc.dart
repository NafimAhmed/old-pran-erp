import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class ProdQrEvent {}

final class ProdQrDataGet extends ProdQrEvent {
  final String qrData;

  ProdQrDataGet({required this.qrData});
}

@immutable
sealed class ProdQrState {}

final class ProdQrInitial extends ProdQrState {}

final class ProdQrLoaded extends ProdQrState {
  final String locatorId;

  ProdQrLoaded({required this.locatorId});
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
        emit(ProdQrLoaded(locatorId: list.first));
      } catch (e) {
        emit(ProdQrError(error: e));
      }
    });
  }
}
