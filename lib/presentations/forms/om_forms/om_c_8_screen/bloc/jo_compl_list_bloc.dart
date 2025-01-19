import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_completion_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JoComplListEvent {}

final class GetJoComplList extends JoComplListEvent {
  final String userId;
  final String searchValue;
  GetJoComplList({
    required this.userId,
    required this.searchValue,
  });
}

final class RemoveJo extends JoComplListEvent {
  RemoveJo({required this.index});
  final int index;
}

final class JoComplListFilter extends JoComplListEvent {
  final String searchValue;

  JoComplListFilter({required this.searchValue});
}

@immutable
sealed class JoComplListState {}

final class JoComplListInitial extends JoComplListState {}

final class JoComplListLoading extends JoComplListState {}

final class JoComplListSuccess extends JoComplListState {
  JoComplListSuccess({required this.jobOrderCompletionList});
  final List<JobOrderCompletion> jobOrderCompletionList;
}

final class JoComplListError extends JoComplListState {
  final Object error;

  JoComplListError({required this.error});
}

class JoComplListBloc extends Bloc<JoComplListEvent, JoComplListState> {
  final DataService _dataService;
  List<JobOrderCompletion> _dataList = [];
  JoComplListBloc(this._dataService) : super(JoComplListInitial()) {
    on<GetJoComplList>((event, emit) async {
      emit(JoComplListLoading());
      try {
        var response = await _dataService.getJoComplList(userId: event.userId);
        _dataList = response;

        if (event.searchValue.isNotEmpty) {
          emit(JoComplListSuccess(
              jobOrderCompletionList: _filterList(event.searchValue)));
        } else {
          emit(
            JoComplListSuccess(jobOrderCompletionList: _dataList),
          );
        }
      } catch (e) {
        emit(JoComplListError(error: e));
      }
    });
    on<RemoveJo>((event, emit) async {
      emit(JoComplListLoading());
      try {
        _dataList.removeAt(event.index);
        emit(
          JoComplListSuccess(jobOrderCompletionList: _dataList),
        );
      } catch (e) {
        emit(JoComplListError(error: e));
      }
    });
    on<JoComplListFilter>((event, emit) async {
      emit(JoComplListLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          emit(JoComplListSuccess(
              jobOrderCompletionList: _filterList(event.searchValue)));
        } else {
          emit(JoComplListSuccess(jobOrderCompletionList: _dataList));
        }
      } catch (error) {
        emit(JoComplListError(error: error));
      }
    });
  }
  List<JobOrderCompletion> _filterList(String filerText) {
    var filterlist = _dataList.where(
      (element) {
        return element.jobOrderNo
                ?.toLowerCase()
                .contains(filerText.toLowerCase()) ??
            false;
      },
    ).toList();
    return filterlist;
  }
}
