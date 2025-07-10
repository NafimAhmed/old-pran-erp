import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class GrnIssueEvent {}

final class GrnIssue extends GrnIssueEvent {
  final String userId;
  final int orgId;
  final int itemId;
  final String locId;
  final String lotNo;

  GrnIssue({
    required this.userId,
    required this.orgId,
    required this.itemId,
    required this.locId,
    required this.lotNo,
  });
}

class GrnIssueState extends BaseState {
  GrnIssueState({
    super.isLoading = false,
    super.error,
    super.isSuccess = false,
  });

  GrnIssueState copyWith({bool? isLoading, Object? error, bool? isSuccess}) {
    return GrnIssueState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class GrnIssueBloc extends Bloc<GrnIssueEvent, GrnIssueState> {
  final DataRepo _dataRepo;
  GrnIssueBloc(this._dataRepo) : super(GrnIssueState()) {
    on<GrnIssue>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await _dataRepo.grnIssue(
          userId: event.userId,
          orgId: event.orgId,
          itemId: event.itemId,
          locId: event.locId,
          lotNo: event.lotNo,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (error) {
        emit(state.copyWith(isLoading: false, isSuccess: false, error: error));
      }
    });
  }
}
