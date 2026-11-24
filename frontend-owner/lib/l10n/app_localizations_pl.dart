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
      other: '$count nocy',
      many: '$count nocy',
      few: '$count noce',
      one: '$count noc',
    );
    return '$_temp0';
  }

  @override
  String get pricingLegendTitle => 'Legenda';

  @override
  String get pricingLegendCollapsedLabel => 'Legenda, zwinięta';

  @override
  String get pricingLegendExpandedLabel => 'Legenda, rozwinięta';

  @override
  String get pricingLegendExpand => 'Rozwiń ▼';

  @override
  String get pricingLegendCollapse => 'Zwiń ▲';

  @override
  String get pricingMonthsLegendWeekTitle => 'tydzień (nd–czw)';

  @override
  String get pricingMonthsLegendWeek => 'Noce od niedzieli do czwartku.';

  @override
  String get pricingMonthsLegendWeekendTitle => 'weekend (pt–sob)';

  @override
  String get pricingMonthsLegendWeekend =>
      'Noce z piątku na sobotę i z soboty na niedzielę.';

  @override
  String get pricingMonthsLegendOwn => 'Własna cena — tylko dla tego miesiąca.';

  @override
  String get pricingMonthsLegendShared =>
      'Wspólna — gdy miesiąc nie ma własnej ceny.';

  @override
  String get pricingWeekdayPriceLabel => 'tydzień:';

  @override
  String get pricingWeekendPriceLabel => 'weekend:';

  @override
  String get pricingMinStayShort => 'min.';

  @override
  String get pricingInheritedMinStay => 'jak w ośrodku';

  @override
  String get pricingTileOwn => 'Własna';

  @override
  String get pricingTileShared => 'Wspólna';

  @override
  String get pricingTileOwnPrice => 'własna cena';

  @override
  String get pricingTileSharedPrice => 'wspólna cena';

  @override
  String get pricingChange => 'Zmień';

  @override
  String get pricingSet => 'Ustaw';

  @override
  String get pricingChangeSpoken => 'zmień';

  @override
  String get pricingSetSpoken => 'ustaw';

  @override
  String pricingTileSemantics(
    String month,
    String ownership,
    String weekday,
    String weekend,
    String minimum,
    String action,
  ) {
    return '$month, $ownership, tydzień $weekday, weekend $weekend, minimum $minimum, $action';
  }

  @override
  String pricingEntryTitle(String month) {
    return '$month — wpis';
  }

  @override
  String get pricingEntrySubtitle => 'dotyczy każdego roku';

  @override
  String get pricingMinStayLabel => 'Minimalny pobyt';

  @override
  String get pricingWeekdayFieldLabel => 'Cena nd–czw';

  @override
  String get pricingWeekendFieldLabel => 'Cena pt–sob';

  @override
  String get pricingCurrencyUnit => 'zł';

  @override
  String pricingUseResortMinimum(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nocy',
      many: '$count nocy',
      few: '$count noce',
      one: '$count noc',
    );
    return 'Użyj minimum ośrodka ($_temp0)';
  }

  @override
  String get pricingDeleteEntry => 'Usuń wpis';

  @override
  String pricingDeleteConfirmTitle(String month) {
    return 'Usunąć wpis dla $month?';
  }

  @override
  String get pricingDeleteConfirmBody =>
      'Ceny wrócą do bazowe. Tej czynności nie da się cofnąć.';

  @override
  String get pricingCancel => 'Anuluj';

  @override
  String get pricingDelete => 'Usuń';

  @override
  String get pricingErrorPositive => 'Cena musi być większa od zera.';

  @override
  String get pricingErrorMaxPrice => 'Cena może wynosić najwyżej 99 999 zł.';
}
