import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('th');

  void setLocale(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }

  void cycleLocale([List<Locale>? supportedLocales]) {
    final locales = supportedLocales ?? AppLocalizations.supportedLocales;
    if (locales.isEmpty) return;
    final currentIndex = locales.indexWhere(
      (l) => l.languageCode == state.languageCode,
    );
    final nextIndex = (currentIndex + 1) % locales.length;
    state = locales[nextIndex];
  }

  void toggleLocale() => cycleLocale();
}
