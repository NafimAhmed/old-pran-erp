import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class OrgAccessEvent {}

final class GiveOrgAccess extends OrgAccessEvent {
  final String newUserId;
  final String userId;
  final String orgId;

  GiveOrgAccess(
      {required this.newUserId, required this.userId, required this.orgId});
}

@immutable
sealed class OrgAccessState {}

final class OrgAccessInitial extends OrgAccessState {}

final class OrgAccessLoading extends OrgAccessState {}

final class OrgAccessSuccess extends OrgAccessState {}

final class OrgAccessError extends OrgAccessState {
  final Object error;

  OrgAccessError({required this.error});
}

class OrgAccessBloc extends Bloc<OrgAccessEvent, OrgAccessState> {
  final DataRepo _dataService;
  OrgAccessBloc(this._dataService) : super(OrgAccessInitial()) {
    on<GiveOrgAccess>((event, emit) async {
      emit(OrgAccessLoading());
      try {
        await _dataService.giveOrgAccess(
          newUserId: event.newUserId,
          orgId: event.orgId,
          userId: event.userId,
        );
        emit(OrgAccessSuccess());
      } catch (e) {
        emit(OrgAccessError(error: e));
      }
    });
  }
}
