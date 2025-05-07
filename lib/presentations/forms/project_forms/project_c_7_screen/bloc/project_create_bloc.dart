import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class ProjectCreateEvent {}

final class ProjectCreate extends ProjectCreateEvent {
  final String pname;
  final String pDesc;
  final String stDate;
  final String endate;
  final String pManager;
  final String pClientName;
  final String pBudget;
  final String pStatus;
  final String pPriority;
  final String pTtlPerson;
  final String pManHours;

  ProjectCreate({
    required this.pname,
    required this.pDesc,
    required this.stDate,
    required this.endate,
    required this.pManager,
    required this.pClientName,
    required this.pBudget,
    required this.pStatus,
    required this.pPriority,
    required this.pTtlPerson,
    required this.pManHours,
  });
}

@immutable
sealed class ProjectCreateState {}

final class ProjectCreateInitial extends ProjectCreateState {}

final class ProjectCreateLoading extends ProjectCreateState {}

final class ProjectCreateSuccess extends ProjectCreateState {
  ProjectCreateSuccess();
}

final class ProjectCreateError extends ProjectCreateState {
  final Object error;

  ProjectCreateError({required this.error});
}

class ProjectCreateBloc extends Bloc<ProjectCreateEvent, ProjectCreateState> {
  final DataRepo _dataService;

  ProjectCreateBloc(this._dataService) : super(ProjectCreateInitial()) {
    on<ProjectCreate>((event, emit) async {
      emit(ProjectCreateLoading());
      try {
        await _dataService.createProject(
            pname: event.pname,
            pDesc: event.pDesc,
            stDate: event.stDate,
            endate: event.endate,
            pManager: event.pManager,
            pClientName: event.pClientName,
            pBudget: event.pBudget,
            pStatus: event.pStatus,
            pPriority: event.pPriority,
            pTtlPerson: event.pTtlPerson,
            pManHours: event.pManHours);

        emit(ProjectCreateSuccess());
      } catch (e) {
        emit(ProjectCreateError(error: e));
      }
    });
  }
}
