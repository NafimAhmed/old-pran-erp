import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class SubInvListEvent {}

final class SubInvListGet extends SubInvListEvent {
  final int orgId;
  final int itemId;
  SubInvListGet({required this.orgId, required this.itemId});
}

final class SubInvListSelect extends SubInvListEvent {
  final SubInventory selectedValue;
  SubInvListSelect({required this.selectedValue});
}

final class SubInvListDeselect extends SubInvListEvent {
  SubInvListDeselect();
}

class SubInvListState {
  final bool isLoading;
  final Object? error;
  final bool isSuccess;
  final SubInventory? selectedValue;
  final List<SubInventory> subInvList;

  SubInvListState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.selectedValue,
    this.subInvList = const [],
  });
  SubInvListState copyWith({
    bool? isLoading,
    Object? error,
    bool? isSuccess,
    SubInventory? selectedValue,
    List<SubInventory>? subInvList,
  }) => SubInvListState(
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    isSuccess: isSuccess ?? this.isSuccess,
    selectedValue: selectedValue,
    subInvList: subInvList ?? this.subInvList,
  );
}

class SubInvListBloc extends Bloc<SubInvListEvent, SubInvListState> {
  final DataRepo _dataRepo;
  List<SubInventory>? _subInvList;
  SubInvListBloc(this._dataRepo) : super(SubInvListState()) {
    on<SubInvListGet>((event, emit) async {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));
      try {
        var response = await _dataRepo.getSubInventory(
          orgId: event.orgId,
          itemId: event.itemId,
        );
        _subInvList = response;
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            subInvList: _subInvList,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e, isSuccess: false));
      }
    });
    on<SubInvListSelect>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          error: null,
          selectedValue: event.selectedValue,
        ),
      );
    });
    on<SubInvListDeselect>((event, emit) async {
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
