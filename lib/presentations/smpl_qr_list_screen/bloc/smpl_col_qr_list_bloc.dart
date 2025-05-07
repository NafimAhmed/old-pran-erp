import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/smpl_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class SmplQrListEvent {}

final class SmplQrListGet extends SmplQrListEvent {
  final String userId;

  SmplQrListGet({
    required this.userId,
  });
}

@immutable
sealed class SmplQrListState {}

final class SmplQrListInitial extends SmplQrListState {}

final class SmplQrListLoading extends SmplQrListState {}

final class SmplQrListSuccess extends SmplQrListState {
  final List<SampleColQr> smplQrList;

  SmplQrListSuccess({required this.smplQrList});
}

final class SmplQrListError extends SmplQrListState {
  final Object error;

  SmplQrListError({required this.error});
}

class SmplQrListBloc extends Bloc<SmplQrListEvent, SmplQrListState> {
  final DataRepo _dataService;
  List<SampleColQr> _smplQrList = [];
  SmplQrListBloc(this._dataService) : super(SmplQrListInitial()) {
    on<SmplQrListGet>((event, emit) async {
      emit(SmplQrListLoading());
      try {
        List<SampleColQr> response =
            await _dataService.getSmplColQrList(userId: event.userId);

        _smplQrList.clear();
        _smplQrList = response;
        emit(SmplQrListSuccess(smplQrList: _smplQrList));
      } catch (e) {
        emit(SmplQrListError(error: e));
      }
    });
  }
}
