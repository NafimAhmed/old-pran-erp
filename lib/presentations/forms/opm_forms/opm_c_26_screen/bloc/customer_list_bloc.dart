import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/customer_list_response.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';

@immutable
sealed class CustomerListEvent {}

final class CustomerListGet extends CustomerListEvent {
  final String searchV;

  CustomerListGet({
    required this.searchV,
  });
}

@immutable
sealed class CustomerListState {}

final class CustomerListInitial extends CustomerListState {}

final class CustomerListLoading extends CustomerListState {}

final class CustomerListSuccess extends CustomerListState {
  final List<Customer> customerList;

  CustomerListSuccess({required this.customerList});
}

final class CustomerListError extends CustomerListState {
  final Object error;

  CustomerListError({required this.error});
}

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  final DataService _dataService;
  List<Customer> _customerList = [];
  CustomerListBloc(this._dataService) : super(CustomerListInitial()) {
    on<CustomerListGet>((event, emit) async {
      emit(CustomerListLoading());
      try {
        List<Customer> response =
            await _dataService.getCustomerList(searchV: event.searchV);

        _customerList.clear();
        _customerList = response;
        emit(CustomerListSuccess(customerList: _customerList));
      } catch (e) {
        emit(CustomerListError(error: e));
      }
    });
  }
}
