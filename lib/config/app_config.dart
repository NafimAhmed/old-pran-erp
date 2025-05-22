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

class AppConfigImplPran extends AppConfig {
  AppConfigImplPran._({
    required super.baseUrl,
  });

  // Create a singleton
  static final AppConfigImplPran _instance = AppConfigImplPran._(
    baseUrl: 'https://bpro.prangroup.com:8022',
  );
  static AppConfigImplPran get instance => _instance;
}

class AppConfigImplRfl extends AppConfig {
  AppConfigImplRfl._({
    required super.baseUrl,
  });

  // Create a singleton
  static final AppConfigImplRfl _instance = AppConfigImplRfl._(
    baseUrl: 'https://ego.rflgroupbd.com:8077',
  );
  static AppConfigImplRfl get instance => _instance;
}
