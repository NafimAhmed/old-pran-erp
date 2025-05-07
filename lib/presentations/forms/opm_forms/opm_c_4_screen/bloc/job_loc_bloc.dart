import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class JobLocatorDrilEvent {}

final class JobLocatorDrilGet extends JobLocatorDrilEvent {
  final String userid;
  final String jobOrderNo;
  final String itemCode;

  JobLocatorDrilGet({
    required this.userid,
    required this.itemCode,
    required this.jobOrderNo,
  });
}

@immutable
sealed class JobLocatorDrilState {}

final class JobLocatorDrilInitial extends JobLocatorDrilState {}

final class JobLocatorDrilLoading extends JobLocatorDrilState {}

final class JobLocatorDrilSuccess extends JobLocatorDrilState {
  final List<JobLocatorInfo> jobLocatorDrilList;

  JobLocatorDrilSuccess({required this.jobLocatorDrilList});
}

final class JobLocatorDrilError extends JobLocatorDrilState {
  final Object error;

  JobLocatorDrilError({required this.error});
}

class JobLocatorDrilBloc
    extends Bloc<JobLocatorDrilEvent, JobLocatorDrilState> {
  final DataRepo _dataService;
  JobLocatorDrilBloc(this._dataService) : super(JobLocatorDrilInitial()) {
    on<JobLocatorDrilGet>((event, emit) async {
      emit(JobLocatorDrilLoading());
      try {
        var response = await _dataService.getJobLocDrillDw(
          userid: event.userid,
          itemCode: event.itemCode,
          jobOrderNo: event.jobOrderNo,
        );
        emit(JobLocatorDrilSuccess(jobLocatorDrilList: response));
      } catch (error) {
        emit(JobLocatorDrilError(error: error));
      }
    });
  }
}
