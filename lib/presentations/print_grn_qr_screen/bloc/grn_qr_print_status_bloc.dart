import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class GrnQrPrintStatusEvent {}

final class GrnQrPrintStatusUpdate extends GrnQrPrintStatusEvent {
  final String trnlotno;

  GrnQrPrintStatusUpdate({required this.trnlotno});
}

@immutable
sealed class GrnQrPrintStatusState {}

final class GrnPrintStatusInitial extends GrnQrPrintStatusState {}

final class GrnPrintStatusLoading extends GrnQrPrintStatusState {}

final class GrnPrintStatusSuccess extends GrnQrPrintStatusState {}

final class GrnPrintStatusError extends GrnQrPrintStatusState {
  final Object error;

  GrnPrintStatusError({required this.error});
}

class GrnQrPrintStatusBloc
    extends Bloc<GrnQrPrintStatusEvent, GrnQrPrintStatusState> {
  final DataService _dataService;
  GrnQrPrintStatusBloc(this._dataService) : super(GrnPrintStatusInitial()) {
    on<GrnQrPrintStatusUpdate>((event, emit) async {
      emit(GrnPrintStatusLoading());
      try {
        // await _dataService.updateGrnQrPrintStatus(trnlotno: event.trnlotno);
      } catch (e) {
        emit(GrnPrintStatusError(error: e));
      }
    });
  }
}
