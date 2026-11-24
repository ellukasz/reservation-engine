import 'model/month_override.dart';
import 'model/pricing_draft.dart';
import 'model/pricing_error.dart';
import 'model/pricing_field.dart';

/// Sprawdza wartości cennika przed zapisem.
abstract final class PricingValidator {
  static const int _maxPrice = 99999;
  static const int _maxPercent = 100;
  static const int _minDepositPercent = 10;
  static const int _maxNights = 14;

  /// Zwraca błędy kluczowane polem; pusta mapa oznacza poprawny formularz.
  ///
  /// Pola z [emptyFields] są wymagane i dostają błąd [PricingError.required]
  /// z najwyższym priorytetem — puste pole nie może zostać uznane za zero.
  static Map<PricingField, PricingError> validateDraft(
    PricingDraft draft, {
    Set<PricingField> emptyFields = const {},
  }) {
    final errors = <PricingField, PricingError>{};

    _validatePrice(
      errors,
      PricingField.weekdayPrice,
      draft.weekdayPrice,
      emptyFields,
    );
    _validatePrice(
      errors,
      PricingField.weekendPrice,
      draft.weekendPrice,
      emptyFields,
    );
    _validatePercent(
      errors,
      PricingField.bookingMarkup,
      draft.bookingMarkup,
      emptyFields,
    );
    _validatePercent(
      errors,
      PricingField.airbnbMarkup,
      draft.airbnbMarkup,
      emptyFields,
    );

    if (emptyFields.contains(PricingField.depositPercent)) {
      errors[PricingField.depositPercent] = PricingError.required;
    } else if (draft.depositPercent < _minDepositPercent ||
        draft.depositPercent > _maxPercent) {
      errors[PricingField.depositPercent] = PricingError.depositRange;
    }
    if (emptyFields.contains(PricingField.minNights)) {
      errors[PricingField.minNights] = PricingError.required;
    } else if (draft.minNights < 1 || draft.minNights > _maxNights) {
      errors[PricingField.minNights] = PricingError.minNightsRange;
    }

    return errors;
  }

  /// Sprawdza ceny wpisu miesięcznego; dziedziczone minimum jest poprawne.
  ///
  /// Puste ceny wpisu są zgłaszane jako [PricingError.required].
  static Map<PricingField, PricingError> validateOverride(
    MonthOverride override, {
    Set<PricingField> emptyFields = const {},
  }) {
    final errors = <PricingField, PricingError>{};

    _validatePrice(
      errors,
      PricingField.weekdayPrice,
      override.weekdayPrice,
      emptyFields,
    );
    _validatePrice(
      errors,
      PricingField.weekendPrice,
      override.weekendPrice,
      emptyFields,
    );

    return errors;
  }

  static void _validatePrice(
    Map<PricingField, PricingError> errors,
    PricingField field,
    int price,
    Set<PricingField> emptyFields,
  ) {
    if (emptyFields.contains(field)) {
      errors[field] = PricingError.required;
    } else if (price <= 0) {
      errors[field] = PricingError.positive;
    } else if (price > _maxPrice) {
      errors[field] = PricingError.maxPrice;
    }
  }

  static void _validatePercent(
    Map<PricingField, PricingError> errors,
    PricingField field,
    int percent,
    Set<PricingField> emptyFields,
  ) {
    if (emptyFields.contains(field)) {
      errors[field] = PricingError.required;
    } else if (percent < 0 || percent > _maxPercent) {
      errors[field] = PricingError.percentRange;
    }
  }
}
