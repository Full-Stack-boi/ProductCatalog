import 'package:flutter/widgets.dart';
import 'package:product_catalog/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension LocaleDisplayNameX on Locale {
  String get nativeDisplayName {
    try {
      return lookupAppLocalizations(this).appLanguageName;
    } catch (_) {
      return languageCode.toUpperCase();
    }
  }
}
