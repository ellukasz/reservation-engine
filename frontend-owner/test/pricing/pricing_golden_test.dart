import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/l10n/app_localizations.dart';
import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/widgets/month_entry_editor.dart';
import 'package:frontend_owner/pricing/widgets/month_grid.dart';
import 'package:frontend_owner/pricing/widgets/month_tile.dart';

Future<void> _pumpGolden(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(360, 640),
  TextScaler textScaler = const TextScaler.linear(1.0),
}) async {
  tester.platformDispatcher.localeTestValue = const Locale('pl');
  addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pl'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: Scaffold(body: Center(child: widget)),
      ),
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

Widget _grid() => SizedBox(
  width: 336,
  height: 520,
  child: MonthGrid(
    draft: PricingDraft.initial(),
    overrides: const <MonthOverride>[
      MonthOverride(
        month: 7,
        weekdayPrice: 450,
        weekendPrice: 550,
        minimumNights: 2,
      ),
    ],
    onMonthTap: (_) {},
  ),
);

Widget _tile({
  required int nights,
  PricingDraft draft = const PricingDraft(
    weekdayPrice: 450,
    weekendPrice: 550,
    bookingMarkup: 0,
    airbnbMarkup: 0,
    depositPercent: 30,
    minNights: 5,
  ),
}) {
  return SizedBox(
    width: 240,
    child: MonthTile(
      month: 7,
      override: MonthOverride(
        month: 7,
        weekdayPrice: draft.weekdayPrice,
        weekendPrice: draft.weekendPrice,
        minimumNights: nights,
      ),
      baseWeekdayPrice: draft.weekdayPrice,
      baseWeekendPrice: draft.weekendPrice,
      baseMinNights: draft.minNights,
      onTap: () {},
    ),
  );
}

Widget _editor({required int nights, required int price}) => SizedBox(
  width: 320,
  child: MonthEntryEditor(
    override: MonthOverride(
      month: 7,
      weekdayPrice: price,
      weekendPrice: price,
      minimumNights: nights,
    ),
    baseDraft: PricingDraft.initial(),
    isNew: false,
    onChanged: (_) {},
    onDelete: () {},
  ),
);

void main() {
  testWidgets('month grid in two columns', (tester) async {
    await _pumpGolden(tester, _grid());
    await expectLater(
      find.byType(MonthGrid),
      matchesGoldenFile('goldens/month_grid_2col.png'),
    );
  });

  testWidgets('month grid in one column at 200% text scale', (tester) async {
    await _pumpGolden(
      tester,
      _grid(),
      textScaler: const TextScaler.linear(2.0),
    );
    await expectLater(
      find.byType(MonthGrid),
      matchesGoldenFile('goldens/month_grid_1col_200.png'),
    );
  });

  testWidgets('month tile with one night', (tester) async {
    await _pumpGolden(tester, _tile(nights: 1));
    await expectLater(
      find.byType(MonthTile),
      matchesGoldenFile('goldens/month_tile_1_night.png'),
    );
  });

  testWidgets('month tile with two nights', (tester) async {
    await _pumpGolden(tester, _tile(nights: 2));
    expect(find.text('2 noce'), findsOneWidget);
    await expectLater(
      find.byType(MonthTile),
      matchesGoldenFile('goldens/month_tile_2_nights.png'),
    );
  });

  testWidgets('month tile with five nights', (tester) async {
    await _pumpGolden(tester, _tile(nights: 5));
    expect(find.text('5 nocy'), findsOneWidget);
    await expectLater(
      find.byType(MonthTile),
      matchesGoldenFile('goldens/month_tile_5_nights.png'),
    );
  });

  testWidgets('month tile with 99 999 zloty', (tester) async {
    await _pumpGolden(
      tester,
      _tile(
        nights: 5,
        draft: const PricingDraft(
          weekdayPrice: 99999,
          weekendPrice: 99999,
          bookingMarkup: 0,
          airbnbMarkup: 0,
          depositPercent: 30,
          minNights: 5,
        ),
      ),
    );
    await expectLater(
      find.byType(MonthTile),
      matchesGoldenFile('goldens/month_tile_max_price.png'),
    );
  });

  testWidgets('entry editor with one night', (tester) async {
    await _pumpGolden(
      tester,
      _editor(nights: 1, price: 450),
      size: const Size(360, 720),
    );
    expect(find.text('1 noc'), findsOneWidget);
    await expectLater(
      find.byType(MonthEntryEditor),
      matchesGoldenFile('goldens/entry_editor_1_night.png'),
    );
  });

  testWidgets('entry editor with two nights', (tester) async {
    await _pumpGolden(
      tester,
      _editor(nights: 2, price: 450),
      size: const Size(360, 720),
    );
    expect(find.text('2 noce'), findsOneWidget);
    await expectLater(
      find.byType(MonthEntryEditor),
      matchesGoldenFile('goldens/entry_editor_2_nights.png'),
    );
  });

  testWidgets('entry editor with five nights', (tester) async {
    await _pumpGolden(
      tester,
      _editor(nights: 5, price: 450),
      size: const Size(360, 720),
    );
    expect(find.text('5 nocy'), findsOneWidget);
    await expectLater(
      find.byType(MonthEntryEditor),
      matchesGoldenFile('goldens/entry_editor_5_nights.png'),
    );
  });

  testWidgets('entry editor with 99 999 zloty', (tester) async {
    await _pumpGolden(
      tester,
      _editor(nights: 5, price: 99999),
      size: const Size(360, 720),
    );
    await expectLater(
      find.byType(MonthEntryEditor),
      matchesGoldenFile('goldens/entry_editor_max_price.png'),
    );
  });
}
