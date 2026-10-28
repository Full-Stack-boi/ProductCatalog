import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/config/app_config.dart';

final exchangeRateServiceProvider = Provider<ExchangeRateService>((ref) {
  return ExchangeRateService();
});

class ExchangeRateData {
  final double rate;
  final String date;

  const ExchangeRateData({required this.rate, required this.date});
}

class ExchangeRateService {
  final Dio _dio;

  ExchangeRateService([Dio? dio])
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              headers: {'Accept': 'application/json'},
            ),
          );

  Future<ExchangeRateData?> fetchUsdToThbData() async {
    if (AppConfig.appEnv == 'test') {
      return null;
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await _dio.get(AppConfig.exchangeRateApiUrl);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final rates = data['rates'];
          if (rates is Map<String, dynamic> && rates['THB'] != null) {
            final rate = (rates['THB'] as num).toDouble();
            String dateStr = '';
            final timeUnix = data['time_last_update_unix'];
            if (timeUnix is num && timeUnix > 0) {
              final date = DateTime.fromMillisecondsSinceEpoch(
                timeUnix.toInt() * 1000,
                isUtc: true,
              );
              dateStr = DateFormat('yyyy-MM-dd').format(date);
            }
            if (dateStr.isEmpty) {
              dateStr = todayStr;
            }
            return ExchangeRateData(rate: rate, date: dateStr);
          }
        }
      }
    } catch (_) {
      try {
        final fallbackResponse = await _dio.get(
          'https://api.frankfurter.app/latest?from=USD&to=THB',
        );
        if (fallbackResponse.statusCode == 200 &&
            fallbackResponse.data != null) {
          final data = fallbackResponse.data;
          if (data is Map<String, dynamic>) {
            final rates = data['rates'];
            if (rates is Map<String, dynamic> && rates['THB'] != null) {
              final rate = (rates['THB'] as num).toDouble();
              final dateStr = (data['date'] as String?) ?? todayStr;
              return ExchangeRateData(rate: rate, date: dateStr);
            }
          }
        }
      } catch (_) {}
    }
    return null;
  }

  Future<double?> fetchUsdToThbRate() async {
    final data = await fetchUsdToThbData();
    return data?.rate;
  }
}
