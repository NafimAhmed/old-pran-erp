import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/locator_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class LocatorListEvent {}

final class LocatorListGet extends LocatorListEvent {
  final int orgId;
  final int itemId;
  final String subInvCode;
  LocatorListGet({
    required this.orgId,
    required this.itemId,
    required this.subInvCode,
  });
}

final class LocatorListSelect extends LocatorListEvent {
  final Locator selectedValue;
  LocatorListSelect({required this.selectedValue});
}

final class LocatorListDeselect extends LocatorListEvent {
  LocatorListDeselect();
}

class LocatorListState {
  final bool isLoading;
  final Object? error;
  final bool isSuccess;
  final Locator? selectedValue;
  final List<Locator> locatorList;

  LocatorListState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.selectedValue,
    this.locatorList = const [],
  });
  LocatorListState copyWith({
    bool? isLoading,
    Object? error,
    bool? isSuccess,
    Locator? selectedValue,
    List<Locator>? locatorList,
  }) => LocatorListState(
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    isSuccess: isSuccess ?? this.isSuccess,
    selectedValue: selectedValue,
    locatorList: locatorList ?? this.locatorList,
  );
}

class LocatorListBloc extends Bloc<LocatorListEvent, LocatorListState> {
  final DataRepo _dataRepo;
  List<Locator>? _locatorList;
  LocatorListBloc(this._dataRepo) : super(LocatorListState()) {
    on<LocatorListGet>((event, emit) async {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));
      try {
        var response = await _dataRepo.getLocator(
          orgId: event.orgId,
          itemId: event.itemId,
          subInvCode: event.subInvCode,
        );
        _locatorList = response;
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            locatorList: _locatorList,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e, isSuccess: false));
      }
    });
    on<LocatorListSelect>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          error: null,
          selectedValue: event.selectedValue,
        ),
      );
    });
    on<LocatorListDeselect>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          error: null,
          selectedValue: null,
        ),
      );
    });
  }
}
