abstract class AppConfig {
  final String baseUrl;

  AppConfig({
    required this.baseUrl,
  });
}

class AppConfigImpl extends AppConfig {
  AppConfigImpl._({
    required super.baseUrl,
  });

  // Create a singleton
  static final AppConfigImpl _instance = AppConfigImpl._(
    baseUrl: '',
  );
  static AppConfigImpl get instance => _instance;
}

class AppConfigImplProd extends AppConfig {
  AppConfigImplProd._({
    required super.baseUrl,
  });

  // Create a singleton
  static final AppConfigImplProd _instance = AppConfigImplProd._(
    baseUrl: '',
  );
  static AppConfigImplProd get instance => _instance;
}

class AppConfigImplTest extends AppConfig {
  AppConfigImplTest._({
    required super.baseUrl,
  });

  // Create a singleton
  static final AppConfigImplTest _instance = AppConfigImplTest._(
    baseUrl: 'https://ego.rflgroupbd.com:8077',
  );
  static AppConfigImplTest get instance => _instance;
}
