import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

@immutable
sealed class UserPassChangEvent {}

final class UserPassChang extends UserPassChangEvent {
  final String userid;
  final String oldPass;
  final String newPass;

  UserPassChang({
    required this.userid,
    required this.oldPass,
    required this.newPass,
  });
}

@immutable
sealed class UserPassChangState {}

final class UserPassChangInitial extends UserPassChangState {}

final class UserPassChangLoading extends UserPassChangState {}

final class UserPassChangSuccess extends UserPassChangState {}

final class UserPassChangError extends UserPassChangState {
  final Object error;

  UserPassChangError({required this.error});
}

class UserPassChangBloc extends Bloc<UserPassChangEvent, UserPassChangState> {
  final DataRepo _dataService;
  UserPassChangBloc(this._dataService) : super(UserPassChangInitial()) {
    on<UserPassChang>((event, emit) async {
      emit(UserPassChangLoading());
      try {
        await _dataService.userPassChange(
          userid: event.userid,
          oldPass: event.oldPass,
          newPass: event.newPass,
        );
        emit(UserPassChangSuccess());
      } catch (e) {
        emit(UserPassChangError(error: e));
      }
    });
  }
}
