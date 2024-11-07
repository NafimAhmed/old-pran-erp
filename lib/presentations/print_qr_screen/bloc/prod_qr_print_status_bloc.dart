import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ProdQrPrintStatusEvent {}

final class ProdQrPrintStatusUpdate extends ProdQrPrintStatusEvent {
  final String trnlotno;

  ProdQrPrintStatusUpdate({required this.trnlotno});
}

@immutable
sealed class ProdQrPrintStatusState {}

final class ProdPrintStatusInitial extends ProdQrPrintStatusState {}

final class ProdPrintStatusLoading extends ProdQrPrintStatusState {}

final class ProdPrintStatusSuccess extends ProdQrPrintStatusState {}

final class ProdPrintStatusError extends ProdQrPrintStatusState {
  final Object error;

  ProdPrintStatusError({required this.error});
}

class ProdQrPrintStatusBloc
    extends Bloc<ProdQrPrintStatusEvent, ProdQrPrintStatusState> {
  final DataService _dataService;
  ProdQrPrintStatusBloc(this._dataService) : super(ProdPrintStatusInitial()) {
    on<ProdQrPrintStatusUpdate>((event, emit) async {
      emit(ProdPrintStatusLoading());
      try {
        await _dataService.updateProdQrPrintStatus(trnlotno: event.trnlotno);
      } catch (e) {
        emit(ProdPrintStatusError(error: e));
      }
    });
  }
}
