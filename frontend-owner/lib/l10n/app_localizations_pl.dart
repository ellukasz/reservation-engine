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
  String get pricingSubtitle => 'Cały ośrodek';

  @override
  String get pricingSectionNightly => 'Ceny za noc';

  @override
  String get pricingSectionPortals => 'Ceny w portalach';

  @override
  String get pricingSectionReservation => 'Rezerwacja';

  @override
  String get pricingWeekdayLabel => 'Noc w tygodniu (nd–czw)';

  @override
  String get pricingWeekendLabel => 'Noc w weekend (pt–sob)';

  @override
  String get pricingBookingIncrease => 'Booking — podwyższ cenę o';

  @override
  String get pricingAirbnbIncrease => 'Airbnb — podwyższ cenę o';

  @override
  String get pricingDepositLabel => 'Zaliczka';

  @override
  String get pricingPercentUnit => '%';

  @override
  String get pricingWeekdaySemantic => 'Cena za noc w tygodniu, w złotych';

  @override
  String get pricingWeekendSemantic => 'Cena za noc w weekend, w złotych';

  @override
  String get pricingBookingSemantic => 'Narzut na Booking, w procentach';

  @override
  String get pricingAirbnbSemantic => 'Narzut na Airbnb, w procentach';

  @override
  String get pricingDepositSemantic => 'Zaliczka, w procentach';

  @override
  String get pricingMinStaySemantic => 'Minimalny pobyt, w nocach';

  @override
  String get pricingPortalBooking => 'Booking';

  @override
  String get pricingPortalAirbnb => 'Airbnb';

  @override
  String pricingPortalPriceIntro(String portal) {
    return 'Cena w $portal:';
  }

  @override
  String get pricingPortalUnchanged => 'Cena w portalu bez zmian';

  @override
  String pricingDepositExample(String total, String online, String onsite) {
    return 'Przy $total: $online online, $onsite na miejscu.';
  }

  @override
  String get pricingDepositFullOnline => 'Gość płaci całość online';

  @override
  String get pricingSave => 'Zapisz zmiany';

  @override
  String get pricingSaving => 'Zapisuję…';

  @override
  String get pricingSaved => 'Zapisano ✓';

  @override
  String pricingLastSaved(String time) {
    return 'Ostatnio zapisano dziś o $time.';
  }

  @override
  String get pricingMonthsAction => 'Zmień ceny w miesiącach';

  @override
  String get pricingMonthsCollapse => 'Zwiń';

  @override
  String get pricingMonthsHint => 'dotyczy każdego roku';

  @override
  String get pricingMonthsEmpty =>
      'Nie masz jeszcze własnych cen na miesiące. Wszędzie obowiązuje cena wspólna.';

  @override
  String get pricingDiscardTitle => 'Masz niezapisane zmiany. Odrzucić?';

  @override
  String get pricingStay => 'Zostań';

  @override
  String get pricingDiscard => 'Odrzuć';

  @override
  String get pricingLoadError => 'Nie udało się wczytać cennika.';

  @override
  String get pricingSaveError => 'Nie udało się zapisać. Spróbuj ponownie.';

  @override
  String get pricingRetry => 'Spróbuj ponownie';

  @override
  String get pricingSyncSaved => 'Zapisano. Wysyłamy ceny do portali.';

  @override
  String pricingSyncConfirmed(String portal) {
    return '$portal — potwierdzone ✓';
  }

  @override
  String pricingSyncPending(String portal) {
    return '$portal — czeka na potwierdzenie…';
  }

  @override
  String pricingSyncFailedRow(String portal) {
    return '$portal — nie potwierdził cen';
  }

  @override
  String pricingSyncFailedBanner(String portal) {
    return '$portal nie potwierdził cen. Spróbujemy ponownie automatycznie.';
  }

  @override
  String get pricingSyncOffline =>
      'Brak internetu. Nie możemy teraz wysłać cen do portali.';

  @override
  String get pricingSyncRetryNow => 'Spróbuj teraz';

  @override
  String get pricingBasePricesNotice =>
      'To są ceny bazowe — wpis nie został utworzony';

  @override
  String get pricingErrorRequired => 'Wpisz wartość.';

  @override
  String get pricingErrorPositive => 'Cena musi być większa od zera.';

  @override
  String get pricingErrorWholeZloty => 'Podaj pełne złote, bez groszy.';

  @override
  String get pricingErrorMaxPrice => 'Cena może wynosić najwyżej 99 999 zł.';

  @override
  String get pricingErrorPercentRange => 'Podaj wartość od 0 do 100%.';

  @override
  String get pricingErrorDepositRange => 'Zaliczka od 10 do 100%.';

  @override
  String get pricingErrorMinNightsRange => 'Minimum od 1 do 14 nocy.';

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
      'Ceny wrócą do bazowych. Tej czynności nie da się cofnąć.';

  @override
  String get pricingCancel => 'Anuluj';

  @override
  String get pricingDelete => 'Usuń';

  @override
  String pricingErrorSummary(int count) {
    return 'Do poprawy: $count.';
  }
}
