import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class RackTransactEvent {}

final class RackTransact extends RackTransactEvent {
  final int transactId;

  RackTransact({required this.transactId});
}

@immutable
sealed class RackTransactState {}

final class RackTransactInitial extends RackTransactState {}

final class RackTransactLoading extends RackTransactState {
  final int transactId;

  RackTransactLoading({required this.transactId});
}

final class RackTransactSuccess extends RackTransactState {}

final class RackTransactError extends RackTransactState {
  final Object error;

  RackTransactError({required this.error});
}

class RackTransactBloc extends Bloc<RackTransactEvent, RackTransactState> {
  final DataService _dataService;
  RackTransactBloc(this._dataService) : super(RackTransactInitial()) {
    on<RackTransact>((event, emit) async {
      emit(RackTransactLoading(transactId: event.transactId));
      try {
        var response = await _dataService.rackTransfer(event.transactId);
        emit(RackTransactSuccess());
      } catch (error) {
        emit(RackTransactError(error: error));
      }
    });
  }
}
