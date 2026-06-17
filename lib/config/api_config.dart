class ApiConfig {
  static const String productionBaseUrl =
      'https://web-production-08d73.up.railway.app/api';

  /// Override at runtime via `--dart-define=API_BASE_URL=...` if needed.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: productionBaseUrl,
  );

  static const Duration defaultTimeout = Duration(seconds: 45);
  static const Duration bootstrapTimeout = Duration(seconds: 90);
}
