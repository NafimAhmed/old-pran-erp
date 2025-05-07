import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class JoListEvent {}

final class GetJoList extends JoListEvent {
  final String userId;

  GetJoList({required this.userId});
}

@immutable
sealed class JoListState {}

final class JoListInitial extends JoListState {}

final class JoListLoading extends JoListState {}

final class JoListSuccess extends JoListState {
  final List<JoInfo> joInfoList;

  JoListSuccess({required this.joInfoList});
}

final class JoListError extends JoListState {
  final Object error;

  JoListError({required this.error});
}

class JoListBloc extends Bloc<JoListEvent, JoListState> {
  final DataRepo _dataService;
  JoListBloc(this._dataService) : super(JoListInitial()) {
    on<GetJoList>((event, emit) async {
      emit(JoListLoading());
      try {
        var response = await _dataService.getJoList(userid: event.userId);
        emit(JoListSuccess(joInfoList: response));
      } catch (e) {
        emit(JoListError(error: e));
      }
    });
  }
}
