import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_complete_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/core/utils/enums.dart';

@immutable
sealed class BatchCompActEvent {}

final class CompleteBatch extends BatchCompActEvent {
  final String userId;
  final int batchId;

  CompleteBatch({required this.userId, required this.batchId});
}

class BatchCompActState {
  final RequestStatus saveStatus;

  List<BatchCompData> batchCompData;
  final Object? error;

  BatchCompActState({
    this.saveStatus = RequestStatus.initial,

    this.batchCompData = const [],
    this.error,
  });

  BatchCompActState copyWith({
    RequestStatus? saveStatus,
    RequestStatus? fetchStatus,
    List<BatchCompData>? batchCompData,
    Object? error,
  }) {
    return BatchCompActState(
      saveStatus: saveStatus ?? this.saveStatus,

      batchCompData: batchCompData ?? this.batchCompData,
      error: error,
    );
  }
}

class BatchCompActBloc extends Bloc<BatchCompActEvent, BatchCompActState> {
  final DataRepo _dataService;
  BatchCompActBloc(this._dataService) : super(BatchCompActState()) {
    on<CompleteBatch>((event, emit) async {
      emit(state.copyWith(saveStatus: RequestStatus.loading));
      try {
        await _dataService.completeBatch(
          userId: event.userId,
          batchid: event.batchId,
        );
        emit(state.copyWith(saveStatus: RequestStatus.success));
      } catch (e) {
        emit(state.copyWith(saveStatus: RequestStatus.failure, error: e));
      }
    });
  }
}
