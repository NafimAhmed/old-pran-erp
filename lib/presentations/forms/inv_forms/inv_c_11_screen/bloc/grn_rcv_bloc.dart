import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnRcvEvent {}

final class GrnRcv extends GrnRcvEvent {
  final String userId;
  final int orgId;
  final int itemId;
  final String locId;
  final String lotNo;

  GrnRcv({
    required this.userId,
    required this.orgId,
    required this.itemId,
    required this.locId,
    required this.lotNo,
  });
}

class GrnRcvState extends BaseState {
  GrnRcvState({super.isLoading = false, super.error, super.isSuccess = false});

  GrnRcvState copyWith({bool? isLoading, Object? error, bool? isSuccess}) {
    return GrnRcvState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class GrnRcvBloc extends Bloc<GrnRcvEvent, GrnRcvState> {
  final DataRepo _dataRepo;
  GrnRcvBloc(this._dataRepo) : super(GrnRcvState()) {
    on<GrnRcv>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await _dataRepo.grnRcv(
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
