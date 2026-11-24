import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/app.dart';
import 'package:frontend_owner/l10n/app_localizations.dart';
import 'package:frontend_owner/pricing/model/in_memory_pricing_repository.dart';
import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/pricing_controller.dart';
import 'package:frontend_owner/pricing/pricing_screen.dart';
import 'package:frontend_owner/pricing/widgets/month_grid.dart';
import 'package:frontend_owner/pricing/widgets/month_tile.dart';
import 'package:frontend_owner/theme/app_theme.dart';

/// Nieliniowe skalowanie Androida 14: mały tekst rośnie szybciej niż duży.
class _Android14TextScaler extends TextScaler {
  const _Android14TextScaler();

  @override
  double scale(double fontSize) =>
      fontSize <= 14 ? fontSize * 2.0 : fontSize * 1.6;

  @override
  double get textScaleFactor => 2.0;

  @override
  String toString() => 'Android14TextScaler';
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Locale locale = const Locale('pl'),
  Brightness brightness = Brightness.light,
  Size size = const Size(360, 640),
}) async {
  tester.platformDispatcher.localesTestValue = <Locale>[locale];
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(() {
    tester.platformDispatcher.clearLocalesTestValue();
    tester.platformDispatcher.clearPlatformBrightnessTestValue();
  });
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    PricingApp(
      repository: InMemoryPricingRepository(
        initialOverrides: const <MonthOverride>[
          MonthOverride(
            month: 7,
            weekdayPrice: 450,
            weekendPrice: 550,
            minimumNights: 2,
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required PricingController controller,
  Locale locale = const Locale('pl'),
  Brightness brightness = Brightness.light,
  Size size = const Size(360, 640),
  TextScaler? textScaler,
}) async {
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(() {
    tester.platformDispatcher.clearPlatformBrightnessTestValue();
  });
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: PricingScreen(controller: controller),
    ),
  );
  await tester.pumpAndSettle();
}

PricingController _controller(WidgetTester tester) {
  final controller = PricingController(InMemoryPricingRepository());
  addTearDown(controller.dispose);
  return controller;
}

Future<void> _expandMonths(WidgetTester tester) async {
  final toggle = find.byType(OutlinedButton).first;
  await tester.ensureVisible(toggle);
  await tester.pumpAndSettle();
  await tester.tap(toggle);
  await tester.pumpAndSettle();
}

Future<void> _bringGridIntoView(WidgetTester tester) async {
  final grid = find.byType(MonthGrid);
  await tester.ensureVisible(grid);
  await tester.pumpAndSettle();
}

Future<void> _expectGuidelines(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

void main() {
  testWidgets('real screen passes all four accessibility guidelines', (
    tester,
  ) async {
    await _pumpApp(tester);
    final handle = tester.ensureSemantics();
    await _expectGuidelines(tester);
    handle.dispose();
  });

  testWidgets('expanded months and editor pass accessibility guidelines', (
    tester,
  ) async {
    await _pumpApp(tester, size: const Size(360, 720));
    await _expandMonths(tester);
    await _bringGridIntoView(tester);
    var handle = tester.ensureSemantics();
    await _expectGuidelines(tester);
    handle.dispose();

    final july = find.byType(MonthTile).at(6);
    await tester.ensureVisible(july);
    await tester.pumpAndSettle();
    await tester.tap(july);
    await tester.pumpAndSettle();
    await _bringGridIntoView(tester);
    handle = tester.ensureSemantics();
    await _expectGuidelines(tester);
    handle.dispose();
  });

  testWidgets('light and dark system themes keep text contrast', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      await _pumpApp(tester, brightness: brightness);
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.system,
      );
      final scheme = Theme.of(tester.element(find.byType(Scaffold)))
          .colorScheme;
      expect(scheme.brightness, brightness);

      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    }
  });

  testWidgets('month tile announces month, prices, minimum and action', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _expandMonths(tester);

    final handle = tester.ensureSemantics();
    final finder = find.bySemanticsLabel(
      'Lipiec, własna cena, tydzień 450 zł, weekend 550 zł, '
      'minimum 2 noce, zmień',
    );
    expect(finder, findsOneWidget);
    expect(tester.getSemantics(finder).flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('stepper and legend expose button semantics with labels', (
    tester,
  ) async {
    await _pumpApp(tester, size: const Size(360, 720));
    await _expandMonths(tester);
    await _bringGridIntoView(tester);

    final handle = tester.ensureSemantics();
    final decrease = find.bySemanticsLabel('Zmniejsz minimalny pobyt o 1 noc');
    final increase = find.bySemanticsLabel('Zwiększ minimalny pobyt o 1 noc');
    expect(decrease, findsOneWidget);
    expect(increase, findsOneWidget);
    expect(tester.getSemantics(decrease).flagsCollection.isButton, isTrue);
    expect(tester.getSemantics(increase).flagsCollection.isButton, isTrue);

    final legend = find.bySemanticsLabel('Legenda, zwinięta');
    expect(legend, findsOneWidget);
    expect(tester.getSemantics(legend).flagsCollection.isButton, isTrue);
    expect(
      tester.getSemantics(legend).flagsCollection.isExpanded,
      ui.Tristate.isFalse,
    );
    expect(tester.getRect(legend).height, greaterThanOrEqualTo(48));
    await tester.ensureVisible(legend);
    await tester.pumpAndSettle();
    await tester.tap(legend);
    await tester.pumpAndSettle();
    final expandedLegend = find.bySemanticsLabel('Legenda, rozwinięta');
    expect(expandedLegend, findsOneWidget);
    expect(
      tester.getSemantics(expandedLegend).flagsCollection.isExpanded,
      ui.Tristate.isTrue,
    );
    handle.dispose();
  });

  testWidgets('numeric fields expose unit labels as text fields', (
    tester,
  ) async {
    await _pumpApp(tester);
    final handle = tester.ensureSemantics();

    final weekday = find.bySemanticsLabel(
      RegExp('Cena za noc w tygodniu, w złotych'),
    );
    expect(weekday, findsOneWidget);
    expect(tester.getSemantics(weekday).flagsCollection.isTextField, isTrue);
    expect(tester.getSemantics(weekday).value, contains('350'));
    handle.dispose();
  });

  testWidgets('validation errors are announced through a live region', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.enterText(find.byKey(const Key('weekdayPrice')), '0');
    await tester.enterText(find.byKey(const Key('bookingMarkup')), '120');
    await tester.enterText(find.byKey(const Key('depositPercent')), '200');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle();

    final handle = tester.ensureSemantics();
    final summary = find.bySemanticsLabel(RegExp(r'Do poprawy: 3'));
    expect(summary, findsOneWidget);
    expect(tester.getSemantics(summary).flagsCollection.isLiveRegion, isTrue);
    final error = find.bySemanticsLabel(
      RegExp('Cena musi być większa od zera'),
    );
    expect(error, findsWidgets);
    handle.dispose();
  });

  testWidgets('focus follows the visual order of the form', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byKey(const Key('weekdayPrice')));
    await tester.pump();

    final scope = FocusScope.of(
      tester.element(find.byKey(const Key('weekdayPrice'))),
    );
    final labels = <Object?>[];
    for (var index = 0; index < 5; index++) {
      scope.nextFocus();
      await tester.pump();
      labels.add(FocusManager.instance.primaryFocus?.debugLabel);
    }
    expect(labels, <Object?>[
      'pricing-PricingField.weekendPrice',
      'pricing-PricingField.bookingMarkup',
      'pricing-PricingField.airbnbMarkup',
      'pricing-PricingField.depositPercent',
      isNull,
    ]);
  });

  testWidgets('form fields live in one ordered focus group', (tester) async {
    await _pumpApp(tester);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is FocusTraversalGroup &&
            widget.policy is OrderedTraversalPolicy,
      ),
      findsOneWidget,
    );
  });

  for (final width in <double>[320, 360, 412, 768]) {
    testWidgets('layout fits ${width}dp without clipping', (tester) async {
      await _pumpApp(tester, size: Size(width, width > 600 ? 1024 : 640));
      expect(tester.takeException(), isNull);

      final content = find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 480,
      );
      expect(content, findsOneWidget);
      final rect = tester.getRect(content);
      expect(rect.width, lessThanOrEqualTo(480));
      expect(rect.center.dx, closeTo(width / 2, 1));

      await _expandMonths(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(MonthTile), findsNWidgets(12));
    });
  }

  testWidgets('200% text scaler switches to one column without overflow', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      controller: _controller(tester),
      textScaler: const TextScaler.linear(2.0),
    );
    await _expandMonths(tester);
    expect(tester.takeException(), isNull);

    final first = tester.getTopLeft(find.byType(MonthTile).at(0));
    final second = tester.getTopLeft(find.byType(MonthTile).at(1));
    expect(first.dx, second.dx);
    expect(second.dy, greaterThan(first.dy));
  });

  testWidgets('nonlinear Android 14 text scaling wraps without overflow', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      controller: _controller(tester),
      textScaler: const _Android14TextScaler(),
      size: const Size(320, 720),
    );
    await _expandMonths(tester);
    expect(tester.takeException(), isNull);

    final first = tester.getTopLeft(find.byType(MonthTile).at(0));
    final second = tester.getTopLeft(find.byType(MonthTile).at(1));
    expect(first.dx, second.dx);
    expect(second.dy, greaterThan(first.dy));
  });

  for (final locale in <Locale>[
    const Locale('en', 'XA'),
    const Locale('ar', 'XB'),
  ]) {
    testWidgets('pseudo-locale $locale wraps long text without overflow', (
      tester,
    ) async {
      await _pumpScreen(
        tester,
        controller: _controller(tester),
        locale: locale,
        size: const Size(360, 720),
      );
      final direction = Directionality.of(
        tester.element(find.byType(PricingScreen)),
      );
      expect(
        direction,
        locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(find.textContaining('extended'), findsWidgets);

      await _expandMonths(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(MonthTile), findsNWidgets(12));
    });
  }
}
