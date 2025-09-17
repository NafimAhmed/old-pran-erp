import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class LotTrnEvent {}

final class GetLotTrnData extends LotTrnEvent {
  final String userId;
  final String racklocator;

  GetLotTrnData({required this.userId, required this.racklocator});
}

final class GetLotTrnDataNew extends LotTrnEvent {
  final String userId;
  final String racklocator;

  GetLotTrnDataNew({required this.userId, required this.racklocator});
}

final class RestLotTrnData extends LotTrnEvent {}

@immutable
sealed class LotTrnState {}

final class LotTrnInitial extends LotTrnState {}

final class LotTrnLoading extends LotTrnState {}

final class LotTrnSuccess extends LotTrnState {
  final List<LotTrnData> lotTrnDataList;

  LotTrnSuccess({required this.lotTrnDataList});
}

final class LotTrnError extends LotTrnState {
  final Object error;

  LotTrnError({required this.error});
}

class LotTrnBloc extends Bloc<LotTrnEvent, LotTrnState> {
  final DataRepo _dataService;
  LotTrnBloc(this._dataService) : super(LotTrnInitial()) {
    on<GetLotTrnData>((event, emit) async {
      emit(LotTrnLoading());
      try {
        var response = await _dataService.getLotTrnData(
          userId: event.userId,
          //racklocator: "PE925090293049",
          racklocator: event.racklocator,
        );
        emit(LotTrnSuccess(lotTrnDataList: response));
      } catch (e) {
        emit(LotTrnError(error: e));
      }
    });
    on<GetLotTrnDataNew>((event, emit) async {
      emit(LotTrnLoading());
      try {
        var response = await _dataService.getLotTrnDataNew(
          userId: event.userId,

          ///racklocator: "PE925090293049",
          racklocator: event.racklocator,
        );

        emit(LotTrnSuccess(lotTrnDataList: response));
      } catch (e) {
        emit(LotTrnError(error: e));
      }
    });
    on<RestLotTrnData>((event, emit) async {
      emit(LotTrnInitial());
    });
  }
}
