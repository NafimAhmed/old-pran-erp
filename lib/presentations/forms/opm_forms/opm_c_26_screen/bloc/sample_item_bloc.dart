import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_26_screen/model/sample_item.dart';

@immutable
sealed class SampleItemEvent {}

final class SampleItemAdd extends SampleItemEvent {
  final SampleItem sampleItem;

  SampleItemAdd({
    required this.sampleItem,
  });
}

final class SampleItemRemove extends SampleItemEvent {
  final SampleItem sampleItem;

  SampleItemRemove({
    required this.sampleItem,
  });
}

final class SampleItemUpdate extends SampleItemEvent {
  final SampleItem sampleItem;

  SampleItemUpdate({
    required this.sampleItem,
  });
}

final class SampleItemClearAll extends SampleItemEvent {}

@immutable
sealed class SampleItemState {}

final class SampleItemInitial extends SampleItemState {}

final class SampleItemLoading extends SampleItemState {}

final class SampleItemSuccess extends SampleItemState {
  final List<SampleItem> sampleItem;

  SampleItemSuccess({required this.sampleItem});
}

final class SampleItemError extends SampleItemState {
  final Object error;

  SampleItemError({required this.error});
}

class SampleItemBloc extends Bloc<SampleItemEvent, SampleItemState> {
  SampleItemBloc() : super(SampleItemInitial()) {
    List<SampleItem> sampleItem = List.empty(growable: true);
    on<SampleItemAdd>((event, emit) async {
      try {
        sampleItem.add(event.sampleItem);
        emit(SampleItemSuccess(sampleItem: sampleItem));
      } catch (e) {
        emit(SampleItemError(error: e));
      }
    });
    on<SampleItemRemove>((event, emit) async {
      try {
        sampleItem.remove(event.sampleItem);
        emit(SampleItemSuccess(sampleItem: sampleItem));
      } catch (e) {
        emit(SampleItemError(error: e));
      }
    });
    on<SampleItemUpdate>((event, emit) async {
      try {
        final index = sampleItem.indexWhere(
          (item) => item.itemCode == event.sampleItem.itemCode,
        );

        if (index != -1) {
          sampleItem[index] = event.sampleItem;
          emit(SampleItemSuccess(
              sampleItem:
                  List.from(sampleItem))); // Important: new list instance
        } else {
          emit(SampleItemError(error: 'Item not found'));
        }
      } catch (e) {
        emit(SampleItemError(error: e.toString()));
      }
    });
    on<SampleItemClearAll>((event, emit) async {
      try {
        sampleItem.clear();
        emit(SampleItemSuccess(sampleItem: sampleItem));
      } catch (e) {
        emit(SampleItemError(error: e));
      }
    });
  }
}
