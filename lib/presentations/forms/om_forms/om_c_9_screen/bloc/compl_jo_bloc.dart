import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ComplJoEvent {}

final class CompleteJo extends ComplJoEvent {
  final String userId;
  final String jobOrderNo;

  CompleteJo({
    required this.userId,
    required this.jobOrderNo,
  });
}

@immutable
sealed class ComplJoState {}

final class ComplJoInitial extends ComplJoState {}

final class ComplJoLoading extends ComplJoState {}

final class ComplJoSuccess extends ComplJoState {
  ComplJoSuccess();
}

final class ComplJoError extends ComplJoState {
  final Object error;

  ComplJoError({required this.error});
}

class ComplJoBloc extends Bloc<ComplJoEvent, ComplJoState> {
  final DataService _dataService;

  ComplJoBloc(this._dataService) : super(ComplJoInitial()) {
    on<CompleteJo>((event, emit) async {
      emit(ComplJoLoading());
      try {
        await _dataService.completeJO(
          userId: event.userId,
          jobOrderNo: event.jobOrderNo,
        );

        emit(ComplJoSuccess());
      } catch (e) {
        emit(ComplJoError(error: e));
      }
    });
  }
}
