import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/opm_dash_sm_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class OpmDashSmEvent {}

final class GetOpmDashSm extends OpmDashSmEvent {
  final String userId;

  GetOpmDashSm({required this.userId});
}

@immutable
sealed class OpmDashSmState {}

final class OpmDashSmInitial extends OpmDashSmState {}

final class OpmDashSmLoading extends OpmDashSmState {}

final class OpmDashSmSuccess extends OpmDashSmState {
  final OpmDashSmResponse dashReport;

  OpmDashSmSuccess({required this.dashReport});
}

final class OpmDashSmError extends OpmDashSmState {
  final Object error;

  OpmDashSmError({required this.error});
}

class OpmDashSmBloc extends Bloc<OpmDashSmEvent, OpmDashSmState> {
  final DataService _dataService;
  OpmDashSmBloc(this._dataService) : super(OpmDashSmInitial()) {
    on<GetOpmDashSm>((event, emit) async {
      emit(OpmDashSmLoading());
      try {
        var response =
            await _dataService.getOpmDashboardSM(userid: event.userId);
        emit(OpmDashSmSuccess(dashReport: response));
      } catch (e) {
        emit(OpmDashSmError(error: e));
      }
    });
  }
}
