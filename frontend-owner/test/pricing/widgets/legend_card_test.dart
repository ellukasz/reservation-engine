import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/widgets/legend_card.dart';

void main() {
  testWidgets('legend is collapsed by default and expands on tap', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LegendCard())),
    );
    expect(find.text('Rozwiń ▼'), findsOneWidget);
    expect(find.text('Noce od niedzieli do czwartku.'), findsNothing);
    await tester.tap(find.text('Rozwiń ▼'));
    await tester.pump();
    expect(find.text('Noce od niedzieli do czwartku.'), findsOneWidget);
    expect(find.text('Zwiń ▲'), findsOneWidget);
  });

  testWidgets(
    'expanded legend shows both definitions, separator and colour meanings',
    (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('pl');
      addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LegendCard(initiallyExpanded: true)),
        ),
      );

      expect(find.text('tydzień (nd–czw)'), findsOneWidget);
      expect(find.text('Noce od niedzieli do czwartku.'), findsOneWidget);
      expect(find.text('weekend (pt–sob)'), findsOneWidget);
      expect(
        find.text('Noce z piątku na sobotę i z soboty na niedzielę.'),
        findsOneWidget,
      );
      expect(find.byType(Divider), findsOneWidget);
      expect(
        find.text('Własna cena — tylko dla tego miesiąca.'),
        findsOneWidget,
      );
      expect(
        find.text('Wspólna — gdy miesiąc nie ma własnej ceny.'),
        findsOneWidget,
      );

      final semanticsHandle = tester.ensureSemantics();
      expect(
        find.bySemanticsLabel('Noce od niedzieli do czwartku.'),
        findsOneWidget,
      );
      semanticsHandle.dispose();
    },
  );

  testWidgets('legend header is a semantics button announcing its state', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LegendCard())),
    );
    final semanticsHandle = tester.ensureSemantics();

    expect(find.bySemanticsLabel('Legenda, zwinięta'), findsOneWidget);
    final collapsed = tester.getSemantics(
      find.bySemanticsLabel('Legenda, zwinięta'),
    );
    expect(collapsed.flagsCollection.isButton, isTrue);
    expect(collapsed.flagsCollection.isExpanded, Tristate.isFalse);

    await tester.tap(find.text('Rozwiń ▼'));
    await tester.pump();

    expect(find.bySemanticsLabel('Legenda, rozwinięta'), findsOneWidget);
    final expanded = tester.getSemantics(
      find.bySemanticsLabel('Legenda, rozwinięta'),
    );
    expect(expanded.flagsCollection.isButton, isTrue);
    expect(expanded.flagsCollection.isExpanded, Tristate.isTrue);
    semanticsHandle.dispose();
  });

  testWidgets('collapsing hides definitions again', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LegendCard(initiallyExpanded: true)),
      ),
    );
    await tester.tap(find.text('Zwiń ▲'));
    await tester.pump();

    expect(find.text('Rozwiń ▼'), findsOneWidget);
    expect(find.text('Noce od niedzieli do czwartku.'), findsNothing);
  });
}
