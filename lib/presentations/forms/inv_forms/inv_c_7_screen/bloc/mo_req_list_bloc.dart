import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/mo_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class MOReqListEvent {}

final class MOReqListGet extends MOReqListEvent {
  final String userId;
  final String searchValue;
  MOReqListGet({
    required this.userId,
    required this.searchValue,
  });
}

final class MOReqListFilter extends MOReqListEvent {
  final String searchValue;

  MOReqListFilter({required this.searchValue});
}

final class RemoveMOReqList extends MOReqListEvent {
  final int index;

  RemoveMOReqList({required this.index});
}

@immutable
sealed class MOReqListState {}

final class MOReqListInitial extends MOReqListState {}

final class MOReqListLoading extends MOReqListState {}

final class MOReqListSuccess extends MOReqListState {
  final List<MOReqTask> moReqList;

  MOReqListSuccess({required this.moReqList});
}

final class MOReqListError extends MOReqListState {
  final Object error;

  MOReqListError({required this.error});
}

class MOReqListBloc extends Bloc<MOReqListEvent, MOReqListState> {
  final DataRepo _dataService;
  List<MOReqTask> _moReqList = [];
  MOReqListBloc(this._dataService) : super(MOReqListInitial()) {
    on<MOReqListGet>((event, emit) async {
      emit(MOReqListLoading());
      try {
        var response = await _dataService.getMOReqList(
          userId: event.userId,
        );
        _moReqList = response;

        if (event.searchValue.isNotEmpty) {
          emit(MOReqListSuccess(moReqList: _filterList(event.searchValue)));
        } else {
          emit(
            MOReqListSuccess(moReqList: _moReqList),
          );
        }
      } catch (e) {
        emit(MOReqListError(error: e));
      }
    });
    on<RemoveMOReqList>((event, emit) async {
      emit(MOReqListLoading());
      try {
        _moReqList.removeAt(event.index);
        emit(MOReqListSuccess(moReqList: _moReqList));
      } catch (e) {
        emit(MOReqListError(error: e));
      }
    });
    on<MOReqListFilter>((event, emit) async {
      emit(MOReqListLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          emit(MOReqListSuccess(moReqList: _filterList(event.searchValue)));
        } else {
          emit(MOReqListSuccess(moReqList: _moReqList));
        }
      } catch (error) {
        emit(MOReqListError(error: error));
      }
    });
  }
  List<MOReqTask> _filterList(String filerText) {
    var filterlist = _moReqList.where(
      (element) {
        return (element.item?.toLowerCase().contains(filerText.toLowerCase()) ??
            false);
      },
    ).toList();
    return filterlist;
  }
}
