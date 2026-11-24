import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
    Locale('en'),
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
  /// **'Ceny wrócą do bazowe. Tej czynności nie da się cofnąć.'**
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

  /// No description provided for @pricingErrorPositive.
  ///
  /// In pl, this message translates to:
  /// **'Cena musi być większa od zera.'**
  String get pricingErrorPositive;

  /// No description provided for @pricingErrorMaxPrice.
  ///
  /// In pl, this message translates to:
  /// **'Cena może wynosić najwyżej 99 999 zł.'**
  String get pricingErrorMaxPrice;
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
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
