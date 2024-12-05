import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

@immutable
sealed class BatchCompDtlLnUpdtEvent {}

final class GetBatchCompDtlLnUpdt extends BatchCompDtlLnUpdtEvent {
  final String userId;
  final String mtldtlid;
  final String madeqty;
  final DataGridCellTapDetails details;
  GetBatchCompDtlLnUpdt({
    required this.userId,
    required this.mtldtlid,
    required this.madeqty,
    required this.details,
  });
}

@immutable
sealed class BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtInitial extends BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtLoading extends BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtSuccess extends BatchCompDtlLnUpdtState {
  final DataGridCellTapDetails details;

  BatchCompDtlLnUpdtSuccess({required this.details});
}

final class BatchCompDtlLnUpdtError extends BatchCompDtlLnUpdtState {
  final Object error;

  BatchCompDtlLnUpdtError({required this.error});
}

class BatchCompDtlLnUpdtBloc
    extends Bloc<BatchCompDtlLnUpdtEvent, BatchCompDtlLnUpdtState> {
  final DataService _dataService;
  BatchCompDtlLnUpdtBloc(this._dataService)
      : super(BatchCompDtlLnUpdtInitial()) {
    on<GetBatchCompDtlLnUpdt>((event, emit) async {
      emit(BatchCompDtlLnUpdtLoading());
      try {
        await _dataService.batchCompDtlDataLnUpdt(
            userId: event.userId,
            mtldtlid: event.mtldtlid,
            madeqty: event.madeqty);
        emit(BatchCompDtlLnUpdtSuccess(details: event.details));
      } catch (e) {
        emit(BatchCompDtlLnUpdtError(error: e));
      }
    });
  }
}
