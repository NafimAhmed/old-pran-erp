import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/prod_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class ProdBatchDataEvent {}

final class ProdBatchDataGet extends ProdBatchDataEvent {
  final String userId;
  final String orgid;
  final String jobOrderNo;
  ProdBatchDataGet({
    required this.userId,
    required this.orgid,
    required this.jobOrderNo,
  });
}

final class ProdBatchDataReset extends ProdBatchDataEvent {}

@immutable
sealed class ProdBatchDataState {}

final class ProdBatchDataInitial extends ProdBatchDataState {}

final class ProdBatchDataLoading extends ProdBatchDataState {}

final class ProdBatchDataSuccess extends ProdBatchDataState {
  final List<UserBatch> prodBatchList;

  ProdBatchDataSuccess({required this.prodBatchList});
}

final class ProdBatchDataError extends ProdBatchDataState {
  final Object error;

  ProdBatchDataError({required this.error});
}

class ProdBatchDataBloc extends Bloc<ProdBatchDataEvent, ProdBatchDataState> {
  final DataService _dataService;
  ProdBatchDataBloc(this._dataService) : super(ProdBatchDataInitial()) {
    on<ProdBatchDataGet>((event, emit) async {
      emit(ProdBatchDataLoading());
      try {
        var response = await _dataService.getProdBatchData(
          userid: event.userId,
          orgid: event.orgid,
          jobOrderNo: event.jobOrderNo,
        );

        emit(
          ProdBatchDataSuccess(
            prodBatchList: response,
          ),
        );
      } catch (e) {
        emit(ProdBatchDataError(error: e));
      }
    });
    on<ProdBatchDataReset>((event, emit) async {
      emit(ProdBatchDataInitial());
    });
  }
}
