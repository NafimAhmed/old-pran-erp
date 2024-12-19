import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class JobTaskInfoEvent {}

final class GetJobTaskInfo extends JobTaskInfoEvent {
  final String userId;

  GetJobTaskInfo({required this.userId});
}

@immutable
sealed class JobTaskInfoState {}

final class JobTaskInfoInitial extends JobTaskInfoState {}

final class JobTaskInfoLoading extends JobTaskInfoState {}

final class JobTaskInfoSuccess extends JobTaskInfoState {
  final List<TaskInfo> jobTaskInfoList;

  JobTaskInfoSuccess({required this.jobTaskInfoList});
}

final class JobTaskInfoError extends JobTaskInfoState {
  final Object error;

  JobTaskInfoError({required this.error});
}

class JobTaskInfoBloc extends Bloc<JobTaskInfoEvent, JobTaskInfoState> {
  final DataService _dataService;
  JobTaskInfoBloc(this._dataService) : super(JobTaskInfoInitial()) {
    on<GetJobTaskInfo>((event, emit) async {
      emit(JobTaskInfoLoading());
      try {
        var response = await _dataService.getJobTaskList(userid: event.userId);
        emit(JobTaskInfoSuccess(jobTaskInfoList: response));
      } catch (e) {
        emit(JobTaskInfoError(error: e));
      }
    });
  }
}
