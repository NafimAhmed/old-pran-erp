import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_type_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class QrTypeListEvent {}

final class QrTypeListGet extends QrTypeListEvent {
  QrTypeListGet();
}

final class QrTypeListReset extends QrTypeListEvent {}

final class QrTypeListSelect extends QrTypeListEvent {
  final Qrtype selectedQrType;
  QrTypeListSelect({required this.selectedQrType});
}

class QrTypeListState extends BaseState {
  final List<Qrtype> qrTypeList;
  final Qrtype? selectedQrType;

  QrTypeListState({
    super.isLoading = false,
    super.isSuccess = false,
    super.error,
    this.selectedQrType,
    this.qrTypeList = const [],
  });

  QrTypeListState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Object? error,
    Qrtype? selectedQrType,
    List<Qrtype>? qrTypeList,
  }) {
    return QrTypeListState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      selectedQrType: selectedQrType,
      qrTypeList: qrTypeList ?? this.qrTypeList,
    );
  }
}

class QrTypeListBloc extends Bloc<QrTypeListEvent, QrTypeListState> {
  final DataRepo _dataService;
  List<Qrtype>? _qrType;

  QrTypeListBloc(this._dataService) : super(QrTypeListState()) {
    on<QrTypeListGet>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          selectedQrType: null,
          qrTypeList: [],
          isSuccess: false,
          error: null,
        ),
      );
      try {
        var response = await _dataService.getQrtype();
        _qrType = response;
        emit(
          state.copyWith(
            isLoading: false,
            selectedQrType: null,
            qrTypeList: _qrType,
            isSuccess: true,
            error: null,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            selectedQrType: null,
            qrTypeList: [],
            isSuccess: false,
            error: e,
          ),
        );
      }
    });
    on<QrTypeListSelect>((event, emit) async {
      emit(state.copyWith(selectedQrType: event.selectedQrType));
    });
    on<QrTypeListReset>((event, emit) async {
      emit(state.copyWith(selectedQrType: null));
    });
  }
}
