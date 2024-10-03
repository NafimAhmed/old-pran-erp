import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class QrCodeEvent {}

final class QrCodeDataGet extends QrCodeEvent {
  final String sourceQrData;
  final String destinationQrData;

  QrCodeDataGet({required this.sourceQrData, required this.destinationQrData});
}

@immutable
sealed class QrCodeState {}

final class QrCodeInitial extends QrCodeState {}

final class QrCodeError extends QrCodeState {
  final Object error;

  QrCodeError({required this.error});
}

final class QrCodeLoaded extends QrCodeState {
  final Map<String, dynamic> sourceQrData;
  final Map<String, dynamic> destinationQrData;

  QrCodeLoaded({required this.sourceQrData, required this.destinationQrData});
}

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  Map<String, dynamic> _sourceQrData = {};
  Map<String, dynamic> _destinationQrData = {};
  QrCodeBloc() : super(QrCodeInitial()) {
    on<QrCodeDataGet>((event, emit) {
      try {
        if (event.sourceQrData.isNotEmpty) {
          _sourceQrData.clear();
          _sourceQrData = json.decode(event.sourceQrData);
        }
        if (event.destinationQrData.isNotEmpty) {
          _destinationQrData.clear();
          _destinationQrData = json.decode(event.destinationQrData);
        }
        emit(
          QrCodeLoaded(
            sourceQrData: _sourceQrData,
            destinationQrData: _destinationQrData,
          ),
        );
      } catch (e) {
        emit(QrCodeError(error: e));
      }
    });
  }
}
