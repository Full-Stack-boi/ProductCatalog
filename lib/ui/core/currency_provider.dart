import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../data/services/exchange_rate_service.dart';
import '../../l10n/app_localizations.dart';
import 'locale_provider.dart';

enum AppCurrency {
  usd(code: 'USD', symbol: '\$', locale: 'en_US', decimalDigits: 2),
  thb(code: 'THB', symbol: '฿', locale: 'th_TH', decimalDigits: 2);

  final String code;
  final String symbol;
  final String locale;
  final int decimalDigits;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.locale,
    required this.decimalDigits,
  });

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case AppCurrency.thb:
        return l10n.currencyNameThb;
      case AppCurrency.usd:
        return l10n.currencyNameUsd;
    }
  }

  static AppCurrency fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'th':
        return AppCurrency.thb;
      case 'en':
      default:
        return AppCurrency.usd;
    }
  }
}

class CurrencyState {
  final AppCurrency currency;
  final double usdToThbRate;
  final bool isLive;
  final bool isDailyRate;
  final bool isFetching;
  final String? rateDate;
  final DateTime? lastUpdated;

  const CurrencyState({
    required this.currency,
    required this.usdToThbRate,
    this.isLive = false,
    this.isDailyRate = false,
    this.isFetching = false,
    this.rateDate,
    this.lastUpdated,
  });

  CurrencyState copyWith({
    AppCurrency? currency,
    double? usdToThbRate,
    bool? isLive,
    bool? isDailyRate,
    bool? isFetching,
    String? rateDate,
    DateTime? lastUpdated,
  }) {
    return CurrencyState(
      currency: currency ?? this.currency,
      usdToThbRate: usdToThbRate ?? this.usdToThbRate,
      isLive: isLive ?? this.isLive,
      isDailyRate: isDailyRate ?? this.isDailyRate,
      isFetching: isFetching ?? this.isFetching,
      rateDate: rateDate ?? this.rateDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  double get exchangeRate => currency == AppCurrency.thb ? usdToThbRate : 1.0;

  double convert(double usdAmount) {
    return usdAmount * exchangeRate;
  }

  String format(double usdAmount) {
    final converted = convert(usdAmount);
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    );
    return formatter.format(converted);
  }
}

class CurrencyNotifier extends Notifier<CurrencyState> {
  static const String _prefRateKey = 'cached_usd_thb_rate';
  static const String _prefDateKey = 'cached_usd_thb_date';

  ExchangeRateService get _rateService => ref.read(exchangeRateServiceProvider);
  double? _cachedRate;
  bool _cachedIsLive = false;
  bool _cachedIsDailyRate = false;
  String? _cachedRateDate;
  DateTime? _cachedLastUpdated;

  @override
  CurrencyState build() {
    final locale = ref.watch(localeProvider);
    final defaultCurrency = AppCurrency.fromLocale(locale);
    final currentRate = _cachedRate ?? AppConfig.usdToThbRate;

    if (AppConfig.appEnv != 'test' && _cachedRate == null) {
      Future.microtask(_initDailyRate);
    }

    return CurrencyState(
      currency: defaultCurrency,
      usdToThbRate: currentRate,
      isLive: _cachedIsLive,
      isDailyRate: _cachedIsDailyRate,
      rateDate: _cachedRateDate,
      lastUpdated: _cachedLastUpdated,
    );
  }

  Future<void> _initDailyRate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRate = prefs.getDouble(_prefRateKey);
      final savedDate = prefs.getString(_prefDateKey);
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (savedRate != null && savedRate > 0 && savedDate == todayStr) {
        _cachedRate = savedRate;
        _cachedIsLive = true;
        _cachedIsDailyRate = true;
        _cachedRateDate = savedDate;
        _cachedLastUpdated = DateTime.now();

        state = state.copyWith(
          usdToThbRate: savedRate,
          isLive: true,
          isDailyRate: true,
          rateDate: savedDate,
          lastUpdated: _cachedLastUpdated,
        );
        return;
      }
    } catch (_) {}

    await fetchDailyRate(force: false);
  }

  Future<void> fetchDailyRate({bool force = false}) async {
    state = state.copyWith(isFetching: true);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final data = await _rateService.fetchUsdToThbData();
    if (data != null && data.rate > 0) {
      final rate = data.rate;
      final date = data.date.isNotEmpty ? data.date : todayStr;

      _cachedRate = rate;
      _cachedIsLive = true;
      _cachedIsDailyRate = true;
      _cachedRateDate = date;
      _cachedLastUpdated = DateTime.now();

      state = state.copyWith(
        usdToThbRate: rate,
        isLive: true,
        isDailyRate: true,
        isFetching: false,
        rateDate: date,
        lastUpdated: _cachedLastUpdated,
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_prefRateKey, rate);
        await prefs.setString(_prefDateKey, date);
      } catch (_) {}
    } else {
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedRate = prefs.getDouble(_prefRateKey);
        final savedDate = prefs.getString(_prefDateKey);
        if (savedRate != null && savedRate > 0) {
          _cachedRate = savedRate;
          _cachedIsLive = true;
          _cachedIsDailyRate = true;
          _cachedRateDate = savedDate;
          _cachedLastUpdated = DateTime.now();

          state = state.copyWith(
            usdToThbRate: savedRate,
            isLive: true,
            isDailyRate: true,
            isFetching: false,
            rateDate: savedDate,
            lastUpdated: _cachedLastUpdated,
          );
          return;
        }
      } catch (_) {}

      state = state.copyWith(isFetching: false);
    }
  }

  Future<void> refreshLiveRate() async {
    await fetchDailyRate(force: true);
  }

  void setCurrency(AppCurrency currency) {
    state = state.copyWith(currency: currency);
  }

  void updateRate(double newRate, [String? date]) {
    if (newRate > 0) {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final d = date ?? todayStr;
      _cachedRate = newRate;
      _cachedIsLive = true;
      _cachedIsDailyRate = true;
      _cachedRateDate = d;
      _cachedLastUpdated = DateTime.now();
      state = state.copyWith(
        usdToThbRate: newRate,
        isLive: true,
        isDailyRate: true,
        rateDate: d,
        lastUpdated: _cachedLastUpdated,
      );
    }
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyState>(
  CurrencyNotifier.new,
);

extension CurrencyRefExtension on WidgetRef {
  String formatPrice(double priceInUsd) {
    return watch(currencyProvider).format(priceInUsd);
  }
}
