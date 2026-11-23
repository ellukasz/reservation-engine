import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/app.dart';

void main() {
  testWidgets('app renders localized pricing title', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('pl')];
    addTearDown(() {
      tester.platformDispatcher.clearLocalesTestValue();
    });

    await tester.pumpWidget(const PricingApp());
    await tester.pumpAndSettle();
    expect(find.text('Cennik'), findsOneWidget);
  });

  testWidgets('app uses Material 3 light and dark schemes', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('pl')];
    addTearDown(() {
      tester.platformDispatcher.clearLocalesTestValue();
    });

    await tester.pumpWidget(const PricingApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme!.useMaterial3, isTrue);
    expect(app.darkTheme!.colorScheme.brightness, Brightness.dark);
    expect(app.themeMode, ThemeMode.system);
  });
}
