import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/pricing_formatter.dart';

void main() {
  test('formats PLN with locale grouping', () {
    final f = PricingFormatter(const Locale('pl'));
    expect(f.zloty(99999), contains('99'));
    expect(f.zloty(99999), contains('zł'));
  });

  test('uses ordinary spaces and the 1 200 zł format', () {
    final f = PricingFormatter(const Locale('pl'));
    expect(f.zloty(1200), '1 200 zł');
    expect(f.zloty(1200).contains('\u00A0'), isFalse);
    expect(f.zloty(1200).contains('\u202F'), isFalse);
  });

  test('formats percentages and month names', () {
    final f = PricingFormatter(const Locale('pl'));
    expect(f.percent(16), contains('16'));
    expect(f.percent(16), contains('%'));
    expect(f.monthLong(7), 'Lipiec');
  });
}
