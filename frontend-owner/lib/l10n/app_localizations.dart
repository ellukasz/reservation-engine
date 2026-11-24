import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('ar', 'XB'),
    Locale('en'),
    Locale('en', 'XA'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pl, this message translates to:
  /// **'Cennik'**
  String get appTitle;

  /// No description provided for @pricingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Cennik'**
  String get pricingTitle;

  /// No description provided for @pricingSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Cały ośrodek'**
  String get pricingSubtitle;

  /// No description provided for @pricingSectionNightly.
  ///
  /// In pl, this message translates to:
  /// **'Ceny za noc'**
  String get pricingSectionNightly;

  /// No description provided for @pricingSectionPortals.
  ///
  /// In pl, this message translates to:
  /// **'Ceny w portalach'**
  String get pricingSectionPortals;

  /// No description provided for @pricingSectionReservation.
  ///
  /// In pl, this message translates to:
  /// **'Rezerwacja'**
  String get pricingSectionReservation;

  /// No description provided for @pricingWeekdayLabel.
  ///
  /// In pl, this message translates to:
  /// **'Noc w tygodniu (nd–czw)'**
  String get pricingWeekdayLabel;

  /// No description provided for @pricingWeekendLabel.
  ///
  /// In pl, this message translates to:
  /// **'Noc w weekend (pt–sob)'**
  String get pricingWeekendLabel;

  /// No description provided for @pricingBookingIncrease.
  ///
  /// In pl, this message translates to:
  /// **'Booking — podwyższ cenę o'**
  String get pricingBookingIncrease;

  /// No description provided for @pricingAirbnbIncrease.
  ///
  /// In pl, this message translates to:
  /// **'Airbnb — podwyższ cenę o'**
  String get pricingAirbnbIncrease;

  /// No description provided for @pricingDepositLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zaliczka'**
  String get pricingDepositLabel;

  /// No description provided for @pricingPercentUnit.
  ///
  /// In pl, this message translates to:
  /// **'%'**
  String get pricingPercentUnit;

  /// No description provided for @pricingWeekdaySemantic.
  ///
  /// In pl, this message translates to:
  /// **'Cena za noc w tygodniu, w złotych'**
  String get pricingWeekdaySemantic;

  /// No description provided for @pricingWeekendSemantic.
  ///
  /// In pl, this message translates to:
  /// **'Cena za noc w weekend, w złotych'**
  String get pricingWeekendSemantic;

  /// No description provided for @pricingBookingSemantic.
  ///
  /// In pl, this message translates to:
  /// **'Narzut na Booking, w procentach'**
  String get pricingBookingSemantic;

  /// No description provided for @pricingAirbnbSemantic.
  ///
  /// In pl, this message translates to:
  /// **'Narzut na Airbnb, w procentach'**
  String get pricingAirbnbSemantic;

  /// No description provided for @pricingDepositSemantic.
  ///
  /// In pl, this message translates to:
  /// **'Zaliczka, w procentach'**
  String get pricingDepositSemantic;

  /// No description provided for @pricingMinStaySemantic.
  ///
  /// In pl, this message translates to:
  /// **'Minimalny pobyt, w nocach'**
  String get pricingMinStaySemantic;

  /// No description provided for @pricingPortalBooking.
  ///
  /// In pl, this message translates to:
  /// **'Booking'**
  String get pricingPortalBooking;

  /// No description provided for @pricingPortalAirbnb.
  ///
  /// In pl, this message translates to:
  /// **'Airbnb'**
  String get pricingPortalAirbnb;

  /// Podpis nad wyliczoną ceną w portalu.
  ///
  /// In pl, this message translates to:
  /// **'Cena w {portal}:'**
  String pricingPortalPriceIntro(String portal);

  /// No description provided for @pricingPortalUnchanged.
  ///
  /// In pl, this message translates to:
  /// **'Cena w portalu bez zmian'**
  String get pricingPortalUnchanged;

  /// Przykład podziału kwoty przy wpisanej zaliczce.
  ///
  /// In pl, this message translates to:
  /// **'Przy {total}: {online} online, {onsite} na miejscu.'**
  String pricingDepositExample(String total, String online, String onsite);

  /// No description provided for @pricingDepositFullOnline.
  ///
  /// In pl, this message translates to:
  /// **'Gość płaci całość online'**
  String get pricingDepositFullOnline;

  /// No description provided for @pricingSave.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz zmiany'**
  String get pricingSave;

  /// No description provided for @pricingSaving.
  ///
  /// In pl, this message translates to:
  /// **'Zapisuję…'**
  String get pricingSaving;

  /// No description provided for @pricingSaved.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano ✓'**
  String get pricingSaved;

  /// Godzina ostatniego zapisu cennika.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnio zapisano dziś o {time}.'**
  String pricingLastSaved(String time);

  /// No description provided for @pricingMonthsAction.
  ///
  /// In pl, this message translates to:
  /// **'Zmień ceny w miesiącach'**
  String get pricingMonthsAction;

  /// No description provided for @pricingMonthsCollapse.
  ///
  /// In pl, this message translates to:
  /// **'Zwiń'**
  String get pricingMonthsCollapse;

  /// No description provided for @pricingMonthsHint.
  ///
  /// In pl, this message translates to:
  /// **'dotyczy każdego roku'**
  String get pricingMonthsHint;

  /// No description provided for @pricingMonthsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Nie masz jeszcze własnych cen na miesiące. Wszędzie obowiązuje cena wspólna.'**
  String get pricingMonthsEmpty;

  /// No description provided for @pricingDiscardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Masz niezapisane zmiany. Odrzucić?'**
  String get pricingDiscardTitle;

  /// No description provided for @pricingStay.
  ///
  /// In pl, this message translates to:
  /// **'Zostań'**
  String get pricingStay;

  /// No description provided for @pricingDiscard.
  ///
  /// In pl, this message translates to:
  /// **'Odrzuć'**
  String get pricingDiscard;

  /// No description provided for @pricingLoadError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wczytać cennika.'**
  String get pricingLoadError;

  /// No description provided for @pricingSaveError.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zapisać. Spróbuj ponownie.'**
  String get pricingSaveError;

  /// No description provided for @pricingRetry.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get pricingRetry;

  /// No description provided for @pricingSyncSaved.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano. Wysyłamy ceny do portali.'**
  String get pricingSyncSaved;

  /// Status portalu, który potwierdził ceny.
  ///
  /// In pl, this message translates to:
  /// **'{portal} — potwierdzone ✓'**
  String pricingSyncConfirmed(String portal);

  /// Status portalu, który jeszcze nie potwierdził cen.
  ///
  /// In pl, this message translates to:
  /// **'{portal} — czeka na potwierdzenie…'**
  String pricingSyncPending(String portal);

  /// Status portalu, który nie potwierdził cen.
  ///
  /// In pl, this message translates to:
  /// **'{portal} — nie potwierdził cen'**
  String pricingSyncFailedRow(String portal);

  /// Ostrzeżenie o braku potwierdzenia z portalu.
  ///
  /// In pl, this message translates to:
  /// **'{portal} nie potwierdził cen. Spróbujemy ponownie automatycznie.'**
  String pricingSyncFailedBanner(String portal);

  /// No description provided for @pricingSyncOffline.
  ///
  /// In pl, this message translates to:
  /// **'Brak internetu. Nie możemy teraz wysłać cen do portali.'**
  String get pricingSyncOffline;

  /// No description provided for @pricingSyncRetryNow.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj teraz'**
  String get pricingSyncRetryNow;

  /// No description provided for @pricingBasePricesNotice.
  ///
  /// In pl, this message translates to:
  /// **'To są ceny bazowe — wpis nie został utworzony'**
  String get pricingBasePricesNotice;

  /// No description provided for @pricingErrorRequired.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz wartość.'**
  String get pricingErrorRequired;

  /// No description provided for @pricingErrorPositive.
  ///
  /// In pl, this message translates to:
  /// **'Cena musi być większa od zera.'**
  String get pricingErrorPositive;

  /// No description provided for @pricingErrorWholeZloty.
  ///
  /// In pl, this message translates to:
  /// **'Podaj pełne złote, bez groszy.'**
  String get pricingErrorWholeZloty;

  /// No description provided for @pricingErrorMaxPrice.
  ///
  /// In pl, this message translates to:
  /// **'Cena może wynosić najwyżej 99 999 zł.'**
  String get pricingErrorMaxPrice;

  /// No description provided for @pricingErrorPercentRange.
  ///
  /// In pl, this message translates to:
  /// **'Podaj wartość od 0 do 100%.'**
  String get pricingErrorPercentRange;

  /// No description provided for @pricingErrorDepositRange.
  ///
  /// In pl, this message translates to:
  /// **'Zaliczka od 10 do 100%.'**
  String get pricingErrorDepositRange;

  /// No description provided for @pricingErrorMinNightsRange.
  ///
  /// In pl, this message translates to:
  /// **'Minimum od 1 do 14 nocy.'**
  String get pricingErrorMinNightsRange;

  /// No description provided for @pricingFieldHelper.
  ///
  /// In pl, this message translates to:
  /// **'Tylko cyfry, bez groszy'**
  String get pricingFieldHelper;

  /// No description provided for @pricingDecreaseMinStay.
  ///
  /// In pl, this message translates to:
  /// **'Zmniejsz minimalny pobyt o 1 noc'**
  String get pricingDecreaseMinStay;

  /// No description provided for @pricingIncreaseMinStay.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększ minimalny pobyt o 1 noc'**
  String get pricingIncreaseMinStay;

  /// Liczba nocy z jednostką w poprawnej formie gramatycznej.
  ///
  /// In pl, this message translates to:
  /// **'{count, plural, one{{count} noc} few{{count} noce} many{{count} nocy} other{{count} nocy}}'**
  String pricingNightsCount(int count);

  /// No description provided for @pricingLegendTitle.
  ///
  /// In pl, this message translates to:
  /// **'Legenda'**
  String get pricingLegendTitle;

  /// No description provided for @pricingLegendCollapsedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Legenda, zwinięta'**
  String get pricingLegendCollapsedLabel;

  /// No description provided for @pricingLegendExpandedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Legenda, rozwinięta'**
  String get pricingLegendExpandedLabel;

  /// No description provided for @pricingLegendExpand.
  ///
  /// In pl, this message translates to:
  /// **'Rozwiń ▼'**
  String get pricingLegendExpand;

  /// No description provided for @pricingLegendCollapse.
  ///
  /// In pl, this message translates to:
  /// **'Zwiń ▲'**
  String get pricingLegendCollapse;

  /// No description provided for @pricingMonthsLegendWeekTitle.
  ///
  /// In pl, this message translates to:
  /// **'tydzień (nd–czw)'**
  String get pricingMonthsLegendWeekTitle;

  /// No description provided for @pricingMonthsLegendWeek.
  ///
  /// In pl, this message translates to:
  /// **'Noce od niedzieli do czwartku.'**
  String get pricingMonthsLegendWeek;

  /// No description provided for @pricingMonthsLegendWeekendTitle.
  ///
  /// In pl, this message translates to:
  /// **'weekend (pt–sob)'**
  String get pricingMonthsLegendWeekendTitle;

  /// No description provided for @pricingMonthsLegendWeekend.
  ///
  /// In pl, this message translates to:
  /// **'Noce z piątku na sobotę i z soboty na niedzielę.'**
  String get pricingMonthsLegendWeekend;

  /// No description provided for @pricingMonthsLegendOwn.
  ///
  /// In pl, this message translates to:
  /// **'Własna cena — tylko dla tego miesiąca.'**
  String get pricingMonthsLegendOwn;

  /// No description provided for @pricingMonthsLegendShared.
  ///
  /// In pl, this message translates to:
  /// **'Wspólna — gdy miesiąc nie ma własnej ceny.'**
  String get pricingMonthsLegendShared;

  /// No description provided for @pricingWeekdayPriceLabel.
  ///
  /// In pl, this message translates to:
  /// **'tydzień:'**
  String get pricingWeekdayPriceLabel;

  /// No description provided for @pricingWeekendPriceLabel.
  ///
  /// In pl, this message translates to:
  /// **'weekend:'**
  String get pricingWeekendPriceLabel;

  /// No description provided for @pricingMinStayShort.
  ///
  /// In pl, this message translates to:
  /// **'min.'**
  String get pricingMinStayShort;

  /// No description provided for @pricingInheritedMinStay.
  ///
  /// In pl, this message translates to:
  /// **'jak w ośrodku'**
  String get pricingInheritedMinStay;

  /// No description provided for @pricingTileOwn.
  ///
  /// In pl, this message translates to:
  /// **'Własna'**
  String get pricingTileOwn;

  /// No description provided for @pricingTileShared.
  ///
  /// In pl, this message translates to:
  /// **'Wspólna'**
  String get pricingTileShared;

  /// No description provided for @pricingTileOwnPrice.
  ///
  /// In pl, this message translates to:
  /// **'własna cena'**
  String get pricingTileOwnPrice;

  /// No description provided for @pricingTileSharedPrice.
  ///
  /// In pl, this message translates to:
  /// **'wspólna cena'**
  String get pricingTileSharedPrice;

  /// No description provided for @pricingChange.
  ///
  /// In pl, this message translates to:
  /// **'Zmień'**
  String get pricingChange;

  /// No description provided for @pricingSet.
  ///
  /// In pl, this message translates to:
  /// **'Ustaw'**
  String get pricingSet;

  /// No description provided for @pricingChangeSpoken.
  ///
  /// In pl, this message translates to:
  /// **'zmień'**
  String get pricingChangeSpoken;

  /// No description provided for @pricingSetSpoken.
  ///
  /// In pl, this message translates to:
  /// **'ustaw'**
  String get pricingSetSpoken;

  /// Etykieta czytnika dla kafelka miesiąca.
  ///
  /// In pl, this message translates to:
  /// **'{month}, {ownership}, tydzień {weekday}, weekend {weekend}, minimum {minimum}, {action}'**
  String pricingTileSemantics(
    String month,
    String ownership,
    String weekday,
    String weekend,
    String minimum,
    String action,
  );

  /// Nagłówek edytora jednego wpisu miesiąca.
  ///
  /// In pl, this message translates to:
  /// **'{month} — wpis'**
  String pricingEntryTitle(String month);

  /// No description provided for @pricingEntrySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'dotyczy każdego roku'**
  String get pricingEntrySubtitle;

  /// No description provided for @pricingMinStayLabel.
  ///
  /// In pl, this message translates to:
  /// **'Minimalny pobyt'**
  String get pricingMinStayLabel;

  /// No description provided for @pricingWeekdayFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Cena nd–czw'**
  String get pricingWeekdayFieldLabel;

  /// No description provided for @pricingWeekendFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Cena pt–sob'**
  String get pricingWeekendFieldLabel;

  /// No description provided for @pricingCurrencyUnit.
  ///
  /// In pl, this message translates to:
  /// **'zł'**
  String get pricingCurrencyUnit;

  /// Przełącznik dziedziczenia minimum z ośrodka otwartego wpisu.
  ///
  /// In pl, this message translates to:
  /// **'Użyj minimum ośrodka ({count, plural, one{{count} noc} few{{count} noce} many{{count} nocy} other{{count} nocy}})'**
  String pricingUseResortMinimum(int count);

  /// No description provided for @pricingDeleteEntry.
  ///
  /// In pl, this message translates to:
  /// **'Usuń wpis'**
  String get pricingDeleteEntry;

  /// Tytuł potwierdzenia usunięcia wpisu dla wybranego miesiąca.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć wpis dla {month}?'**
  String pricingDeleteConfirmTitle(String month);

  /// No description provided for @pricingDeleteConfirmBody.
  ///
  /// In pl, this message translates to:
  /// **'Ceny wrócą do bazowych. Tej czynności nie da się cofnąć.'**
  String get pricingDeleteConfirmBody;

  /// No description provided for @pricingCancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get pricingCancel;

  /// No description provided for @pricingDelete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get pricingDelete;

  /// Liczba pól do poprawienia po nieudanym zapisie.
  ///
  /// In pl, this message translates to:
  /// **'Do poprawy: {count}.'**
  String pricingErrorSummary(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ar':
      {
        switch (locale.countryCode) {
          case 'XB':
            return AppLocalizationsArXb();
        }
        break;
      }
    case 'en':
      {
        switch (locale.countryCode) {
          case 'XA':
            return AppLocalizationsEnXa();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
