import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';

import '../../app_data/models/user_info_model.dart';

class LoggedUserInfoCubit extends Cubit<UserInfoModel?> {
  final DataRepo _dataService;
  LoggedUserInfoCubit(this._dataService) : super(null);
  void checkLoggedUser() async {
    try {
      var response = await _dataService.getLoggedUser();
      emit(response);
    } catch (error) {
      emit(null);
    }
  }

  void setLoggedUser({required UserInfoModel userInfoModel}) async {
    emit(userInfoModel);
  }
}
