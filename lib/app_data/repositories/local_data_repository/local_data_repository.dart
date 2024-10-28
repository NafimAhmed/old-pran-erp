import '../../models/user_info_model.dart';

abstract class LocalDataRepository {
  Future<void> saveUserToLocal({
    required UserInfoModel userInfoModel,
  });
  Future<UserInfoModel?> getLoggedUser();
}
