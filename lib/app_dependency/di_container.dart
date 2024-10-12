import 'package:get_it/get_it.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository_impl.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository_impl.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/app_data/service/data_service_impl.dart';
import 'package:pran_rfl_erp/config/app_config.dart';

GetIt getIt = GetIt.instance;

T getService<T extends Object>() {
  return getIt<T>();
}

abstract class DIContainer {
  static Future<void> configureServices({String env = "test"}) async {
    switch (env) {
      case 'prod':
        getIt.registerSingleton<AppConfig>(AppConfigImplProd.instance);
        break;
      case 'test':
        getIt.registerSingleton<AppConfig>(AppConfigImplTest.instance);
        break;
      default:
        getIt.registerSingleton<AppConfig>(AppConfigImpl.instance);
        break;
    }
// // get the application documents directory
//     var dir = await getApplicationDocumentsDirectory();
// // make sure it exists
//     await dir.create(recursive: true);
// // build the database path
//     var dbPath = join(dir.path, 'hospital_booking_system.db');
// // open the database
//     var db = await databaseFactoryIo.openDatabase(dbPath);

//     getIt.registerLazySingleton<LocalDataSource>(
//       () => LocalDataSourceImpl(database: db),
//     );

    getIt.registerLazySingleton<RemoteDataRepository>(
      () => RemoteDataRepositoryImpl(
        appConfig: getIt<AppConfig>(),
      ),
    );
    getIt.registerLazySingleton<LocalDataRepository>(
      () => LocalDataRepositoryImpl(),
    );

    // getIt.registerLazySingleton<ConnectivityService>(
    //   () => ConnectivityService(),
    // );

    // getIt.registerLazySingleton<DeviceInfoService>(
    //   () => DeviceInfoService(),
    // );

    getIt.registerLazySingleton<DataService>(
      () => DataServiceImpl(
        remoteDataRepository: getIt<RemoteDataRepository>(),
        localDataRepository: getIt<LocalDataRepository>(),
      ),
    );
  }

  static void dispose() {
    getIt.reset();
  }
}
