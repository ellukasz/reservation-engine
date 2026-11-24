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
      other: '$count nights',
      one: '$count night',
    );
    return '$_temp0';
  }

  @override
  String get pricingLegendTitle => 'Legend';

  @override
  String get pricingLegendCollapsedLabel => 'Legend, collapsed';

  @override
  String get pricingLegendExpandedLabel => 'Legend, expanded';

  @override
  String get pricingLegendExpand => 'Expand ▼';

  @override
  String get pricingLegendCollapse => 'Collapse ▲';

  @override
  String get pricingMonthsLegendWeekTitle => 'weekday (Sun–Thu)';

  @override
  String get pricingMonthsLegendWeek => 'Nights from Sunday through Thursday.';

  @override
  String get pricingMonthsLegendWeekendTitle => 'weekend (Fri–Sat)';

  @override
  String get pricingMonthsLegendWeekend =>
      'Nights from Friday to Saturday and from Saturday to Sunday.';

  @override
  String get pricingMonthsLegendOwn => 'Own price — only for this month.';

  @override
  String get pricingMonthsLegendShared =>
      'Shared price — used when the month has no own price.';

  @override
  String get pricingWeekdayPriceLabel => 'weekday:';

  @override
  String get pricingWeekendPriceLabel => 'weekend:';

  @override
  String get pricingMinStayShort => 'min.';

  @override
  String get pricingInheritedMinStay => 'same as the resort';

  @override
  String get pricingTileOwn => 'Own';

  @override
  String get pricingTileShared => 'Shared';

  @override
  String get pricingTileOwnPrice => 'own price';

  @override
  String get pricingTileSharedPrice => 'shared price';

  @override
  String get pricingChange => 'Change';

  @override
  String get pricingSet => 'Set';

  @override
  String get pricingChangeSpoken => 'change';

  @override
  String get pricingSetSpoken => 'set';

  @override
  String pricingTileSemantics(
    String month,
    String ownership,
    String weekday,
    String weekend,
    String minimum,
    String action,
  ) {
    return '$month, $ownership, weekday $weekday, weekend $weekend, minimum $minimum, $action';
  }

  @override
  String pricingEntryTitle(String month) {
    return '$month — entry';
  }

  @override
  String get pricingEntrySubtitle => 'applies every year';

  @override
  String get pricingMinStayLabel => 'Minimum stay';

  @override
  String get pricingWeekdayFieldLabel => 'Weekday price (Sun–Thu)';

  @override
  String get pricingWeekendFieldLabel => 'Weekend price (Fri–Sat)';

  @override
  String get pricingCurrencyUnit => 'zł';

  @override
  String pricingUseResortMinimum(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '$count night',
    );
    return 'Use resort minimum ($_temp0)';
  }

  @override
  String get pricingDeleteEntry => 'Delete entry';

  @override
  String pricingDeleteConfirmTitle(String month) {
    return 'Delete entry for $month?';
  }

  @override
  String get pricingDeleteConfirmBody =>
      'Prices will return to the base prices. This cannot be undone.';

  @override
  String get pricingCancel => 'Cancel';

  @override
  String get pricingDelete => 'Delete';

  @override
  String get pricingErrorPositive => 'Price must be greater than zero.';

  @override
  String get pricingErrorMaxPrice => 'Price cannot exceed 99 999 zł.';
}
