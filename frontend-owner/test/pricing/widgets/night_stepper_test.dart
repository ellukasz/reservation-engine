import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/widgets/night_stepper.dart';

void main() {
  testWidgets('night stepper clamps at 1 and 14 and has 48dp targets', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() {
      tester.platformDispatcher.clearLocaleTestValue();
    });

    var value = 1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => NightStepper(
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Zmniejsz minimalny pobyt o 1 noc'));
    expect(value, 1);
    for (var i = 0; i < 20; i++) {
      await tester.tap(find.byTooltip('Zwiększ minimalny pobyt o 1 noc'));
    }
    expect(value, 14);
    expect(
      tester.getSize(find.byType(IconButton).first).height,
      greaterThanOrEqualTo(48),
    );
  });
}
