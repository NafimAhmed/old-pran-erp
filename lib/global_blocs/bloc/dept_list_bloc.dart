import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

sealed class DeptListEvent {}

final class DeptListGet extends DeptListEvent {
  final String userId;

  DeptListGet({required this.userId});
}

sealed class DeptListState {}

final class DeptListInitial extends DeptListState {}

final class DeptListSuccess extends DeptListState {
  final List<DeptList> deptList;

  DeptListSuccess({required this.deptList});
}

final class DeptListLoading extends DeptListState {}

final class DeptListError extends DeptListState {
  final Object error;

  DeptListError({required this.error});
}

class DeptListBloc extends Bloc<DeptListEvent, DeptListState> {
  final DataService _dataService;
  DeptListBloc(this._dataService) : super(DeptListInitial()) {
    on<DeptListGet>((event, emit) async {
      emit(DeptListLoading());
      try {
        var response = await _dataService.getDeptList(userId: event.userId);
        emit(DeptListSuccess(deptList: response));
      } catch (e) {
        emit(DeptListError(error: e));
      }
    });
  }
}
