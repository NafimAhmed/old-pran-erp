import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/core/utils/enums.dart';

@immutable
sealed class OutChalanItemEvent {}

final class AddChalanItem extends OutChalanItemEvent {
  final String userId;
  final UserBatchQrData item;

  AddChalanItem({required this.userId, required this.item});
}

final class RemoveChalanItem extends OutChalanItemEvent {
  final UserBatchQrData item;
  RemoveChalanItem({required this.item});
}

class OutChalanItemState {
  final RequestStatus saveChalan;
  final List<UserBatchQrData> chalanItems;
  final Object? error;

  OutChalanItemState({
    this.saveChalan = RequestStatus.initial,
    this.chalanItems = const [],
    this.error,
  });

  OutChalanItemState copyWith({
    RequestStatus? saveChalan,
    List<UserBatchQrData>? chalanItems,
    Object? error,
  }) {
    return OutChalanItemState(
      chalanItems: chalanItems ?? this.chalanItems,
      saveChalan: saveChalan ?? this.saveChalan,
      error: error,
    );
  }
}

class OutChalanItemBloc extends Bloc<OutChalanItemEvent, OutChalanItemState> {
  final DataRepo _dataService;
  List<UserBatchQrData> _chalanItems = [];
  OutChalanItemBloc(this._dataService) : super(OutChalanItemState()) {
    on<AddChalanItem>((event, emit) async {
      try {
        _chalanItems.add(event.item);

        emit(state.copyWith(chalanItems: _chalanItems, error: null));
      } catch (e) {
        emit(state.copyWith(error: e));
      }
    });
  }
}
