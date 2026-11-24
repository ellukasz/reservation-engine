import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/widgets/month_grid.dart';
import 'package:frontend_owner/pricing/widgets/month_tile.dart';

Widget _grid({
  required ValueChanged<int> onMonthTap,
  List<MonthOverride> overrides = const [],
  PricingDraft? draft,
}) {
  return MonthGrid(
    draft: draft ?? PricingDraft.initial(),
    overrides: overrides,
    onMonthTap: onMonthTap,
  );
}

Widget _harness(Widget grid, {TextScaler? textScaler}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: grid),
  );
}

void main() {
  testWidgets('grid uses one column when text scale is large', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: Scaffold(
          body: MonthGrid(
            draft: PricingDraft.initial(),
            overrides: const [],
            onMonthTap: (_) {},
          ),
        ),
      ),
    );
    final tiles = tester.widgetList(find.byType(MonthTile)).toList();
    final first = tester.getTopLeft(find.byWidget(tiles[0]));
    final second = tester.getTopLeft(find.byWidget(tiles[1]));
    expect(first.dx, second.dx);
    expect(second.dy, greaterThan(first.dy));
  });

  testWidgets('grid uses two columns on a normal phone', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        _grid(onMonthTap: (_) {}),
        textScaler: const TextScaler.linear(1.0),
      ),
    );

    expect(find.byType(MonthTile), findsNWidgets(12));
    final first = tester.getTopLeft(find.byType(MonthTile).at(0));
    final second = tester.getTopLeft(find.byType(MonthTile).at(1));
    expect(first.dy, second.dy);
    expect(second.dx, greaterThan(first.dx));
  });

  testWidgets('grid uses one column below 340dp', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        _grid(onMonthTap: (_) {}),
        textScaler: const TextScaler.linear(1.0),
      ),
    );

    final first = tester.getTopLeft(find.byType(MonthTile).at(0));
    final second = tester.getTopLeft(find.byType(MonthTile).at(1));
    expect(first.dx, second.dx);
    expect(second.dy, greaterThan(first.dy));
  });

  testWidgets('grid keeps calendar order and reports the tapped month', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var tapped = -1;
    await tester.pumpWidget(
      _harness(
        _grid(onMonthTap: (month) => tapped = month),
        textScaler: const TextScaler.linear(1.0),
      ),
    );

    expect(find.text('Styczeń'), findsOneWidget);
    expect(find.text('Grudzień'), findsOneWidget);
    await tester.tap(find.byType(MonthTile).first);
    expect(tapped, 1);
  });

  testWidgets('grid applies each override to its own month', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(
      _harness(
        _grid(
          onMonthTap: (_) {},
          overrides: const [
            MonthOverride(
              month: 7,
              weekdayPrice: 777,
              weekendPrice: 888,
              minimumNights: 3,
            ),
          ],
        ),
      ),
    );

    expect(find.text('777 zł'), findsOneWidget);
    expect(find.text('888 zł'), findsOneWidget);
    expect(find.text('3 noce'), findsOneWidget);
    expect(find.text('350 zł'), findsNWidgets(11));
  });

  testWidgets('grid keeps its scroll position with a PageStorageKey', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());

    await tester.pumpWidget(_harness(_grid(onMonthTap: (_) {})));

    expect(
      find.byKey(const PageStorageKey<String>('pricing-months-grid')),
      findsOneWidget,
    );
  });

  testWidgets('long names and 99 999 zł fit in every tile at 200% scale', (
    tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('pl');
    addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        _grid(
          onMonthTap: (_) {},
          draft: const PricingDraft(
            weekdayPrice: 99999,
            weekendPrice: 99999,
            bookingMarkup: 0,
            airbnbMarkup: 0,
            depositPercent: 30,
            minNights: 14,
          ),
        ),
        textScaler: const TextScaler.linear(2.0),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Październik'), findsOneWidget);
    expect(find.text('99 999 zł'), findsNWidgets(24));

    final octoberTile = find.ancestor(
      of: find.text('Październik'),
      matching: find.byType(MonthTile),
    );
    final tileRect = tester.getRect(octoberTile);
    final texts = find.descendant(
      of: octoberTile,
      matching: find.text('99 999 zł'),
    );
    for (final element in texts.evaluate()) {
      final box = element.renderObject! as RenderBox;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      expect(rect.left, greaterThanOrEqualTo(tileRect.left));
      expect(rect.right, lessThanOrEqualTo(tileRect.right));
      expect(rect.bottom, lessThanOrEqualTo(tileRect.bottom));
    }
  });
}
