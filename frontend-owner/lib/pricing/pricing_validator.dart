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
  static Map<PricingField, PricingError> validateDraft(PricingDraft draft) {
    final errors = <PricingField, PricingError>{};

    _validatePrice(errors, PricingField.weekdayPrice, draft.weekdayPrice);
    _validatePrice(errors, PricingField.weekendPrice, draft.weekendPrice);
    _validatePercent(errors, PricingField.bookingMarkup, draft.bookingMarkup);
    _validatePercent(errors, PricingField.airbnbMarkup, draft.airbnbMarkup);

    if (draft.depositPercent < _minDepositPercent ||
        draft.depositPercent > _maxPercent) {
      errors[PricingField.depositPercent] = PricingError.depositRange;
    }
    if (draft.minNights < 1 || draft.minNights > _maxNights) {
      errors[PricingField.minNights] = PricingError.minNightsRange;
    }

    return errors;
  }

  /// Sprawdza ceny wpisu miesięcznego; dziedziczone minimum jest poprawne.
  static Map<PricingField, PricingError> validateOverride(
    MonthOverride override,
  ) {
    final errors = <PricingField, PricingError>{};

    _validatePrice(errors, PricingField.weekdayPrice, override.weekdayPrice);
    _validatePrice(errors, PricingField.weekendPrice, override.weekendPrice);

    return errors;
  }

  static void _validatePrice(
    Map<PricingField, PricingError> errors,
    PricingField field,
    int price,
  ) {
    if (price <= 0) {
      errors[field] = PricingError.positive;
    } else if (price > _maxPrice) {
      errors[field] = PricingError.maxPrice;
    }
  }

  static void _validatePercent(
    Map<PricingField, PricingError> errors,
    PricingField field,
    int percent,
  ) {
    if (percent < 0 || percent > _maxPercent) {
      errors[field] = PricingError.percentRange;
    }
  }
}
