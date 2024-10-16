import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class ItemQrState {}

final class ItemQrDataLoaded extends ItemQrState {
  final List<String> itemQRDatalist;

  ItemQrDataLoaded({required this.itemQRDatalist});
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
      list.removeWhere(
        (element) => element == "",
      );
      var itemQRDatalist = list[0].split(",");

      emit(ItemQrDataLoaded(itemQRDatalist: itemQRDatalist));
    } catch (error) {
      emit(ItemQrDataError(error: error));
    }
  }

  void resetItemData() {
    emit(ItemQrInitial());
  }
}
