import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_on_hand_qty_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnOnHandQtyEvent {}

final class GrnOnHandQtyGet extends GrnOnHandQtyEvent {
  final String lotNo;

  GrnOnHandQtyGet({required this.lotNo});
}

final class GrnOnHandQtyReset extends GrnOnHandQtyEvent {
  GrnOnHandQtyReset();
}

class GrnOnHandQtyState extends BaseState {
  final GrnQrOnhandQty? onHandQty;
  GrnOnHandQtyState({
    super.isLoading = false,
    super.error,
    super.isSuccess = false,
    this.onHandQty,
  });

  GrnOnHandQtyState copyWith({
    bool? isLoading,
    Object? error,
    bool? isSuccess,
    GrnQrOnhandQty? onHandQty,
  }) {
    return GrnOnHandQtyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      onHandQty: onHandQty ?? this.onHandQty,
    );
  }
}

class GrnOnHandQtyBloc extends Bloc<GrnOnHandQtyEvent, GrnOnHandQtyState> {
  final DataRepo _dataRepo;
  GrnOnHandQtyBloc(this._dataRepo) : super(GrnOnHandQtyState()) {
    on<GrnOnHandQtyGet>((event, emit) async {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));
      try {
        var response = await _dataRepo.getGrnQrOnHandQty(lotNo: event.lotNo);
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            onHandQty: response,
            error: null,
          ),
        );
      } catch (error) {
        emit(state.copyWith(isLoading: false, isSuccess: false, error: error));
      }
    });
    on<GrnOnHandQtyReset>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: null,
          onHandQty: null,
        ),
      );
    });
  }
}
