// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pricing';

  @override
  String get pricingTitle => 'Pricing';

  @override
  String get pricingFieldHelper => 'Digits only, no decimals';

  @override
  String get pricingDecreaseMinStay => 'Decrease minimum stay by 1 night';

  @override
  String get pricingIncreaseMinStay => 'Increase minimum stay by 1 night';

  @override
  String pricingNightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# nights',
      one: '# night',
    );
    return '$_temp0';
  }
}
