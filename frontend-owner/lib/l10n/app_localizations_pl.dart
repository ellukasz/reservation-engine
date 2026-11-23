// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Cennik';

  @override
  String get pricingTitle => 'Cennik';

  @override
  String get pricingFieldHelper => 'Tylko cyfry, bez groszy';

  @override
  String get pricingDecreaseMinStay => 'Zmniejsz minimalny pobyt o 1 noc';

  @override
  String get pricingIncreaseMinStay => 'Zwiększ minimalny pobyt o 1 noc';

  @override
  String pricingNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# nocy',
      many: '# nocy',
      few: '# noce',
      one: '# noc',
    );
    return '$_temp0';
  }
}
