enum EnvironmentType { PRODUCTION, STAGING }

class AppConfig {
  static late AppConfig _instance;
  static AppConfig get I => _instance;

  final String hostUrl;

  const AppConfig._({required this.hostUrl});

  static void init(EnvironmentType env) {
    switch (env) {
      case EnvironmentType.PRODUCTION:
        _instance = const AppConfig._(
          hostUrl: 'https://your-prod-api.com', // replace later
        );
        break;
      case EnvironmentType.STAGING:
        _instance = const AppConfig._(
          hostUrl: 'https://your-staging-api.com', // replace later
        );
        break;
    }
  }
}
