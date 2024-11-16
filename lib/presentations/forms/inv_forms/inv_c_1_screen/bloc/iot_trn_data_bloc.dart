import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/iot_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class IotTrnDataEvent {}

final class GetIotTrnData extends IotTrnDataEvent {
  final String userId;

  GetIotTrnData({required this.userId});
}

@immutable
sealed class IotTrnDataState {}

final class IotTrnDataInitial extends IotTrnDataState {}

final class IotTrnDataLoading extends IotTrnDataState {}

final class IotTrnDataSuccess extends IotTrnDataState {
  final List<IotTrnData> iotTrnDataList;

  IotTrnDataSuccess({required this.iotTrnDataList});
}

final class IotTrnDataError extends IotTrnDataState {
  final Object error;

  IotTrnDataError({required this.error});
}

class IotTrnDataBloc extends Bloc<IotTrnDataEvent, IotTrnDataState> {
  final DataService _dataService;
  IotTrnDataBloc(this._dataService) : super(IotTrnDataInitial()) {
    on<GetIotTrnData>((event, emit) async {
      emit(IotTrnDataLoading());
      try {
        var response = await _dataService.getIotTrnData(userId: event.userId);
        emit(IotTrnDataSuccess(iotTrnDataList: response));
      } catch (e) {
        emit(IotTrnDataError(error: e));
      }
    });
  }
}
