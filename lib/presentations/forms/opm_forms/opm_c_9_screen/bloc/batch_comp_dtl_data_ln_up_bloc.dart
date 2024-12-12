import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class BatchCompDtlLnUpdtEvent {}

final class GetBatchCompDtlLnUpdt extends BatchCompDtlLnUpdtEvent {
  final String userId;
  final String mtldtlid;
  final String madeqty;
  final int selectedIndex;
  GetBatchCompDtlLnUpdt({
    required this.userId,
    required this.mtldtlid,
    required this.madeqty,
    required this.selectedIndex,
  });
}

@immutable
sealed class BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtInitial extends BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtLoading extends BatchCompDtlLnUpdtState {}

final class BatchCompDtlLnUpdtSuccess extends BatchCompDtlLnUpdtState {
  final int selectedIndex;
  final num madeQty;
  BatchCompDtlLnUpdtSuccess(
      {required this.selectedIndex, required this.madeQty});
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
        emit(BatchCompDtlLnUpdtSuccess(
            selectedIndex: event.selectedIndex,
            madeQty: num.parse(event.madeqty)));
      } catch (e) {
        emit(BatchCompDtlLnUpdtError(error: e));
      }
    });
  }
}
