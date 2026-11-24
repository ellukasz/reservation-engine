import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/widgets/month_entry_editor.dart';
import 'package:frontend_owner/pricing/widgets/night_stepper.dart';
import 'package:frontend_owner/pricing/widgets/pricing_field.dart';

void _usePolishLocale(WidgetTester tester) {
  tester.platformDispatcher.localeTestValue = const Locale('pl');
  addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
}

Widget _harness({
  required MonthOverride override,
  ValueChanged<MonthOverride>? onChanged,
  VoidCallback? onDelete,
  PricingDraft? baseDraft,
  bool isNew = true,
  TextScaler? textScaler,
}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: MonthEntryEditor(
          override: override,
          baseDraft: baseDraft ?? PricingDraft.initial(),
          isNew: isNew,
          onChanged: onChanged ?? (_) {},
          onDelete: onDelete ?? () {},
        ),
      ),
    ),
  );
}

Widget _statefulHarness({
  required MonthOverride initial,
  required List<MonthOverride> changes,
  PricingDraft? baseDraft,
}) {
  var current = initial;
  return MaterialApp(
    home: Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => MonthEntryEditor(
          override: current,
          baseDraft: baseDraft ?? PricingDraft.initial(),
          isNew: false,
          onChanged: (next) {
            changes.add(next);
            setState(() => current = next);
          },
          onDelete: () {},
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('new entry inherits minimum by default', (tester) async {
    _usePolishLocale(tester);
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
        ),
        isNew: true,
      ),
    );

    expect(find.text('Użyj minimum ośrodka (1 noc)'), findsOneWidget);
    expect(find.byType(NightStepper), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('disabling inheritance reveals stepper with resort minimum', (
    tester,
  ) async {
    _usePolishLocale(tester);
    final changes = <MonthOverride>[];
    await tester.pumpWidget(
      _statefulHarness(
        initial: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
        ),
        changes: changes,
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.byType(NightStepper), findsOneWidget);
    expect(changes.last.minimumNights, 1);
  });

  testWidgets('enabling inheritance clears month minimum', (tester) async {
    _usePolishLocale(tester);
    final changes = <MonthOverride>[];
    await tester.pumpWidget(
      _statefulHarness(
        initial: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
          minimumNights: 2,
        ),
        changes: changes,
      ),
    );

    expect(find.byType(NightStepper), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.byType(NightStepper), findsNothing);
    expect(changes.last.minimumNights, isNull);
  });

  testWidgets('price fields report weekday and weekend changes', (
    tester,
  ) async {
    _usePolishLocale(tester);
    final changes = <MonthOverride>[];
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
        ),
        onChanged: changes.add,
      ),
    );

    expect(find.byType(PricingField), findsNWidgets(2));
    expect(find.text('Cena nd–czw'), findsOneWidget);
    expect(find.text('Cena pt–sob'), findsOneWidget);
    expect(find.text('zł'), findsNWidgets(2));

    await tester.enterText(find.byType(TextField).at(0), '480');
    expect(changes.last.weekdayPrice, 480);

    await tester.enterText(find.byType(TextField).at(1), '600');
    expect(changes.last.weekendPrice, 600);
  });

  testWidgets('invalid price shows error below field', (tester) async {
    _usePolishLocale(tester);
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 0,
          weekendPrice: 550,
        ),
      ),
    );

    expect(find.text('Cena musi być większa od zera.'), findsOneWidget);
  });

  testWidgets('editor has no own save button', (tester) async {
    _usePolishLocale(tester);
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
        ),
      ),
    );

    expect(find.text('Zapisz zmiany'), findsNothing);
  });

  testWidgets('deleting asks for confirmation', (tester) async {
    _usePolishLocale(tester);
    var deleted = false;
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
          minimumNights: 2,
        ),
        isNew: false,
        onDelete: () => deleted = true,
      ),
    );

    final deleteButton = find.ancestor(
      of: find.text('Usuń wpis'),
      matching: find.byType(TextButton),
    );
    expect(tester.getSize(deleteButton).height, greaterThanOrEqualTo(48));

    await tester.tap(find.text('Usuń wpis'));
    await tester.pumpAndSettle();
    expect(find.text('Usunąć wpis dla lipca?'), findsOneWidget);
    expect(
      find.text('Ceny wrócą do bazowe. Tej czynności nie da się cofnąć.'),
      findsOneWidget,
    );
    expect(find.text('Anuluj'), findsOneWidget);
    expect(find.text('Usuń'), findsOneWidget);

    await tester.tap(find.text('Usuń'));
    await tester.pumpAndSettle();
    expect(deleted, isTrue);
  });

  testWidgets('delete confirmation names the selected month', (tester) async {
    _usePolishLocale(tester);
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 12,
          weekdayPrice: 450,
          weekendPrice: 550,
          minimumNights: 2,
        ),
        isNew: false,
      ),
    );

    await tester.tap(find.text('Usuń wpis'));
    await tester.pumpAndSettle();

    expect(find.text('Usunąć wpis dla grudnia?'), findsOneWidget);
  });

  testWidgets('cancel keeps the entry', (tester) async {
    _usePolishLocale(tester);
    var deleted = false;
    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 7,
          weekdayPrice: 450,
          weekendPrice: 550,
          minimumNights: 2,
        ),
        isNew: false,
        onDelete: () => deleted = true,
      ),
    );

    await tester.tap(find.text('Usuń wpis'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();

    expect(deleted, isFalse);
    expect(find.text('Usunąć wpis dla lipca?'), findsNothing);
  });

  testWidgets('editor keeps text visible at 200% text scale', (tester) async {
    _usePolishLocale(tester);
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        override: const MonthOverride(
          month: 10,
          weekdayPrice: 99999,
          weekendPrice: 99999,
          minimumNights: 2,
        ),
        isNew: false,
        textScaler: const TextScaler.linear(2.0),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Październik — wpis'), findsOneWidget);
    expect(find.byType(FittedBox), findsNothing);
  });
}
