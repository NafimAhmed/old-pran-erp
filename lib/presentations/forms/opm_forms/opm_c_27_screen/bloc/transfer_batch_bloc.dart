import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class SmplItemRcvEvent {}

final class SmplItemRcv extends SmplItemRcvEvent {
  final int id;
  final String rackId;

  SmplItemRcv({
    required this.id,
    required this.rackId,
  });
}

@immutable
sealed class SmplItemRcvState {}

final class SmplItemRcvInitial extends SmplItemRcvState {}

final class SmplItemRcvLoading extends SmplItemRcvState {}

final class SmplItemRcvSuccess extends SmplItemRcvState {}

final class SmplItemRcvError extends SmplItemRcvState {
  final Object error;

  SmplItemRcvError({required this.error});
}

class SmplItemRcvBloc extends Bloc<SmplItemRcvEvent, SmplItemRcvState> {
  final DataRepo _dataService;
  SmplItemRcvBloc(this._dataService) : super(SmplItemRcvInitial()) {
    on<SmplItemRcv>((event, emit) async {
      emit(SmplItemRcvLoading());
      try {
        await _dataService.smplItemRcv(
          id: event.id,
          rackId: event.rackId,
        );
        emit(SmplItemRcvSuccess());
      } catch (error) {
        emit(SmplItemRcvError(error: error));
      }
    });
  }
}
