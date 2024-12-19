import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JobHistoryEvent {}

final class JobHistoryGet extends JobHistoryEvent {
  final String userId;

  JobHistoryGet({required this.userId});
}

final class JobHistoryFilter extends JobHistoryEvent {
  final String searchValue;

  JobHistoryFilter({required this.searchValue});
}

@immutable
sealed class JobHistoryState {}

final class JobHistoryInitial extends JobHistoryState {}

final class JobHistoryLoading extends JobHistoryState {}

final class JobHistorySuccess extends JobHistoryState {
  final List<JobHistory> jobHistoryList;

  JobHistorySuccess({required this.jobHistoryList});
}

final class JobHistoryError extends JobHistoryState {
  final Object error;

  JobHistoryError({required this.error});
}

class JobHistoryBloc extends Bloc<JobHistoryEvent, JobHistoryState> {
  final DataService _dataService;
  List<JobHistory> _jobHistoryList = [];
  JobHistoryBloc(this._dataService) : super(JobHistoryInitial()) {
    on<JobHistoryGet>((event, emit) async {
      emit(JobHistoryLoading());
      try {
        var response = await _dataService.getJobHistory(userId: event.userId);
        _jobHistoryList.clear();
        _jobHistoryList = response;
        emit(JobHistorySuccess(jobHistoryList: response));
      } catch (error) {
        emit(JobHistoryError(error: error));
      }
    });
    on<JobHistoryFilter>((event, emit) async {
      emit(JobHistoryLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          var _filterlist = _jobHistoryList.where(
            (element) {
              return element.jobOrderNo
                      ?.toLowerCase()
                      .contains(event.searchValue.toLowerCase()) ??
                  false;
            },
          ).toList();
          emit(JobHistorySuccess(jobHistoryList: _filterlist));
        } else {
          emit(JobHistorySuccess(jobHistoryList: _jobHistoryList));
        }
      } catch (error) {
        emit(JobHistoryError(error: error));
      }
    });
  }
}
