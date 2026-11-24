import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/widgets/pricing_field.dart';

void main() {
  testWidgets('pricing field shows suffix and error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PricingField(
            label: 'Noc w tygodniu',
            value: 350,
            suffix: 'zł',
            errorText: 'Cena musi być większa od zera',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('350'), findsOneWidget);
    expect(find.text('zł'), findsOneWidget);
    expect(find.text('Cena musi być większa od zera'), findsOneWidget);
  });

  testWidgets('reports empty input and keeps the text field empty', (
    tester,
  ) async {
    final empties = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PricingField(
            label: 'Noc w tygodniu',
            value: 350,
            suffix: 'zł',
            onChanged: (_) {},
            onEmptyChanged: empties.add,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(empties, <bool>[true]);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );

    await tester.enterText(find.byType(TextField), '400');
    await tester.pump();
    expect(empties, <bool>[true, false]);
  });

  testWidgets('pricing field accepts only up to five digits', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PricingField(
            label: 'Noc w tygodniu',
            value: 350,
            suffix: 'zł',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '123456');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '12345',
    );

    await tester.enterText(find.byType(TextField), '12a3');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '123',
    );
  });
}
