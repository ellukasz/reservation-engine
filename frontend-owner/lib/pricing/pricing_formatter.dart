import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Formatuje kwoty, procenty i nazwy miesięcy zgodnie z locale'em.
class PricingFormatter {
  PricingFormatter(Locale locale)
    : _currency = NumberFormat.currency(
        locale: locale.toLanguageTag(),
        symbol: 'zł',
        decimalDigits: 0,
      ),
      _percent = NumberFormat.percentPattern(locale.toLanguageTag()),
      _month = _monthFormat(locale),
      _monthInDate = _monthInDateFormat(locale);

  static DateFormat _monthFormat(Locale locale) {
    // intl ładuje dane miesięcy osobno; bez tego DateFormat rzuca wyjątek
    // o niezainicjowanym locale (także w izolowanych testach).
    initializeDateFormatting(locale.toLanguageTag());
    return DateFormat.MMMM(locale.toLanguageTag());
  }

  static DateFormat _monthInDateFormat(Locale locale) {
    initializeDateFormatting(locale.toLanguageTag());
    return DateFormat('d MMMM', locale.toLanguageTag());
  }

  /// Niektóre wersje ICU zwracają NBSP / wąski NBSP jako separator grup.
  /// Interfejs i testy oczekują zwykłej spacji (np. „1 200 zł").
  static final RegExp _narrowSpaces = RegExp(r'[\u00A0\u202F\u2007\u2060]');

  final NumberFormat _currency;
  final NumberFormat _percent;
  final DateFormat _month;
  final DateFormat _monthInDate;

  String _ordinarySpaces(String value) => value.replaceAll(_narrowSpaces, ' ');

  /// Kwota w złotych z separatorem tysięcy, np. „1 200 zł".
  String zloty(int value) => _ordinarySpaces(_currency.format(value));

  /// Procent podany jako liczba całkowita, np. 16 -> „16%".
  String percent(int value) => _ordinarySpaces(_percent.format(value / 100));

  /// Pełna nazwa miesiąca (1–12) z wielką literą, np. „Lipiec".
  String monthLong(int month) {
    final name = _month.format(DateTime(2024, month));
    if (name.isEmpty) {
      return name;
    }
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  /// Nazwa miesiąca w formie użytej po „dla", np. „lipca".
  ///
  /// Wzorzec `d MMMM` daje formę zależną od locale'u (po polsku dopełniacz),
  /// a prefiks z dniem jest usuwany — dzięki temu nazwy nie są wpisane w kodzie.
  String monthForOfPhrase(int month) {
    final withDay = _monthInDate.format(DateTime(2024, month));
    return withDay.replaceFirst(RegExp(r'^\d+\s+'), '');
  }
}
