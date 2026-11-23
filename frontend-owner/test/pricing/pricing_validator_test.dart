import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/model/pricing_error.dart';
import 'package:frontend_owner/pricing/model/pricing_field.dart';
import 'package:frontend_owner/pricing/pricing_validator.dart';

void main() {
  test('rejects zero and too-large prices', () {
    expect(
      PricingValidator.validateDraft(
        PricingDraft.initial().copyWith(weekdayPrice: 0),
      ),
      containsPair(PricingField.weekdayPrice, PricingError.positive),
    );
    expect(
      PricingValidator.validateDraft(
        PricingDraft.initial().copyWith(weekendPrice: 100000),
      ),
      containsPair(PricingField.weekendPrice, PricingError.maxPrice),
    );
  });

  test('accepts boundary values', () {
    final draft = PricingDraft.initial().copyWith(
      bookingMarkup: 0,
      airbnbMarkup: 100,
      depositPercent: 10,
      minNights: 14,
    );
    expect(PricingValidator.validateDraft(draft), isEmpty);
  });

  test('rejects out-of-range deposit and minimum', () {
    expect(
      PricingValidator.validateDraft(
        PricingDraft.initial().copyWith(depositPercent: 5),
      ),
      containsPair(PricingField.depositPercent, PricingError.depositRange),
    );
    expect(
      PricingValidator.validateDraft(
        PricingDraft.initial().copyWith(minNights: 15),
      ),
      containsPair(PricingField.minNights, PricingError.minNightsRange),
    );
  });

  test('override inherits minimum when minimumNights is null', () {
    const override = MonthOverride(
      month: 7,
      weekdayPrice: 450,
      weekendPrice: 550,
    );
    expect(override.minimumNights, isNull);
    expect(PricingValidator.validateOverride(override), isEmpty);
  });
}
