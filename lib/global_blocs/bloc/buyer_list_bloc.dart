import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/buyer_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

sealed class BuyerListEvent {}

final class BuyerListGet extends BuyerListEvent {
  final String userId;

  BuyerListGet({required this.userId});
}

sealed class BuyerListState {}

final class BuyerListInitial extends BuyerListState {}

final class BuyerListSuccess extends BuyerListState {
  final List<Buyer> buyerList;

  BuyerListSuccess({required this.buyerList});
}

final class BuyerListLoading extends BuyerListState {}

final class BuyerListError extends BuyerListState {
  final Object error;

  BuyerListError({required this.error});
}

class BuyerListBloc extends Bloc<BuyerListEvent, BuyerListState> {
  final DataService _dataService;
  BuyerListBloc(this._dataService) : super(BuyerListInitial()) {
    on<BuyerListGet>((event, emit) async {
      emit(BuyerListLoading());
      try {
        var response = await _dataService.getBuyerList(userId: event.userId);
        emit(BuyerListSuccess(buyerList: response));
      } catch (e) {
        emit(BuyerListError(error: e));
      }
    });
  }
}
