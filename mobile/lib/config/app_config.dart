// [S1] Shared mobile runtime configuration.
class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api/v1',
  );

  static const appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
}
