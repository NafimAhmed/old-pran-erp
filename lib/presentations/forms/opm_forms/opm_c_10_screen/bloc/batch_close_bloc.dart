import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class BatchCloseEvent {}

final class CloseBatch extends BatchCloseEvent {
  final String userId;
  final int batchId;
  CloseBatch({
    required this.userId,
    required this.batchId,
  });
}

@immutable
sealed class BatchCloseState {}

final class BatchCloseInitial extends BatchCloseState {}

final class BatchCloseLoading extends BatchCloseState {
  final int batchId;

  BatchCloseLoading({required this.batchId});
}

final class BatchCloseSuccess extends BatchCloseState {
  BatchCloseSuccess();
}

final class BatchCloseError extends BatchCloseState {
  final Object error;

  BatchCloseError({required this.error});
}

class BatchCloseBloc extends Bloc<BatchCloseEvent, BatchCloseState> {
  final DataService _dataService;
  BatchCloseBloc(this._dataService) : super(BatchCloseInitial()) {
    on<CloseBatch>((event, emit) async {
      emit(BatchCloseLoading(batchId: event.batchId));
      try {
        await _dataService.batchClose(
            userId: event.userId, batchid: event.batchId);
        emit(BatchCloseSuccess());
      } catch (e) {
        emit(BatchCloseError(error: e));
      }
    });
  }
}
