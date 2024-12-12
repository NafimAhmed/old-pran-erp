import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';

@immutable
sealed class ItemQrState {}

final class ItemQrDataLoaded extends ItemQrState {
  final UserBatchQrData userBatchQrData;

  ItemQrDataLoaded({required this.userBatchQrData});
}

final class ItemQrDataError extends ItemQrState {
  final Object error;

  ItemQrDataError({required this.error});
}

final class ItemQrInitial extends ItemQrState {}

class ItemQrCubit extends Cubit<ItemQrState> {
  ItemQrCubit() : super(ItemQrInitial());
  void setItemData({required String itemQrData}) {
    try {
      var list = itemQrData.split("\n");
      var userBatchQrData = UserBatchQrData.fromJson(list.last);
      emit(ItemQrDataLoaded(userBatchQrData: userBatchQrData));
    } catch (error) {
      emit(ItemQrDataError(error: error));
    }
  }

  void resetItemData() {
    emit(ItemQrInitial());
  }
}
