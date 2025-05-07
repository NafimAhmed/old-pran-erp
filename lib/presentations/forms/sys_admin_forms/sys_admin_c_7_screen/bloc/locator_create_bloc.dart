import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class LocatorEvent {}

final class CreateLocator extends LocatorEvent {
  final String userId;
  final String orgId;
  final String pSubInv;
  final String pRow;
  final String pRack;
  final String pBeen;
  final String pDesc;

  CreateLocator(
      {required this.userId,
      required this.orgId,
      required this.pSubInv,
      required this.pRow,
      required this.pRack,
      required this.pBeen,
      required this.pDesc});
}

@immutable
sealed class LocatorState {}

final class LocatorInitial extends LocatorState {}

final class LocatorLoading extends LocatorState {}

final class LocatorSuccess extends LocatorState {}

final class LocatorError extends LocatorState {
  final Object error;

  LocatorError({required this.error});
}

class LocatorBloc extends Bloc<LocatorEvent, LocatorState> {
  final DataRepo _dataService;
  LocatorBloc(this._dataService) : super(LocatorInitial()) {
    on<CreateLocator>((event, emit) async {
      emit(LocatorLoading());
      try {
        await _dataService.createLocator(
            userId: event.userId,
            orgId: event.orgId,
            pSubInv: event.pSubInv,
            pRow: event.pRow,
            pRack: event.pRack,
            pBeen: event.pBeen,
            pDesc: event.pDesc);
        emit(LocatorSuccess());
      } catch (e) {
        emit(LocatorError(error: e));
      }
    });
  }
}
