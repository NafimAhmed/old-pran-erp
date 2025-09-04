import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_complete_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/core/utils/enums.dart';

@immutable
sealed class BatchCompListEvent {}

final class GetBatchCompData extends BatchCompListEvent {
  final String userId;

  GetBatchCompData({required this.userId});
}

class BatchCompListState {
  final RequestStatus fetchStatus;
  List<BatchCompData> batchCompData;
  final Object? error;

  BatchCompListState({
    this.fetchStatus = RequestStatus.initial,
    this.batchCompData = const [],
    this.error,
  });

  BatchCompListState copyWith({
    RequestStatus? saveStatus,
    RequestStatus? fetchStatus,
    List<BatchCompData>? batchCompData,
    Object? error,
  }) {
    return BatchCompListState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      batchCompData: batchCompData ?? this.batchCompData,
      error: error,
    );
  }
}

class BatchCompListBloc extends Bloc<BatchCompListEvent, BatchCompListState> {
  final DataRepo _dataService;
  BatchCompListBloc(this._dataService) : super(BatchCompListState()) {
    on<GetBatchCompData>((event, emit) async {
      emit(state.copyWith(fetchStatus: RequestStatus.loading));
      try {
        var response = await _dataService.getBatchCompData(
          userId: event.userId,
        );

        emit(
          state.copyWith(
            fetchStatus: RequestStatus.success,
            batchCompData: response,
          ),
        );
      } catch (e) {
        emit(state.copyWith(fetchStatus: RequestStatus.failure, error: e));
      }
    });
  }
}
