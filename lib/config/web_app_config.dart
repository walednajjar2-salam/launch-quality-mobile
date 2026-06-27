/// Production web ERP — same SPA as Railway v47 lock.
class WebAppConfig {
  static const String productionUrl =
      'https://web-production-08d73.up.railway.app';

  static const String appUrl = String.fromEnvironment(
    'WEB_APP_URL',
    defaultValue: productionUrl,
  );
}
