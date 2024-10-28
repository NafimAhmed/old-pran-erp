import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../entities/authentication_response.dart';
import '../../models/user_info_model.dart';

class LocalDataRepositoryImpl implements LocalDataRepository {
  final Database localDatabase;

  LocalDataRepositoryImpl({required this.localDatabase});

  @override
  Future<void> saveUserToLocal({
    required UserInfoModel userInfoModel,
  }) async {
    await localDatabase.delete("userInfo", where: 'id = ?', whereArgs: [1]);
    await localDatabase
        .execute("DELETE FROM sqlite_sequence WHERE name = 'userInfo'");
    await localDatabase.insert("userInfo", userInfoModel.toMap());
  }

  @override
  Future<UserInfoModel?> getLoggedUser() async {
    final List<Map<String, dynamic>> results = await localDatabase.query(
      "userInfo",
      where: "id = ?",
      whereArgs: [1],
    );
    if (results.isNotEmpty) {
      return UserInfoModel.fromMap(results[0]);
    } else {
      return null;
    }
  }
}
