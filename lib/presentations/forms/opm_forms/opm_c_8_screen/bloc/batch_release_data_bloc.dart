import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class BatchReleaseDataEvent {}

final class GetBatchReleaseData extends BatchReleaseDataEvent {
  final String userId;
  final String orgId;
  final String batchId;
  GetBatchReleaseData({
    required this.userId,
    required this.orgId,
    required this.batchId,
  });
}

@immutable
sealed class BatchReleaseDataState {}

final class BatchReleaseDataInitial extends BatchReleaseDataState {}

final class BatchReleaseDataLoading extends BatchReleaseDataState {}

final class BatchReleaseDataSuccess extends BatchReleaseDataState {
  final List<String> btchRelsDataList;

  BatchReleaseDataSuccess({required this.btchRelsDataList});
}

final class BatchReleaseDataError extends BatchReleaseDataState {
  final Object error;

  BatchReleaseDataError({required this.error});
}

class BatchReleaseDataBloc
    extends Bloc<BatchReleaseDataEvent, BatchReleaseDataState> {
  final DataService _dataService;
  BatchReleaseDataBloc(this._dataService) : super(BatchReleaseDataInitial()) {
    on<GetBatchReleaseData>((event, emit) async {
      emit(BatchReleaseDataLoading());
      try {
        var response = await _dataService.getBatchReleaseData(
            userId: event.userId, orgId: event.orgId, batchId: event.batchId);
        emit(BatchReleaseDataSuccess(btchRelsDataList: []));
      } catch (e) {
        emit(BatchReleaseDataError(error: e));
      }
    });
  }
}
