import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_completion_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JoComplListEvent {}

final class GetJoComplList extends JoComplListEvent {
  final String userId;

  GetJoComplList({
    required this.userId,
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
        emit(
          JoComplListSuccess(jobOrderCompletionList: _dataList),
        );
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
          var filterlist = _dataList.where(
            (element) {
              return element.jobOrderNo
                      ?.toLowerCase()
                      .contains(event.searchValue.toLowerCase()) ??
                  false;
            },
          ).toList();
          emit(JoComplListSuccess(jobOrderCompletionList: filterlist));
        } else {
          emit(JoComplListSuccess(jobOrderCompletionList: _dataList));
        }
      } catch (error) {
        emit(JoComplListError(error: error));
      }
    });
  }
}
