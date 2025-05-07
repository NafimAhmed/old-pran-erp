import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class CompBatchEvent {}

final class BatchComplete extends CompBatchEvent {
  final String userId;
  final String batchId;

  BatchComplete({required this.userId, required this.batchId});
}

@immutable
sealed class CompBatchState {}

final class CompBatchInitial extends CompBatchState {}

final class CompBatchLoading extends CompBatchState {}

final class CompBatchSuccess extends CompBatchState {}

final class CompBatchError extends CompBatchState {
  final Object error;

  CompBatchError({required this.error});
}

class CompBatchBloc extends Bloc<CompBatchEvent, CompBatchState> {
  final DataRepo _dataService;
  CompBatchBloc(this._dataService) : super(CompBatchInitial()) {
    on<BatchComplete>((event, emit) async {
      emit(CompBatchLoading());
      try {
        await _dataService.completeBatch(
          userId: event.userId,
          batchid: event.batchId,
        );
        emit(CompBatchSuccess());
      } catch (e) {
        emit(CompBatchError(error: e));
      }
    });
  }
}
