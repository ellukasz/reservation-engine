import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:frontend_owner/l10n/app_localizations.dart';
import 'package:frontend_owner/pricing/model/in_memory_pricing_repository.dart';
import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/model/save_result.dart';
import 'package:frontend_owner/pricing/pricing_controller.dart';
import 'package:frontend_owner/pricing/pricing_screen.dart';
import 'package:frontend_owner/pricing/widgets/month_entry_editor.dart';
import 'package:frontend_owner/pricing/widgets/month_tile.dart';
import 'package:frontend_owner/pricing/widgets/save_bar.dart';
import 'package:frontend_owner/pricing/widgets/sync_status_banner.dart';

void _usePolishLocale(WidgetTester tester) {
  tester.platformDispatcher.localeTestValue = const Locale('pl');
  addTearDown(() => tester.platformDispatcher.clearLocaleTestValue());
}

/// Harness z prawdziwym ekranem, lokalizacją i (opcjonalnie) trasą wsteczną.
class PricingTestHarness extends StatefulWidget {
  const PricingTestHarness({
    required this.controller,
    this.withBackButton = false,
    this.viewInsetsBottom = 0,
    super.key,
  });

  final PricingController controller;
  final bool withBackButton;
  final double viewInsetsBottom;

  @override
  State<PricingTestHarness> createState() => _PricingTestHarnessState();
}

class _PricingTestHarnessState extends State<PricingTestHarness> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    if (widget.withBackButton) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState?.push(
          MaterialPageRoute<void>(
            builder: (_) => PricingScreen(controller: widget.controller),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      locale: const Locale('pl'),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          viewInsets: EdgeInsets.only(bottom: widget.viewInsetsBottom),
        ),
        child: child!,
      ),
      home: widget.withBackButton
          ? const Scaffold(body: Center(child: Text('Poprzedni ekran')))
          : Scaffold(body: PricingScreen(controller: widget.controller)),
    );
  }
}

PricingController _controller({
  InMemoryPricingRepository? repository,
  WidgetTester? tester,
}) {
  final controller = PricingController(
    repository ?? InMemoryPricingRepository(),
  );
  if (tester != null) {
    addTearDown(controller.dispose);
  }
  return controller;
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  PricingController? controller,
  bool withBackButton = false,
  double viewInsetsBottom = 0,
}) async {
  _usePolishLocale(tester);
  await tester.pumpWidget(
    PricingTestHarness(
      controller: controller ?? _controller(tester: tester),
      withBackButton: withBackButton,
      viewInsetsBottom: viewInsetsBottom,
    ),
  );
  await tester.pumpAndSettle();
}

/// Dotyka elementu po uprzednim przewinięciu go do widoku.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class _RecordingRepository extends InMemoryPricingRepository {
  _RecordingRepository({super.failingPortals});

  final List<Portal> retriedPortals = <Portal>[];

  @override
  Future<SaveResult> retryPortal(Portal portal) async {
    retriedPortals.add(portal);
    return super.retryPortal(portal);
  }
}

class _FlakyLoadRepository extends InMemoryPricingRepository {
  int loadCalls = 0;

  @override
  Future<PricingSnapshot> load() async {
    loadCalls++;
    if (loadCalls == 1) {
      throw StateError('offline');
    }
    return super.load();
  }
}

class _FlakySaveRepository extends InMemoryPricingRepository {
  int saveCalls = 0;

  @override
  Future<SaveResult> save(
    PricingDraft draft,
    List<MonthOverride> overrides,
  ) async {
    saveCalls++;
    if (saveCalls == 1) {
      throw StateError('disk full');
    }
    return super.save(draft, overrides);
  }
}

class _RetryFailsRepository extends InMemoryPricingRepository {
  _RetryFailsRepository() : super(failingPortals: const {Portal.airbnb});

  @override
  Future<SaveResult> retryPortal(Portal portal) async {
    throw StateError('still offline');
  }
}

void main() {
  testWidgets('screen shows six fields and sticky save', (tester) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    expect(find.text('Noc w tygodniu (nd–czw)'), findsOneWidget);
    expect(find.text('Noc w weekend (pt–sob)'), findsOneWidget);
    expect(find.text('Booking — podwyższ cenę o'), findsOneWidget);
    expect(find.text('Airbnb — podwyższ cenę o'), findsOneWidget);
    expect(find.text('Zaliczka'), findsOneWidget);
    expect(find.text('Minimalny pobyt'), findsOneWidget);
    expect(find.text('Zapisz zmiany'), findsOneWidget);
  });

  testWidgets('invalid save focuses first error and shows message', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '0');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();

    expect(find.text('Cena musi być większa od zera.'), findsOneWidget);
    final field = tester.element(find.byKey(const Key('weekdayPrice')));
    expect(FocusScope.of(field).hasFocus, isTrue);
  });

  testWidgets('months expand and show tiles', (tester) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));

    expect(find.byType(MonthTile), findsNWidgets(12));
    expect(find.text('Legenda'), findsOneWidget);
    expect(find.text('Rozwiń ▼'), findsOneWidget);
    expect(find.text('dotyczy każdego roku'), findsWidgets);
    expect(
      find.text(
        'Nie masz jeszcze własnych cen na miesiące. Wszędzie obowiązuje cena wspólna.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('months collapse on second tap and keep legend collapsed', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));
    await _tap(tester, find.text('Zmień ceny w miesiącach'));

    expect(find.byType(MonthTile), findsNothing);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));
    expect(find.text('Rozwiń ▼'), findsOneWidget);
    expect(find.text('Zwiń ▲'), findsNothing);
  });

  testWidgets('back with unsaved changes asks before leaving', (tester) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller, withBackButton: true);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await _tap(tester, find.byType(BackButton));

    expect(find.text('Masz niezapisane zmiany. Odrzucić?'), findsOneWidget);
    expect(find.text('Zostań'), findsOneWidget);
    expect(find.text('Odrzuć'), findsOneWidget);
  });

  testWidgets('discarding unsaved changes leaves the screen', (tester) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller, withBackButton: true);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await _tap(tester, find.byType(BackButton));
    await tester.tap(find.text('Odrzuć'));
    await tester.pumpAndSettle();

    expect(find.text('Poprzedni ekran'), findsOneWidget);
    expect(controller.isDirty, isFalse);
    expect(controller.draft.weekdayPrice, 350);
  });

  testWidgets('portal prices are calculated from the weekend price', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('bookingMarkup')), '16');
    await tester.enterText(find.byKey(const Key('airbnbMarkup')), '10');
    await tester.pumpAndSettle();

    expect(find.text('522 zł'), findsOneWidget);
    expect(find.text('495 zł'), findsOneWidget);
  });

  testWidgets('zero markup and full deposit have their own captions', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('bookingMarkup')), '0');
    await tester.enterText(find.byKey(const Key('airbnbMarkup')), '10');
    await tester.enterText(find.byKey(const Key('depositPercent')), '100');
    await tester.pumpAndSettle();

    expect(find.text('Cena w portalu bez zmian'), findsOneWidget);
    expect(find.text('Gość płaci całość online'), findsOneWidget);
  });

  testWidgets('deposit shows online and on-site amounts', (tester) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    expect(
      find.text('Przy 1 000 zł: 300 zł online, 700 zł na miejscu.'),
      findsOneWidget,
    );
  });

  testWidgets('save shows confirmation, last-saved time and portal statuses', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();

    expect(find.text('Zapisano ✓'), findsOneWidget);
    expect(find.textContaining('Ostatnio zapisano dziś o'), findsOneWidget);
    expect(find.text('Zapisano. Wysyłamy ceny do portali.'), findsOneWidget);
    expect(find.text('Booking — potwierdzone ✓'), findsOneWidget);
    expect(find.text('Airbnb — potwierdzone ✓'), findsOneWidget);
  });

  testWidgets('failed Airbnb shows warning and retries only Airbnb', (
    tester,
  ) async {
    final repository = _RecordingRepository(
      failingPortals: const {Portal.airbnb},
    );
    final controller = _controller(tester: tester, repository: repository);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Airbnb nie potwierdził cen. Spróbujemy ponownie automatycznie.',
      ),
      findsOneWidget,
    );
    expect(find.text('Spróbuj teraz'), findsOneWidget);
    expect(find.text('Booking — potwierdzone ✓'), findsOneWidget);

    await tester.tap(find.text('Spróbuj teraz'));
    await tester.pumpAndSettle();

    expect(repository.retriedPortals, <Portal>[Portal.airbnb]);
    expect(
      find.text(
        'Airbnb nie potwierdził cen. Spróbujemy ponownie automatycznie.',
      ),
      findsNothing,
    );
    expect(find.text('Airbnb — potwierdzone ✓'), findsOneWidget);
  });

  testWidgets('pending portal is visible in the green banner', (tester) async {
    _usePolishLocale(tester);
    final result = SaveResult(
      savedAt: DateTime.now(),
      statuses: const <Portal, PortalSyncStatus>{
        Portal.booking: PortalSyncStatus.confirmed,
        Portal.airbnb: PortalSyncStatus.pending,
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SyncStatusBanner(result: result, onRetry: () {}),
        ),
      ),
    );

    expect(find.text('Zapisano. Wysyłamy ceny do portali.'), findsOneWidget);
    expect(find.text('Booking — potwierdzone ✓'), findsOneWidget);
    expect(find.text('Airbnb — czeka na potwierdzenie…'), findsOneWidget);
  });

  testWidgets('offline sync shows the internet message', (tester) async {
    _usePolishLocale(tester);
    final result = SaveResult(
      savedAt: DateTime.now(),
      statuses: const <Portal, PortalSyncStatus>{
        Portal.booking: PortalSyncStatus.failed,
        Portal.airbnb: PortalSyncStatus.failed,
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SyncStatusBanner(result: result, onRetry: () {}),
        ),
      ),
    );

    expect(
      find.text('Brak internetu. Nie możemy teraz wysłać cen do portali.'),
      findsOneWidget,
    );
    expect(find.text('Spróbuj teraz'), findsOneWidget);
  });

  testWidgets('save error shows retry and retry succeeds', (tester) async {
    final repository = _FlakySaveRepository();
    final controller = _controller(tester: tester, repository: repository);
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();

    expect(
      find.text('Nie udało się zapisać. Spróbuj ponownie.'),
      findsOneWidget,
    );
    expect(find.text('Spróbuj ponownie'), findsOneWidget);

    await tester.tap(find.text('Spróbuj ponownie'));
    await tester.pumpAndSettle();

    expect(repository.saveCalls, 2);
    expect(find.text('Nie udało się zapisać. Spróbuj ponownie.'), findsNothing);
    expect(find.text('Zapisano ✓'), findsOneWidget);
  });

  testWidgets('portal retry exception does not crash the screen', (
    tester,
  ) async {
    final controller = _controller(
      tester: tester,
      repository: _RetryFailsRepository(),
    );
    await _pumpScreen(tester, controller: controller);

    await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spróbuj teraz'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.text('Nie udało się zapisać. Spróbuj ponownie.'),
      findsOneWidget,
    );
  });

  testWidgets('load error blocks save and retry loads the pricing', (
    tester,
  ) async {
    final repository = _FlakyLoadRepository();
    final controller = _controller(tester: tester, repository: repository);
    await _pumpScreen(tester, controller: controller);

    expect(find.text('Nie udało się wczytać cennika.'), findsOneWidget);
    final saveButton = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.text('Zapisz zmiany'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(saveButton.onPressed, isNull);
    expect(find.text('Spróbuj ponownie'), findsOneWidget);

    await tester.tap(find.text('Spróbuj ponownie'));
    await tester.pumpAndSettle();

    expect(repository.loadCalls, 2);
    expect(find.text('Nie udało się wczytać cennika.'), findsNothing);
    // Po udanym wczytaniu pola są znów edytowalne; zapis pozostaje
    // nieaktywny, bo nie ma jeszcze żadnych zmian.
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isTrue,
    );
    expect(
      tester
          .widget<ElevatedButton>(
            find.ancestor(
              of: find.text('Zapisz zmiany'),
              matching: find.byType(ElevatedButton),
            ),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('saving while loading is blocked and shows a spinner', (
    tester,
  ) async {
    _usePolishLocale(tester);
    final controller = _controller(tester: tester);
    await tester.pumpWidget(PricingTestHarness(controller: controller));
    // load() jest async — pierwsza klatka wciąż pokazuje stan wczytywania.
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(
      tester
          .widget<ElevatedButton>(
            find.ancestor(
              of: find.text('Zapisz zmiany'),
              matching: find.byType(ElevatedButton),
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.pumpAndSettle();
  });

  testWidgets('save bar exposes disabled, active and saving states', (
    tester,
  ) async {
    _usePolishLocale(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SaveBar(isDirty: false, isSaving: false, onSave: () {}),
        ),
      ),
    );
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SaveBar(isDirty: true, isSaving: false, onSave: () {}),
        ),
      ),
    );
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNotNull,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SaveBar(isDirty: true, isSaving: true, onSave: () {}),
        ),
      ),
    );
    expect(find.text('Zapisuję…'), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
  });

  testWidgets('base-priced entry is not created and explains why', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));
    await _tap(tester, find.text('Lipiec'));
    expect(find.byType(MonthEntryEditor), findsOneWidget);

    await tester.tap(find.text('Zapisz zmiany'));
    await tester.pumpAndSettle();

    expect(controller.overrides, isEmpty);
    expect(controller.editingOverride, isNull);
    expect(
      find.text('To są ceny bazowe — wpis nie został utworzony'),
      findsOneWidget,
    );
  });

  testWidgets('deleting an entry closes the editor and restores shared price', (
    tester,
  ) async {
    final repository = InMemoryPricingRepository(
      initialOverrides: const <MonthOverride>[
        MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550),
      ],
    );
    final controller = _controller(tester: tester, repository: repository);
    await _pumpScreen(tester, controller: controller);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));
    await _tap(tester, find.text('Lipiec'));
    expect(find.byType(MonthEntryEditor), findsOneWidget);

    await _tap(tester, find.text('Usuń wpis'));
    await _tap(tester, find.text('Usuń'));

    expect(controller.overrides, isEmpty);
    expect(controller.editingOverride, isNull);
    expect(find.byType(MonthEntryEditor), findsNothing);
    expect(find.text('Wspólna'), findsWidgets);
  });

  testWidgets('switching month with unsaved changes asks first', (
    tester,
  ) async {
    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    await _tap(tester, find.text('Zmień ceny w miesiącach'));
    await _tap(tester, find.text('Lipiec'));
    await tester.enterText(
      find
          .descendant(
            of: find.byType(MonthEntryEditor),
            matching: find.byType(TextField),
          )
          .first,
      '480',
    );
    await tester.pumpAndSettle();
    expect(controller.isDirty, isTrue);

    await tester.ensureVisible(find.text('Sierpień'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sierpień'));
    await tester.pumpAndSettle();

    expect(find.text('Masz niezapisane zmiany. Odrzucić?'), findsOneWidget);

    await tester.tap(find.text('Odrzuć'));
    await tester.pumpAndSettle();

    expect(controller.isDirty, isFalse);
    expect(controller.editingOverride?.month, 8);
    expect(find.text('Sierpień — wpis'), findsOneWidget);
  });

  testWidgets('focused field stays above the sticky bar with keyboard open', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller, viewInsetsBottom: 300);

    await tester.tap(find.byKey(const Key('weekdayPrice')));
    await tester.pumpAndSettle();

    final fieldBottom = tester.getBottomLeft(
      find.byKey(const Key('weekdayPrice')),
    );
    final barTop = tester.getTopLeft(find.byType(SaveBar));
    expect(fieldBottom.dy, lessThan(barTop.dy));
  });

  testWidgets('content is capped at 480 dp on tablets', (tester) async {
    await tester.binding.setSurfaceSize(const Size(768, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = _controller(tester: tester);
    await _pumpScreen(tester, controller: controller);

    final constrained = find.ancestor(
      of: find.text('Noc w tygodniu (nd–czw)'),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 480,
      ),
    );
    expect(constrained, findsWidgets);
    expect(tester.getSize(constrained.first).width, lessThanOrEqualTo(480));
  });
}
