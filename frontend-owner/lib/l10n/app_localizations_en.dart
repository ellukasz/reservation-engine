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
  String get pricingSubtitle => 'Entire property';

  @override
  String get pricingSectionNightly => 'Nightly prices';

  @override
  String get pricingSectionPortals => 'Prices on portals';

  @override
  String get pricingSectionReservation => 'Booking';

  @override
  String get pricingWeekdayLabel => 'Weekday night (Sun–Thu)';

  @override
  String get pricingWeekendLabel => 'Weekend night (Fri–Sat)';

  @override
  String get pricingBookingIncrease => 'Booking — increase price by';

  @override
  String get pricingAirbnbIncrease => 'Airbnb — increase price by';

  @override
  String get pricingDepositLabel => 'Deposit';

  @override
  String get pricingPercentUnit => '%';

  @override
  String get pricingWeekdaySemantic => 'Weekday nightly price, in złoty';

  @override
  String get pricingWeekendSemantic => 'Weekend nightly price, in złoty';

  @override
  String get pricingBookingSemantic => 'Booking markup, in percent';

  @override
  String get pricingAirbnbSemantic => 'Airbnb markup, in percent';

  @override
  String get pricingDepositSemantic => 'Deposit, in percent';

  @override
  String get pricingMinStaySemantic => 'Minimum stay, in nights';

  @override
  String get pricingPortalBooking => 'Booking';

  @override
  String get pricingPortalAirbnb => 'Airbnb';

  @override
  String pricingPortalPriceIntro(String portal) {
    return 'Price on $portal:';
  }

  @override
  String get pricingPortalUnchanged => 'Price unchanged on the portal';

  @override
  String pricingDepositExample(String total, String online, String onsite) {
    return 'For $total: $online online, $onsite on site.';
  }

  @override
  String get pricingDepositFullOnline => 'Guest pays everything online';

  @override
  String get pricingSave => 'Save changes';

  @override
  String get pricingSaving => 'Saving…';

  @override
  String get pricingSaved => 'Saved ✓';

  @override
  String pricingLastSaved(String time) {
    return 'Last saved today at $time.';
  }

  @override
  String get pricingMonthsAction => 'Change monthly prices';

  @override
  String get pricingMonthsCollapse => 'Collapse';

  @override
  String get pricingMonthsHint => 'applies every year';

  @override
  String get pricingMonthsEmpty =>
      'You don\'t have any own monthly prices yet. The shared price applies everywhere.';

  @override
  String get pricingDiscardTitle => 'You have unsaved changes. Discard them?';

  @override
  String get pricingStay => 'Stay';

  @override
  String get pricingDiscard => 'Discard';

  @override
  String get pricingLoadError => 'Could not load the pricing.';

  @override
  String get pricingSaveError => 'Could not save. Try again.';

  @override
  String get pricingRetry => 'Try again';

  @override
  String get pricingSyncSaved => 'Saved. Sending prices to portals.';

  @override
  String pricingSyncConfirmed(String portal) {
    return '$portal — confirmed ✓';
  }

  @override
  String pricingSyncPending(String portal) {
    return '$portal — waiting for confirmation…';
  }

  @override
  String pricingSyncFailedRow(String portal) {
    return '$portal — has not confirmed the prices';
  }

  @override
  String pricingSyncFailedBanner(String portal) {
    return '$portal did not confirm the prices. We\'ll try again automatically.';
  }

  @override
  String get pricingSyncOffline =>
      'No internet. We can\'t send prices to portals right now.';

  @override
  String get pricingSyncRetryNow => 'Try now';

  @override
  String get pricingBasePricesNotice =>
      'These are the base prices — no entry was created';

  @override
  String get pricingErrorRequired => 'Enter a value.';

  @override
  String get pricingErrorPositive => 'Price must be greater than zero.';

  @override
  String get pricingErrorWholeZloty => 'Enter whole złoty, without decimals.';

  @override
  String get pricingErrorMaxPrice => 'Price cannot exceed 99 999 zł.';

  @override
  String get pricingErrorPercentRange => 'Enter a value from 0 to 100%.';

  @override
  String get pricingErrorDepositRange => 'Deposit must be from 10 to 100%.';

  @override
  String get pricingErrorMinNightsRange =>
      'Minimum stay must be from 1 to 14 nights.';

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
}
