import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataRepositoryImpl implements LocalDataRepository {
  final Database localDatabase;

  LocalDataRepositoryImpl({required this.localDatabase});
}
