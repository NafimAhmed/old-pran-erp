import 'package:get_it/get_it.dart';
import 'package:pran_rfl_erp/app_data/api_service/http_service.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository_impl.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_database_service.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/data_repo_impl.dart';
import 'package:pran_rfl_erp/config/app_config.dart';
import 'package:sqflite/sqflite.dart';

GetIt getIt = GetIt.instance;

T getService<T extends Object>() {
  return getIt<T>();
}

abstract class DIContainer {
  static Future<void> configureRemoteServices({String env = ""}) async {
    switch (env) {
      case 'PRAN':
        getIt.registerSingleton<AppConfig>(AppConfigImplPran.instance);
        break;
      case 'RFL':
        getIt.registerSingleton<AppConfig>(AppConfigImplRfl.instance);
        break;
      default:
        getIt.registerSingleton<AppConfig>(AppConfigImpl.instance);
        break;
    }

    getIt.registerLazySingleton<HttpService>(
      () => HttpService(appConfig: getIt<AppConfig>()),
    );

    getIt.registerLazySingleton<DataRepo>(
      () => DataRepoImpl(
        localDataRepository: getIt<LocalDataRepository>(),
        httpService: getIt<HttpService>(),
      ),
    );
  }

  static Future<void> configureLocalServices() async {
    getIt.registerLazySingleton<LocalDatabase>(
      () => LocalDatabase.instance,
    );

    Database localdatabase = await getIt<LocalDatabase>().database;
    getIt.registerLazySingleton<LocalDataRepository>(
      () => LocalDataRepositoryImpl(localDatabase: localdatabase),
    );
  }

  static void dispose() {
    getIt.reset();
  }
}
