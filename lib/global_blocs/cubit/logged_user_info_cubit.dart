import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/company_model.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';

import '../../app_data/models/user_info_model.dart';

class LoggedUserState {
  final UserInfoModel? userInfoModel;
  final CompanyModel? companyModel;

  const LoggedUserState({
    required this.userInfoModel,
    required this.companyModel,
  });

  LoggedUserState copyWith({
    UserInfoModel? userInfoModel,
    CompanyModel? companyModel,
  }) {
    return LoggedUserState(
      userInfoModel: userInfoModel ?? this.userInfoModel,
      companyModel: companyModel ?? this.companyModel,
    );
  }
}

class LoggedUserInfoCubit extends Cubit<LoggedUserState> {
  final LocalDataRepository _localRepo;
  LoggedUserInfoCubit(this._localRepo)
      : super(const LoggedUserState(userInfoModel: null, companyModel: null));
  void checkLoggedUser() async {
    try {
      var response = await _localRepo.getLoggedUser();
      var response1 = await _localRepo.getCompany();
      emit(LoggedUserState(userInfoModel: response, companyModel: response1));
    } catch (error) {
      emit(const LoggedUserState(userInfoModel: null, companyModel: null));
    }
  }

  void setLoggedUser({required UserInfoModel userInfoModel}) async {
    emit(state.copyWith(userInfoModel: userInfoModel));
  }
}
