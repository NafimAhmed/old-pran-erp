import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class SubInvEvent {}

final class SubInvGet extends SubInvEvent {
  final String orgId;

  SubInvGet({required this.orgId});
}

@immutable
sealed class SubInvState {}

final class SubInvInitial extends SubInvState {}

final class SubInvLoading extends SubInvState {}

final class SubInvSuccess extends SubInvState {
  final List<SubInvData> subInvList;

  SubInvSuccess({required this.subInvList});
}

final class SubInvError extends SubInvState {
  final Object error;

  SubInvError({required this.error});
}

class SubInvBloc extends Bloc<SubInvEvent, SubInvState> {
  final DataService _dataService;
  SubInvBloc(this._dataService) : super(SubInvInitial()) {
    on<SubInvGet>((event, emit) async {
      emit(SubInvLoading());
      try {
        var response = await _dataService.getSubInv(orgId: event.orgId);
        emit(SubInvSuccess(subInvList: response));
      } catch (e) {
        emit(SubInvError(error: e));
      }
    });
  }
}
