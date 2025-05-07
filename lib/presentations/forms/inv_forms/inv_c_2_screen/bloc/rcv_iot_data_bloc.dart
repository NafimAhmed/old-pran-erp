import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class RcvIotDataEvent {}

final class GetRcvIotData extends RcvIotDataEvent {
  final String userId;

  GetRcvIotData({required this.userId});
}

@immutable
sealed class RcvIotDataState {}

final class RcvIotDataInitial extends RcvIotDataState {}

final class RcvIotDataLoading extends RcvIotDataState {}

final class RcvIotDataSuccess extends RcvIotDataState {
  final List<RcvIotData> rcvIotDataList;

  RcvIotDataSuccess({required this.rcvIotDataList});
}

final class RcvIotDataError extends RcvIotDataState {
  final Object error;

  RcvIotDataError({required this.error});
}

class RcvIotDataBloc extends Bloc<RcvIotDataEvent, RcvIotDataState> {
  final DataRepo _dataService;
  RcvIotDataBloc(this._dataService) : super(RcvIotDataInitial()) {
    on<GetRcvIotData>((event, emit) async {
      emit(RcvIotDataLoading());
      try {
        var response =
            await _dataService.getRcvInvOrgTrnData(userId: event.userId);
        emit(RcvIotDataSuccess(rcvIotDataList: response));
      } catch (e) {
        emit(RcvIotDataError(error: e));
      }
    });
  }
}
