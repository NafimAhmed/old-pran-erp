import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class LovEvent {}

final class LovGet extends LovEvent {}

final class LovChanged extends LovEvent {
  final Lov selectedLov;

  LovChanged({required this.selectedLov});
}

@immutable
sealed class LovState {}

final class LovInitial extends LovState {}

final class LovLoading extends LovState {}

final class LovLoaded extends LovState {
  final List<Lov> lovList;
  final Lov? selectedLov;

  LovLoaded({required this.lovList, required this.selectedLov});
}

final class LovError extends LovState {
  final Object error;

  LovError({required this.error});
}

class LovBloc extends Bloc<LovEvent, LovState> {
  final DataService _dataService;
  List<Lov> _lovList = [];
  Lov? _selectedLov;
  LovBloc(this._dataService) : super(LovInitial()) {
    on<LovGet>((event, emit) async {
      emit(LovLoading());
      try {
        var response = await _dataService.getLov();
        _lovList.clear();
        _lovList = response;
        emit(LovLoaded(lovList: _lovList, selectedLov: _selectedLov));
      } catch (error) {
        emit(LovError(error: error));
      }
    });
    on<LovChanged>((event, emit) async {
      _selectedLov = event.selectedLov;
      emit(LovLoaded(lovList: _lovList, selectedLov: _selectedLov));
    });
  }
}
