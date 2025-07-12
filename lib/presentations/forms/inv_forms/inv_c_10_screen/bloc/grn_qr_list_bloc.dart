import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnQrListEvent {}

final class GrnQrListGet extends GrnQrListEvent {
  final String userId;
  final String qrType;
  GrnQrListGet({required this.userId, required this.qrType});
}

class GrnQrListState extends BaseState {
  final List<GrnQr>? grnQrList;

  GrnQrListState({
    super.isLoading = false,
    super.isSuccess = false,
    super.error,
    this.grnQrList,
  });

  GrnQrListState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Object? error,
    List<GrnQr>? grnQrList,
  }) {
    return GrnQrListState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      grnQrList: grnQrList ?? this.grnQrList,
    );
  }
}

class GrnQrListBloc extends Bloc<GrnQrListEvent, GrnQrListState> {
  final DataRepo _dataService;
  List<GrnQr>? _grnQr;

  GrnQrListBloc(this._dataService) : super(GrnQrListState()) {
    on<GrnQrListGet>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        var response = await _dataService.getGrnQrList(
          userId: event.userId,
          qrType: event.qrType,
        );
        _grnQr = response;
        emit(
          state.copyWith(isLoading: false, isSuccess: true, grnQrList: _grnQr),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: e,
            grnQrList: null,
          ),
        );
      }
    });
  }
}
