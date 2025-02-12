import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/project_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ProjectListEvent {}

final class ProjectListGet extends ProjectListEvent {
  final String userId;

  ProjectListGet({
    required this.userId,
  });
}

@immutable
sealed class ProjectListState {}

final class ProjectListInitial extends ProjectListState {}

final class ProjectListLoading extends ProjectListState {}

final class ProjectListSuccess extends ProjectListState {
  final List<Project> projectList;
  ProjectListSuccess({required this.projectList});
}

final class ProjectListError extends ProjectListState {
  final Object error;

  ProjectListError({required this.error});
}

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final DataService _dataService;

  ProjectListBloc(this._dataService) : super(ProjectListInitial()) {
    on<ProjectListGet>((event, emit) async {
      emit(ProjectListLoading());
      try {
        var response = await _dataService.getProjectList(userId: event.userId);

        emit(ProjectListSuccess(projectList: response));
      } catch (e) {
        emit(ProjectListError(error: e));
      }
    });
  }
}
