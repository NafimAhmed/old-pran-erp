import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ProdRackTransactEvent {}

final class ProdRackTransact extends ProdRackTransactEvent {
  final int transactId;
  final String userId;
  ProdRackTransact({
    required this.transactId,
    required this.userId,
  });
}

@immutable
sealed class ProdRackTransactState {}

final class ProdRackTransactInitial extends ProdRackTransactState {}

final class ProdRackTransactLoading extends ProdRackTransactState {
  final int transactId;

  ProdRackTransactLoading({
    required this.transactId,
  });
}

final class ProdRackTransactSuccess extends ProdRackTransactState {}

final class ProdRackTransactError extends ProdRackTransactState {
  final Object error;

  ProdRackTransactError({required this.error});
}

class ProdRackTransactBloc
    extends Bloc<ProdRackTransactEvent, ProdRackTransactState> {
  final DataService _dataService;
  ProdRackTransactBloc(this._dataService) : super(ProdRackTransactInitial()) {
    on<ProdRackTransact>((event, emit) async {
      emit(ProdRackTransactLoading(transactId: event.transactId));
      try {
        await _dataService.rackTransfer(
          transactId: event.transactId,
          userId: event.userId,
        );
        emit(ProdRackTransactSuccess());
      } catch (error) {
        emit(ProdRackTransactError(error: error));
      }
    });
  }
}
