import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/test_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/core/utils/enums.dart';

@immutable
sealed class TestListEvent {}

final class GetTestList extends TestListEvent {
  GetTestList();
}

class TestListState {
  final RequestStatus fetchStatus;
  final List<TestList> testList;
  final Object? error;

  TestListState({
    this.fetchStatus = RequestStatus.initial,
    this.testList = const [],
    this.error,
  });

  TestListState copyWith({
    RequestStatus? fetchStatus,
    List<TestList>? testList,
    Object? error,
  }) {
    return TestListState(
      testList: testList ?? this.testList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      error: error,
    );
  }
}

class TestListBloc extends Bloc<TestListEvent, TestListState> {
  final DataRepo _dataService;
  List<TestList> _testList = [];
  TestListBloc(this._dataService) : super(TestListState()) {
    emit(state.copyWith(fetchStatus: RequestStatus.loading));
    on<GetTestList>((event, emit) async {
      try {
        var res = await _dataService.getTestList();
        _testList = res;

        emit(
          state.copyWith(
            fetchStatus: RequestStatus.success,
            testList: _testList,
            error: null,
          ),
        );
      } catch (e) {
        emit(state.copyWith(fetchStatus: RequestStatus.failure, error: e));
      }
    });
  }
}
