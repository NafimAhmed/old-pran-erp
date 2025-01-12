import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JoInfoEvent {}

final class GetJoInfo extends JoInfoEvent {
  final String userId;

  GetJoInfo({required this.userId});
}

@immutable
sealed class JoInfoState {}

final class JoInfoInitial extends JoInfoState {}

final class JoInfoLoading extends JoInfoState {}

final class JoInfoSuccess extends JoInfoState {
  final List<JoInfo> joInfoList;

  JoInfoSuccess({required this.joInfoList});
}

final class JoInfoError extends JoInfoState {
  final Object error;

  JoInfoError({required this.error});
}

class JoInfoBloc extends Bloc<JoInfoEvent, JoInfoState> {
  final DataService _dataService;
  JoInfoBloc(this._dataService) : super(JoInfoInitial()) {
    on<GetJoInfo>((event, emit) async {
      emit(JoInfoLoading());
      try {
        var response = await _dataService.getJoList(userid: event.userId);
        emit(JoInfoSuccess(joInfoList: response));
      } catch (e) {
        emit(JoInfoError(error: e));
      }
    });
  }
}
