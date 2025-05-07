import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_menu_item_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

sealed class UserMenuEvent {}

final class UserMenuGet extends UserMenuEvent {
  final String userId;

  UserMenuGet({required this.userId});
}

sealed class UserMenuState {}

final class UserMenuInitial extends UserMenuState {}

final class UserMenuSuccess extends UserMenuState {
  final List<UserMenuItem> menuItems;

  UserMenuSuccess({required this.menuItems});
}

final class UserMenuLoading extends UserMenuState {}

final class UserMenuError extends UserMenuState {
  final Object error;

  UserMenuError({required this.error});
}

class UserMenuBloc extends Bloc<UserMenuEvent, UserMenuState> {
  final DataRepo _dataService;
  UserMenuBloc(this._dataService) : super(UserMenuInitial()) {
    on<UserMenuGet>((event, emit) async {
      emit(UserMenuLoading());
      try {
        var response = await _dataService.getUserMenu(userid: event.userId);
        emit(UserMenuSuccess(menuItems: response));
      } catch (e) {
        emit(UserMenuError(error: e));
      }
    });
  }
}
