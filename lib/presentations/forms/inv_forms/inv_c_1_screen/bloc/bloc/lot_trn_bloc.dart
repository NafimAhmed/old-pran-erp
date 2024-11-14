import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class LotTrnEvent {}

final class GetLotTrnData extends LotTrnEvent {
  final String userId;
  final String racklocator;

  GetLotTrnData({required this.userId, required this.racklocator});
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
  final DataService _dataService;
  LotTrnBloc(this._dataService) : super(LotTrnInitial()) {
    on<GetLotTrnData>((event, emit) async {
      emit(LotTrnLoading());
      try {
        var response = await _dataService.getLotTrnData(
          userId: event.userId,
          racklocator: "PB0241107141",
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
