import 'package:pran_rfl_erp/app_data/models/company_model.dart';

import '../../models/user_info_model.dart';

abstract class LocalDataRepository {
  Future<void> saveUserToLocal({
    required UserInfoModel userInfoModel,
  });
  Future<void> clearUserFrmLocal();
  Future<UserInfoModel?> getLoggedUser();

  Future<void> saveCompanyToLocal({
    required CompanyModel comModel,
  });
  Future<void> clearCompanyFrmLocal();
  Future<CompanyModel?> getCompany();
}
