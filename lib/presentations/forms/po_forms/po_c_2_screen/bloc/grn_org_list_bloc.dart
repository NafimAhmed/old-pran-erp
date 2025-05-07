import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class GrnOrgListEvent {}

final class GrnOrgListGet extends GrnOrgListEvent {
  final int ouId;
  GrnOrgListGet({required this.ouId});
}

@immutable
sealed class GrnOrgListState {}

final class GrnOrgListInitial extends GrnOrgListState {}

final class GrnOrgListLoading extends GrnOrgListState {}

final class GrnOrgListSuccess extends GrnOrgListState {
  final List<UserOrg> grnOrg;

  GrnOrgListSuccess({required this.grnOrg});
}

final class GrnOrgListError extends GrnOrgListState {
  final Object error;

  GrnOrgListError({required this.error});
}

class GrnOrgListBloc extends Bloc<GrnOrgListEvent, GrnOrgListState> {
  final DataRepo _dataService;
  List<UserOrg> _grnOrg = [];
  GrnOrgListBloc(this._dataService) : super(GrnOrgListInitial()) {
    on<GrnOrgListGet>((event, emit) async {
      emit(GrnOrgListLoading());
      try {
        var response = await _dataService.getGrnOrgList(ouId: event.ouId);
        _grnOrg.clear();
        _grnOrg = response;
        emit(GrnOrgListSuccess(grnOrg: _grnOrg));
      } catch (e) {
        emit(GrnOrgListError(error: e));
      }
    });
  }
}
