import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnQrSaveEvent {}

final class GrnQrSave extends GrnQrSaveEvent {
  final String userId;
  final int orgId;
  final int itemId;
  final num qty;
  final String locId;
  final String subInv;
  GrnQrSave({
    required this.userId,
    required this.orgId,
    required this.itemId,
    required this.qty,
    required this.locId,
    required this.subInv,
  });
}

class GrnQrSaveState extends BaseState {
  GrnQrSaveState({
    super.isLoading = false,
    super.error,
    super.isSuccess = false,
  });

  GrnQrSaveState copyWith({bool? isLoading, Object? error, bool? isSuccess}) {
    return GrnQrSaveState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class GrnQrSaveBloc extends Bloc<GrnQrSaveEvent, GrnQrSaveState> {
  final DataRepo _dataRepo;

  GrnQrSaveBloc(this._dataRepo) : super(GrnQrSaveState()) {
    on<GrnQrSave>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await _dataRepo.getGrnQrSave(
          userId: event.userId,
          orgId: event.orgId,
          itemId: event.itemId,

          qty: event.qty,
          locId: event.locId,
          subInv: event.subInv,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e));
      }
    });
  }
}
