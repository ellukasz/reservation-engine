import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/widgets/month_tile.dart';

Widget _tile({
  required MonthOverride? override,
  int month = 7,
  int baseWeekdayPrice = 350,
  int baseWeekendPrice = 450,
  int baseMinNights = 1,
  VoidCallback? onTap,
}) {
  return MonthTile(
    month: month,
    override: override,
    baseWeekdayPrice: baseWeekdayPrice,
    baseWeekendPrice: baseWeekendPrice,
    baseMinNights: baseMinNights,
    onTap: onTap ?? () {},
  );
}

Widget _harness(Widget tile, {TextScaler? textScaler}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: tile)),
  );
}

void main() {
  testWidgets('tile shows both prices and minimum in separate lines', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      _harness(
        _tile(
          override: const MonthOverride(
            month: 7,
            weekdayPrice: 450,
            weekendPrice: 550,
            minimumNights: 2,
          ),
        ),
      ),
    );
    expect(find.text('Lipiec'), findsOneWidget);
    expect(find.text('Własna'), findsOneWidget);
    expect(find.text('tydzień:'), findsOneWidget);
    expect(find.text('450 zł'), findsOneWidget);
    expect(find.text('weekend:'), findsOneWidget);
    expect(find.text('550 zł'), findsOneWidget);
    expect(find.text('2 noce'), findsOneWidget);
    expect(find.text('Zmień'), findsOneWidget);

    expect(
      tester.getBottomLeft(find.text('tydzień:')).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.text('450 zł')).dy),
    );
    expect(
      tester.getBottomLeft(find.text('weekend:')).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.text('550 zł')).dy),
    );
  });

  testWidgets(
    'tile without override shows shared prices and inherited minimum',
    (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('pl');
      addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

      await tester.pumpWidget(_harness(_tile(override: null)));

      expect(find.text('Wspólna'), findsOneWidget);
      expect(find.text('350 zł'), findsOneWidget);
      expect(find.text('450 zł'), findsOneWidget);
      expect(find.text('jak w ośrodku'), findsOneWidget);
      expect(find.text('Ustaw'), findsOneWidget);
      expect(find.text('Zmień'), findsNothing);
    },
  );

  testWidgets('whole tile is one button with a screen reader label', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    var taps = 0;
    await tester.pumpWidget(
      _harness(
        _tile(
          override: const MonthOverride(
            month: 7,
            weekdayPrice: 450,
            weekendPrice: 550,
            minimumNights: 2,
          ),
          onTap: () => taps++,
        ),
      ),
    );

    final semanticsHandle = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel(
        'Lipiec, własna cena, tydzień 450 zł, weekend 550 zł, minimum 2 noce, zmień',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byType(MonthTile));
    expect(taps, 1);
    expect(
      tester.getSize(find.byType(MonthTile)).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(MonthTile)).width,
      greaterThanOrEqualTo(48),
    );
    semanticsHandle.dispose();
  });

  testWidgets('minimum nights uses Polish plural forms', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      _harness(
        _tile(
          override: const MonthOverride(
            month: 7,
            weekdayPrice: 450,
            weekendPrice: 550,
            minimumNights: 1,
          ),
        ),
      ),
    );
    expect(find.text('1 noc'), findsOneWidget);
    expect(find.text('1 noce'), findsNothing);

    await tester.pumpWidget(
      _harness(
        _tile(
          override: const MonthOverride(
            month: 7,
            weekdayPrice: 450,
            weekendPrice: 550,
            minimumNights: 5,
          ),
        ),
      ),
    );
    expect(find.text('5 nocy'), findsOneWidget);
  });

  testWidgets('long Polish month and 99 999 zł fit at 200% text scale', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        _tile(
          month: 10,
          override: const MonthOverride(
            month: 10,
            weekdayPrice: 99999,
            weekendPrice: 99999,
            minimumNights: 14,
          ),
        ),
        textScaler: const TextScaler.linear(2.0),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Październik'), findsOneWidget);
    expect(find.text('99 999 zł'), findsNWidgets(2));

    final tileRect = tester.getRect(find.byType(MonthTile));
    final elements = <Element>[
      ...find.text('Październik').evaluate(),
      ...find.text('99 999 zł').evaluate(),
    ];
    for (final element in elements) {
      final box = element.renderObject! as RenderBox;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      expect(rect.left, greaterThanOrEqualTo(tileRect.left));
      expect(rect.right, lessThanOrEqualTo(tileRect.right));
      expect(rect.bottom, lessThanOrEqualTo(tileRect.bottom));
    }
  });

  testWidgets('long English month fits at 200% text scale', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        _tile(
          month: 9,
          override: const MonthOverride(
            month: 9,
            weekdayPrice: 99999,
            weekendPrice: 99999,
            minimumNights: 14,
          ),
        ),
        textScaler: const TextScaler.linear(2.0),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('September'), findsOneWidget);

    final tileRect = tester.getRect(find.byType(MonthTile));
    final box =
        find.text('September').evaluate().single.renderObject! as RenderBox;
    final textRect = box.localToGlobal(Offset.zero) & box.size;
    expect(textRect.left, greaterThanOrEqualTo(tileRect.left));
    expect(textRect.right, lessThanOrEqualTo(tileRect.right));
  });
}
