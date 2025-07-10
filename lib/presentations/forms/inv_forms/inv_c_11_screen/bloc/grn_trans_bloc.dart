import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnTranEvent {}

final class GrnTransfer extends GrnTranEvent {
  final String userId;
  final int orgId;
  final int itemId;
  final String locId;
  final String lotNo;

  GrnTransfer({
    required this.userId,
    required this.orgId,
    required this.itemId,
    required this.locId,
    required this.lotNo,
  });
}

class GrnTranState extends BaseState {
  GrnTranState({super.isLoading = false, super.error, super.isSuccess = false});

  GrnTranState copyWith({bool? isLoading, Object? error, bool? isSuccess}) {
    return GrnTranState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class GrnTranBloc extends Bloc<GrnTranEvent, GrnTranState> {
  final DataRepo _dataRepo;
  GrnTranBloc(this._dataRepo) : super(GrnTranState()) {
    on<GrnTransfer>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await _dataRepo.grnTransfer(
          userId: event.userId,
          orgId: event.orgId,
          itemId: event.itemId,
          locId: event.locId,
          lotNo: event.lotNo,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (error) {
        emit(state.copyWith(isLoading: false, isSuccess: false, error: error));
      }
    });
  }
}
