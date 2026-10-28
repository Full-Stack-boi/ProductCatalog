import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get appEnv => dotenv.get('APP_ENV');

  static String get appName => dotenv.get('APP_NAME');

  static bool get enableNetworkLogs =>
      dotenv.get('ENABLE_NETWORK_LOGS').toLowerCase() == 'true';

  static String get apiBaseUrl {
    final url = dotenv.get('API_BASE_URL');
    if (url.trim().isEmpty) {
      throw StateError('API_BASE_URL cannot be empty in .env');
    }
    return url;
  }

  static int get apiConnectTimeoutSeconds =>
      int.parse(dotenv.get('API_CONNECT_TIMEOUT_SECONDS'));

  static int get apiReceiveTimeoutSeconds =>
      int.parse(dotenv.get('API_RECEIVE_TIMEOUT_SECONDS'));

  static int get defaultPageSize => int.parse(dotenv.get('DEFAULT_PAGE_SIZE'));

  static String get defaultLocale => dotenv.get('DEFAULT_LOCALE');

  static String get defaultCurrency => dotenv.get('DEFAULT_CURRENCY');

  static double get usdToThbRate {
    final rateStr = dotenv.get('USD_TO_THB_RATE');
    final rate = double.parse(rateStr);
    if (rate <= 0) {
      throw StateError('USD_TO_THB_RATE must be greater than 0 in .env');
    }
    return rate;
  }

  static String get exchangeRateApiUrl {
    return dotenv.get('EXCHANGE_RATE_API_URL');
  }
}
