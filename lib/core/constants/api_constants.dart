import '../config/app_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => AppConfig.apiBaseUrl;
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  static const String searchEndpoint = '/products/search';
  static const String categoryEndpoint = '/products/category';

  static const int defaultPageSize = 20;
  static Duration get connectTimeout =>
      Duration(seconds: AppConfig.apiConnectTimeoutSeconds);
  static Duration get receiveTimeout =>
      Duration(seconds: AppConfig.apiReceiveTimeoutSeconds);
}
