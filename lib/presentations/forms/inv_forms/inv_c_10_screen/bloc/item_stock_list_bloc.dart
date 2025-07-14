import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/item_stock_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/global_blocs/base_state.dart';

@immutable
sealed class ItemStockListEvent {}

final class ItemStockListGet extends ItemStockListEvent {
  final int orgId;

  ItemStockListGet({required this.orgId});
}

final class ItemStockListSelect extends ItemStockListEvent {
  final ItemStock value;

  ItemStockListSelect({required this.value});
}

final class ItemStockListDeselect extends ItemStockListEvent {}

class ItemStockListState extends BaseState {
  final ItemStock? selectedValue;
  final List<ItemStock>? itemStockList;

  ItemStockListState({
    super.isLoading = false,
    super.error,
    super.isSuccess = false,
    this.selectedValue,
    this.itemStockList,
  });
  ItemStockListState copyWith({
    bool? isLoading,
    Object? error,
    bool? isSuccess,
    ItemStock? selectedValue,
    List<ItemStock>? itemStockList,
  }) => ItemStockListState(
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    isSuccess: isSuccess ?? this.isSuccess,
    selectedValue: selectedValue,
    itemStockList: itemStockList ?? this.itemStockList,
  );
}

class ItemStockListBloc extends Bloc<ItemStockListEvent, ItemStockListState> {
  final DataRepo _dataRepo;
  List<ItemStock>? _itemStockList;
  ItemStockListBloc(this._dataRepo) : super(ItemStockListState()) {
    on<ItemStockListGet>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          isSuccess: false,
          itemStockList: null,
          selectedValue: null,
        ),
      );
      try {
        var response = await _dataRepo.getItemStock(orgId: event.orgId);
        _itemStockList = response;
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            itemStockList: _itemStockList,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e));
      }
    });
    on<ItemStockListSelect>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isSuccess: true,
            itemStockList: _itemStockList,
            selectedValue: event.value,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            itemStockList: null,
            selectedValue: null,
            error: e,
          ),
        );
      }
    });
    on<ItemStockListDeselect>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isSuccess: true,
            itemStockList: _itemStockList,
            selectedValue: null,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            itemStockList: null,
            selectedValue: null,
            error: e,
          ),
        );
      }
    });
  }
}
