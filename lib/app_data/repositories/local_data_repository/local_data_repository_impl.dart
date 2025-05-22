import 'package:pran_rfl_erp/app_data/models/company_model.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  Future<void> clearUserFrmLocal() async {
    await localDatabase.delete("userInfo", where: 'id = ?', whereArgs: [1]);
    await localDatabase
        .execute("DELETE FROM sqlite_sequence WHERE name = 'userInfo'");
  }

  @override
  Future<void> clearCompanyFrmLocal() async {
    await localDatabase.delete("company", where: 'id = ?', whereArgs: [1]);
    await localDatabase
        .execute("DELETE FROM sqlite_sequence WHERE name = 'company'");
  }

  @override
  Future<CompanyModel?> getCompany() async {
    final List<Map<String, dynamic>> results = await localDatabase.query(
      "company",
      where: "id = ?",
      whereArgs: [1],
    );
    if (results.isNotEmpty) {
      return CompanyModel.fromMap(results[0]);
    } else {
      return null;
    }
  }

  @override
  Future<void> saveCompanyToLocal({required CompanyModel comModel}) async {
    await localDatabase.delete("company", where: 'id = ?', whereArgs: [1]);
    await localDatabase
        .execute("DELETE FROM sqlite_sequence WHERE name = 'company'");
    await localDatabase.insert("company", comModel.toMap());
  }
}
