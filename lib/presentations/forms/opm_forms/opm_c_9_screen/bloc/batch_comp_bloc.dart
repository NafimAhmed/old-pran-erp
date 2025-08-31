import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/batch_complete_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:sqflite/sqflite.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
sealed class BatchCompEvent {}

final class GetBatchCompData extends BatchCompEvent {
  final String userId;

  GetBatchCompData({required this.userId});
}

final class CompleteBatch extends BatchCompEvent {
  final String userId;
  final int batchId;

  CompleteBatch({required this.userId, required this.batchId});
}

final class ResetSaveStatus extends BatchCompEvent {}

class BatchCompState {
  final RequestStatus saveStatus;
  final RequestStatus fetchStatus;
  List<BatchCompData> batchCompData;
  final Object? error;

  BatchCompState({
    this.saveStatus = RequestStatus.initial,
    this.fetchStatus = RequestStatus.initial,
    this.batchCompData = const [],
    this.error,
  });

  BatchCompState copyWith({
    RequestStatus? saveStatus,
    RequestStatus? fetchStatus,
    List<BatchCompData>? batchCompData,
    Object? error,
  }) {
    return BatchCompState(
      saveStatus: saveStatus ?? this.saveStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      batchCompData: batchCompData ?? this.batchCompData,
      error: error,
    );
  }
}

class BatchCompBloc extends Bloc<BatchCompEvent, BatchCompState> {
  final DataRepo _dataService;
  // var response = [
  //   BatchCompData(
  //     batchId: 1,
  //     batchNo: "B001",
  //     batchStatus: "WIP",
  //     itemName: "Plastic Bottle",
  //     itemCode: "ITM001",
  //     orgCode: "ORG-A",
  //     organizationId: 101,
  //     batchQty: 500,
  //     madeQty: 200,
  //   ),
  //   BatchCompData(
  //     batchId: 2,
  //     batchNo: "B002",
  //     batchStatus: "Completed",
  //     itemName: "Glass Jar",
  //     itemCode: "ITM002",
  //     orgCode: "ORG-B",
  //     organizationId: 102,
  //     batchQty: 300,
  //     madeQty: 300,
  //   ),
  //   BatchCompData(
  //     batchId: 3,
  //     batchNo: "B003",
  //     batchStatus: "Pending",
  //     itemName: "Carton Box",
  //     itemCode: "ITM003",
  //     orgCode: "ORG-C",
  //     organizationId: 103,
  //     batchQty: 1000,
  //     madeQty: 0,
  //   ),
  //   BatchCompData(
  //     batchId: 4,
  //     batchNo: "B004",
  //     batchStatus: "In Progress",
  //     itemName: "Plastic Cap",
  //     itemCode: "ITM004",
  //     orgCode: "ORG-D",
  //     organizationId: 104,
  //     batchQty: 800,
  //     madeQty: 450,
  //   ),
  //   BatchCompData(
  //     batchId: 5,
  //     batchNo: "B005",
  //     batchStatus: "On Hold",
  //     itemName: "Label Sticker",
  //     itemCode: "ITM005",
  //     orgCode: "ORG-E",
  //     organizationId: 105,
  //     batchQty: 600,
  //     madeQty: 100,
  //   ),
  // ];
  BatchCompBloc(this._dataService) : super(BatchCompState()) {
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
    on<CompleteBatch>((event, emit) async {
      emit(state.copyWith(saveStatus: RequestStatus.loading));
      try {
        var response = await _dataService.completeBatch(
          userId: event.userId,
          batchid: event.batchId,
        );
        // response.removeWhere((element) => element.batchId == event.batchId);
        // await Future.delayed(const Duration(seconds: 5));
        emit(state.copyWith(saveStatus: RequestStatus.success));
      } catch (e) {
        emit(state.copyWith(saveStatus: RequestStatus.failure, error: e));
      }
    });
    on<ResetSaveStatus>((event, emit) async {
      emit(state.copyWith(saveStatus: RequestStatus.initial));
    });
  }
}
