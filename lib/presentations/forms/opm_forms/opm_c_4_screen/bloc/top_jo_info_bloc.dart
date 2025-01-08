import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/top_jo_info_list_response.dart';

import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class TopJoInfoEvent {}

final class TopJoInfoGet extends TopJoInfoEvent {
  final String userId;

  TopJoInfoGet({required this.userId});
}

final class TopJoInfoFilter extends TopJoInfoEvent {
  final String searchValue;

  TopJoInfoFilter({required this.searchValue});
}

@immutable
sealed class TopJoInfoState {}

final class TopJoInfoInitial extends TopJoInfoState {}

final class TopJoInfoLoading extends TopJoInfoState {}

final class TopJoInfoSuccess extends TopJoInfoState {
  final List<TopJoInfo> topJoInfoList;

  TopJoInfoSuccess({required this.topJoInfoList});
}

final class TopJoInfoError extends TopJoInfoState {
  final Object error;

  TopJoInfoError({required this.error});
}

class TopJoInfoBloc extends Bloc<TopJoInfoEvent, TopJoInfoState> {
  final DataService _dataService;
  List<TopJoInfo> _topJoInfoList = [];
  TopJoInfoBloc(this._dataService) : super(TopJoInfoInitial()) {
    on<TopJoInfoGet>((event, emit) async {
      emit(TopJoInfoLoading());
      try {
        var response =
            await _dataService.getTopJOInfoList(userId: event.userId);
        _topJoInfoList.clear();
        _topJoInfoList = response;
        emit(TopJoInfoSuccess(topJoInfoList: response));
      } catch (error) {
        emit(TopJoInfoError(error: error));
      }
    });
    on<TopJoInfoFilter>((event, emit) async {
      emit(TopJoInfoLoading());
      try {
        if (event.searchValue.isNotEmpty) {
          var filterlist = _topJoInfoList.where(
            (element) {
              return element.jobOrderNo
                      ?.toLowerCase()
                      .contains(event.searchValue.toLowerCase()) ??
                  false;
            },
          ).toList();
          emit(TopJoInfoSuccess(topJoInfoList: filterlist));
        } else {
          emit(TopJoInfoSuccess(topJoInfoList: _topJoInfoList));
        }
      } catch (error) {
        emit(TopJoInfoError(error: error));
      }
    });
  }
}
