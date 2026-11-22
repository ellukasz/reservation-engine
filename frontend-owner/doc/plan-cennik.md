# Cennik UI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Zbudować ekran cennika w `frontend-owner` zgodny z zaakceptowanym dokumentem UX: sześć pól, kafelki miesięcy, legenda, walidacja, zapis i status portali.

**Architecture:** Feature-first Flutter: modele i walidacja niezależne od UI, `PricingController` (`ChangeNotifier`) trzyma stan i zapis, ekran składa sekcje z małych widgetów. Repozytorium lokalne (`InMemoryPricingRepository`) symuluje backend i statusy Booking/Airbnb; interfejs `PricingRepository` zostawia miejsce na API.

**Tech Stack:** Flutter 3.50.1 / Dart 3.14, `material_ui: ^1.11.1`, `flutter_localizations`, `intl`, `flutter_test`. Material 3 jest domyślny.

**Spec:** `frontend-owner/doc/ux-cennik.md`

## Global Constraints

- Flutter 3.50.1, Dart 3.14; uruchamiaj narzędzia przez `mise exec -- flutter ...`.
- Importy Material wyłącznie z `package:material_ui/material_ui.dart`; nie używaj `package:flutter/material.dart`.
- Brak tekstów na sztywno w UI; wszystkie stringi przez `AppLocalizations` (`l10n.yaml`, ARB, `gen-l10n`).
- Material 3 domyślny; `ColorScheme.fromSeed`; `themeMode: ThemeMode.system`; osobny `darkTheme`.
- Dotyk: 48 × 48 dp Android, 44 × 44 pt iOS. Kontrast tekstu 4,5:1; elementów UI i fokusu 3:1.
- Tekst 16 sp (wartości) / 14 sp (etykiety); test 200% przez `TextScaler`, bez `textScaleFactor`.
- Ceny: pełne złote, > 0, maks. 99 999 zł. Narzuty 0–100%. Zaliczka 10–100%. Minimum 1–14 nocy.
- `depositPercent` domyślnie 30; `minNights` domyślnie 1.
- Brak `useMaterial3: false`; bez `FittedBox` do zmniejszania tekstu; bez `maxLines: 1` dla treści krytycznych.
- Nawigacja wstecz przez `PopScope` + `onPopInvokedWithResult`.
- Waluta/procenty/miesiące przez `intl`; liczby mnogie przez ARB plural.
- Każdy task kończy się `mise exec -- flutter test` i commitem.

## Review Focus

- **Długie tłumaczenia +40% i 200% tekstu:** kafelek nie może ucinać „Wochenende", „Mindestaufenthalt" ani kwoty „99 999 zł"; przy 130% lub < 340 dp siatka przechodzi na 1 kolumnę.
- **Liczby mnogie:** 1 noc / 2 noce / 5 nocy; niemieckie 1 Nacht / 2 Nächte / 5 Nächte; bez sklejania stringów.
- **Fokus i klawiatura:** aktywne pole nie może zniknąć pod sticky barem ani klawiaturą; fokus ma 3:1 i 3 dp ring.
- **Kontrast elementów UI:** obramowania pól, kafelków, checkboxa i fokusu min. 3:1 w light i dark mode.
- **Błędy i skrajne wartości:** 0 zł, 100 000 zł, 120%, 5% zaliczki, 0% narzutu, 100% zaliczki, 14 nocy, puste pole.
- **Zapis i portale:** brak potwierdzenia Airbnb daje komunikat i ponowienie tylko nieudanego portalu; błąd wczytania blokuje zapis.
- **Niezapisane zmiany:** gest wstecz i strzałka pokazują dialog; „Odrzuć" wraca do zapisanych wartości.

---

### Task 1: Bootstrap projektu, motyw i l10n

**Files:**
- Modify: `pubspec.yaml`
- Create: `l10n.yaml`
- Create: `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb`
- Create: `lib/theme/app_theme.dart`
- Create: `lib/app.dart`
- Modify: `lib/main.dart`
- Test: `test/app_test.dart`

**Interfaces:**
- Produces: `PricingApp({PricingRepository? repository})`, `buildLightTheme()`, `buildDarkTheme()`, `AppLocalizations` generated with `appTitle`, `pricingTitle`.

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('app renders localized pricing title', (tester) async {
  await tester.pumpWidget(const PricingApp());
  await tester.pumpAndSettle();
  expect(find.text('Cennik'), findsOneWidget);
});

testWidgets('app uses Material 3 light and dark schemes', (tester) async {
  await tester.pumpWidget(const PricingApp());
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  expect(app.theme!.useMaterial3, isTrue);
  expect(app.darkTheme!.colorScheme.brightness, Brightness.dark);
  expect(app.themeMode, ThemeMode.system);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `mise exec -- flutter test test/app_test.dart`
Expected: FAIL — `PricingApp` not defined.

- [ ] **Step 3: Add dependencies and l10n config**

`pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  material_ui: ^1.11.1
  cupertino_icons: ^1.0.8

flutter:
  generate: true
  uses-material-design: true
```

`l10n.yaml` (project root, next to `pubspec.yaml`):

```yaml
arb-dir: lib/l10n
template-arb-file: app_pl.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n
nullable-getter: false
```

Create `app_pl.arb` and `app_en.arb` with at least:

```json
{
  "@@locale": "pl",
  "appTitle": "Cennik",
  "pricingTitle": "Cennik"
}
```

Run: `mise exec -- flutter pub get` then `mise exec -- flutter gen-l10n`.

- [ ] **Step 4: Implement theme and app shell**

`lib/theme/app_theme.dart`:

```dart
ThemeData buildLightTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D5FD0)),
);

ThemeData buildDarkTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1D5FD0),
    brightness: Brightness.dark,
  ),
);
```

`lib/app.dart` — `MaterialApp` with `localizationsDelegates: AppLocalizations.localizationsDelegates`, `supportedLocales: AppLocalizations.supportedLocales`, `theme`, `darkTheme`, `themeMode: ThemeMode.system`, and `home: PricingPage(repository: repository ?? InMemoryPricingRepository())`.

`PricingPage` is a `StatefulWidget` that creates and disposes `PricingController`; for this task it can render a placeholder `Scaffold` with `AppLocalizations.of(context).pricingTitle` until Task 8.

`lib/main.dart` — `runApp(const PricingApp());`.

- [ ] **Step 5: Run tests and commit**

Run: `mise exec -- flutter test test/app_test.dart`
Expected: PASS.

```bash
git add pubspec.yaml pubspec.lock l10n.yaml lib test/app_test.dart
git commit -m "feat: bootstrap pricing app with Material 3 and l10n"
```

---

### Task 2: Modele i walidacja

**Files:**
- Create: `lib/pricing/model/pricing_field.dart`
- Create: `lib/pricing/model/pricing_error.dart`
- Create: `lib/pricing/model/pricing_draft.dart`
- Create: `lib/pricing/model/month_override.dart`
- Create: `lib/pricing/pricing_validator.dart`
- Test: `test/pricing/pricing_validator_test.dart`

**Interfaces:**
- Produces:
  - `enum PricingField { weekdayPrice, weekendPrice, bookingMarkup, airbnbMarkup, depositPercent, minNights }`
  - `enum PricingError { required, positive, wholeZloty, percentRange, depositRange, minNightsRange, maxPrice }`
  - `class PricingDraft` with `int` fields and `copyWith`.
  - `class MonthOverride` with `int month`, `int weekdayPrice`, `int weekendPrice`, `int? minimumNights`.
  - `PricingValidator.validateDraft(PricingDraft) -> Map<PricingField, PricingError>`
  - `PricingValidator.validateOverride(MonthOverride) -> Map<PricingField, PricingError>`

- [ ] **Step 1: Write failing tests**

```dart
test('rejects zero and too-large prices', () {
  expect(PricingValidator.validateDraft(PricingDraft.initial().copyWith(weekdayPrice: 0)),
      containsPair(PricingField.weekdayPrice, PricingError.positive));
  expect(PricingValidator.validateDraft(PricingDraft.initial().copyWith(weekendPrice: 100000)),
      containsPair(PricingField.weekendPrice, PricingError.maxPrice));
});

test('accepts boundary values', () {
  final draft = PricingDraft.initial().copyWith(
    bookingMarkup: 0, airbnbMarkup: 100, depositPercent: 10, minNights: 14,
  );
  expect(PricingValidator.validateDraft(draft), isEmpty);
});

test('rejects out-of-range deposit and minimum', () {
  expect(PricingValidator.validateDraft(PricingDraft.initial().copyWith(depositPercent: 5)),
      containsPair(PricingField.depositPercent, PricingError.depositRange));
  expect(PricingValidator.validateDraft(PricingDraft.initial().copyWith(minNights: 15)),
      containsPair(PricingField.minNights, PricingError.minNightsRange));
});

test('override inherits minimum when minimumNights is null', () {
  const override = MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550);
  expect(override.minimumNights, isNull);
  expect(PricingValidator.validateOverride(override), isEmpty);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/pricing_validator_test.dart`
Expected: FAIL — classes not defined.

- [ ] **Step 3: Implement models and validator**

`PricingDraft.initial()` = `weekdayPrice: 350, weekendPrice: 450, bookingMarkup: 0, airbnbMarkup: 0, depositPercent: 30, minNights: 1`.
`PricingDraft.empty()` = the same but prices `0`.

Validation rules: prices `> 0 && <= 99999`; markups `0..100`; deposit `10..100`; minNights `1..14`. `wholeZloty` is reserved for future decimal input; model ints cannot carry decimals.

Implement value equality (`==`, `hashCode`) for `PricingDraft` and `MonthOverride`; `copyWith` on both.

- [ ] **Step 4: Run tests and commit**

Run: `mise exec -- flutter test test/pricing/pricing_validator_test.dart`
Expected: PASS.

```bash
git add lib/pricing test/pricing/pricing_validator_test.dart
git commit -m "feat: add pricing models and validation"
```

---

### Task 3: Repozytorium i wynik zapisu

**Files:**
- Create: `lib/pricing/model/portal.dart`
- Create: `lib/pricing/model/save_result.dart`
- Create: `lib/pricing/model/pricing_repository.dart`
- Create: `lib/pricing/model/in_memory_pricing_repository.dart`
- Test: `test/pricing/in_memory_pricing_repository_test.dart`

**Interfaces:**
- Produces:
  - `enum Portal { booking, airbnb }`
  - `enum PortalSyncStatus { pending, confirmed, failed }`
  - `class SaveResult { DateTime savedAt; Map<Portal, PortalSyncStatus> statuses; }`
  - `class PricingSnapshot { PricingDraft draft; List<MonthOverride> overrides; }`
  - `abstract interface class PricingRepository { Future<PricingSnapshot> load(); Future<SaveResult> save(PricingDraft, List<MonthOverride>); Future<SaveResult> retryPortal(Portal); }`
  - `class InMemoryPricingRepository implements PricingRepository`

- [ ] **Step 1: Write failing tests**

```dart
test('loads seeded snapshot', () async {
  final repo = InMemoryPricingRepository();
  final snapshot = await repo.load();
  expect(snapshot.draft.depositPercent, 30);
  expect(snapshot.overrides, isEmpty);
});

test('save returns confirmed portals by default', () async {
  final repo = InMemoryPricingRepository();
  final result = await repo.save(PricingDraft.initial(), const []);
  expect(result.statuses[Portal.booking], PortalSyncStatus.confirmed);
  expect(result.statuses[Portal.airbnb], PortalSyncStatus.confirmed);
});

test('retryPortal updates only the requested portal', () async {
  final repo = InMemoryPricingRepository(failingPortals: {Portal.airbnb});
  final first = await repo.save(PricingDraft.initial(), const []);
  expect(first.statuses[Portal.airbnb], PortalSyncStatus.failed);
  final retry = await repo.retryPortal(Portal.airbnb);
  expect(retry.statuses[Portal.airbnb], PortalSyncStatus.confirmed);
  expect(retry.statuses[Portal.booking], PortalSyncStatus.confirmed);
});

test('load throws when loadError is configured', () async {
  final repo = InMemoryPricingRepository(loadError: StateError('offline'));
  expect(repo.load(), throwsStateError);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/in_memory_pricing_repository_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement repository**

`InMemoryPricingRepository` constructor:
```dart
InMemoryPricingRepository({
  PricingDraft? initialDraft,
  List<MonthOverride> initialOverrides = const [],
  Set<Portal> failingPortals = const {},
  Object? loadError,
});
```
Seed `initialDraft ?? PricingDraft.initial()` and `initialOverrides`.
`save` returns `SaveResult(savedAt: DateTime.now(), statuses: {for each portal: failing ? failed : confirmed})`.
`retryPortal` returns statuses with the requested portal confirmed and the other portal `confirmed`.

- [ ] **Step 4: Run tests and commit**

Run: `mise exec -- flutter test test/pricing/in_memory_pricing_repository_test.dart`
Expected: PASS.

```bash
git add lib/pricing/model test/pricing/in_memory_pricing_repository_test.dart
git commit -m "feat: add local pricing repository"
```

---

### Task 4: Kontroler cennika

**Files:**
- Create: `lib/pricing/pricing_controller.dart`
- Test: `test/pricing/pricing_controller_test.dart`

**Interfaces:**
- Produces: `PricingController extends ChangeNotifier` with:
  - `PricingLoadState loadState` (`loading`, `ready`, `error`)
  - `PricingDraft draft`, `List<MonthOverride> overrides`
  - `MonthOverride? editingOverride`
  - `bool isDirty`, `bool isSaving`, `SaveResult? lastSaveResult`, `Object? loadError`
  - `Map<PricingField, PricingError> errors`
  - `void updateWeekdayPrice(int)`, `updateWeekendPrice(int)`, `updateBookingMarkup(int)`, `updateAirbnbMarkup(int)`, `updateDepositPercent(int)`, `updateMinNights(int)`
  - `void openMonth(int)`, `void closeMonth()`, `void updateOverridePrice(...)`, `void setOverrideMinimumInherited(bool)`, `void updateOverrideMinimum(int)`
  - `bool get editingOverrideEqualsBase`
  - `Future<bool> save()`, `Future<void> load()`, `Future<void> retrySave()`, `void discardChanges()`
- Consumes: `PricingRepository`, `PricingValidator`, models from Tasks 2–3.

- [ ] **Step 1: Write failing tests**

```dart
test('load populates draft and clears dirty', () async {
  final controller = PricingController(InMemoryPricingRepository());
  await controller.load();
  expect(controller.loadState, PricingLoadState.ready);
  expect(controller.draft.depositPercent, 30);
  expect(controller.isDirty, isFalse);
});

test('editing marks dirty and discard restores saved values', () async {
  final controller = PricingController(InMemoryPricingRepository());
  await controller.load();
  controller.updateWeekdayPrice(400);
  expect(controller.isDirty, isTrue);
  controller.discardChanges();
  expect(controller.draft.weekdayPrice, 350);
  expect(controller.isDirty, isFalse);
});

test('save blocks invalid draft and exposes errors', () async {
  final controller = PricingController(InMemoryPricingRepository());
  await controller.load();
  controller.updateWeekdayPrice(0);
  expect(await controller.save(), isFalse);
  expect(controller.errors[PricingField.weekdayPrice], PricingError.positive);
});

test('saving an override with base values is a no-op', () async {
  final controller = PricingController(InMemoryPricingRepository());
  await controller.load();
  controller.openMonth(7);
  expect(controller.editingOverrideEqualsBase, isTrue);
  expect(await controller.save(), isTrue);
  expect(controller.overrides, isEmpty);
});

test('saving a real override adds it', () async {
  final controller = PricingController(InMemoryPricingRepository());
  await controller.load();
  controller.openMonth(7);
  controller.updateOverridePrice(weekday: 450, weekend: 550);
  expect(await controller.save(), isTrue);
  expect(controller.overrides.single.month, 7);
  expect(controller.editingOverride, isNull);
});

test('load failure sets error state and blocks save', () async {
  final controller = PricingController(
    InMemoryPricingRepository(loadError: StateError('offline')),
  );
  await controller.load();
  expect(controller.loadState, PricingLoadState.error);
  expect(await controller.save(), isFalse);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/pricing_controller_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement controller**

Keep `_savedDraft` / `_savedOverrides` for discard. `_dirty` is set by every update. `openMonth(month)` uses existing override or creates `MonthOverride(month: month, weekdayPrice: draft.weekdayPrice, weekendPrice: draft.weekendPrice, minimumNights: null)`.
`save()`:
1. If `loadState != ready || isSaving` return false.
2. Validate draft and `editingOverride`; set `errors`; notify; return false.
3. If `editingOverrideEqualsBase`, set `editingOverride = null` and continue (no override added).
4. Else replace/add override.
5. Call `repository.save`; on success update saved state, `lastSaveResult`, `isDirty = false`; on error set `saveError`; notify.
`retrySave()` calls `repository.retryPortal` for each failed portal and merges statuses.

- [ ] **Step 4: Run tests and commit**

Run: `mise exec -- flutter test test/pricing/pricing_controller_test.dart`
Expected: PASS.

```bash
git add lib/pricing/pricing_controller.dart test/pricing/pricing_controller_test.dart
git commit -m "feat: add pricing controller"
```

---

### Task 5: Formatter, pole ceny i stepper

**Files:**
- Create: `lib/pricing/pricing_formatter.dart`
- Create: `lib/pricing/widgets/pricing_field.dart`
- Create: `lib/pricing/widgets/night_stepper.dart`
- Test: `test/pricing/pricing_formatter_test.dart`
- Test: `test/pricing/widgets/pricing_field_test.dart`
- Test: `test/pricing/widgets/night_stepper_test.dart`

**Interfaces:**
- Produces:
  - `PricingFormatter(Locale locale)` with `String zloty(int)`, `String percent(int)`, `String monthLong(int)`.
  - `PricingField({required String label, required int value, required String suffix, String? errorText, required ValueChanged<int> onChanged, FocusNode? focusNode, Key? key})`.
  - `NightStepper({required int value, required ValueChanged<int> onChanged, int min = 1, int max = 14, String? errorText})`.

- [ ] **Step 1: Write failing tests**

```dart
test('formats PLN with locale grouping', () {
  final f = PricingFormatter(const Locale('pl'));
  expect(f.zloty(99999), contains('99'));
  expect(f.zloty(99999), contains('zł'));
});

testWidgets('pricing field shows suffix and error', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: PricingField(
    label: 'Noc w tygodniu', value: 350, suffix: 'zł',
    errorText: 'Cena musi być większa od zera', onChanged: (_) {},
  ))));
  expect(find.text('350'), findsOneWidget);
  expect(find.text('zł'), findsOneWidget);
  expect(find.text('Cena musi być większa od zera'), findsOneWidget);
});

testWidgets('night stepper clamps at 1 and 14 and has 48dp targets', (tester) async {
  var value = 1;
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: StatefulBuilder(
    builder: (context, setState) => NightStepper(value: value, onChanged: (v) => setState(() => value = v)),
  ))));
  await tester.tap(find.byTooltip('Zmniejsz minimalny pobyt o 1 noc'));
  expect(value, 1);
  for (var i = 0; i < 20; i++) {
    await tester.tap(find.byTooltip('Zwiększ minimalny pobyt o 1 noc'));
  }
  expect(value, 14);
  expect(tester.getSize(find.byType(IconButton).first).height, greaterThanOrEqualTo(48));
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/pricing_formatter_test.dart test/pricing/widgets/pricing_field_test.dart test/pricing/widgets/night_stepper_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

`PricingFormatter` uses `NumberFormat.currency(locale: locale.toLanguageTag(), symbol: 'zł', decimalDigits: 0)` and `NumberFormat.percentPattern`.
`PricingField` uses `TextField` with `keyboardType: TextInputType.number`, `inputFormatters: [FilteringTextInputFormatter.digitsOnly]`, `textInputAction: TextInputAction.next`, `onTapOutside: (_) => FocusScope.of(context).unfocus()`, `suffixText`, `errorText`, `helperText`. On focus, select all text.
`NightStepper` uses `IconButton` with `tooltip` and `constraints: BoxConstraints(minWidth: 48, minHeight: 48)`, value text, `Semantics` labels.

- [ ] **Step 4: Run tests and commit**

Run the three test files; expected PASS.

```bash
git add lib/pricing/pricing_formatter.dart lib/pricing/widgets test/pricing
git commit -m "feat: add pricing formatter and input widgets"
```

---

### Task 6: Legenda, kafelek i siatka miesięcy

**Files:**
- Create: `lib/pricing/widgets/legend_card.dart`
- Create: `lib/pricing/widgets/month_tile.dart`
- Create: `lib/pricing/widgets/month_grid.dart`
- Test: `test/pricing/widgets/legend_card_test.dart`
- Test: `test/pricing/widgets/month_tile_test.dart`
- Test: `test/pricing/widgets/month_grid_test.dart`

**Interfaces:**
- Produces:
  - `LegendCard({bool initiallyExpanded = false})`
  - `MonthTile({required MonthOverride? override, required int month, required int baseWeekdayPrice, required int baseWeekendPrice, required int baseMinNights, required VoidCallback onTap})`
  - `MonthGrid({required PricingDraft draft, required List<MonthOverride> overrides, required ValueChanged<int> onMonthTap})`

- [ ] **Step 1: Write failing tests**

```dart
testWidgets('legend is collapsed by default and expands on tap', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LegendCard())));
  expect(find.text('Rozwiń ▼'), findsOneWidget);
  expect(find.text('Noce od niedzieli do czwartku.'), findsNothing);
  await tester.tap(find.text('Rozwiń ▼'));
  await tester.pump();
  expect(find.text('Noce od niedzieli do czwartku.'), findsOneWidget);
  expect(find.text('Zwiń ▲'), findsOneWidget);
});

testWidgets('tile shows both prices and minimum in separate lines', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: MonthTile(
    month: 7, override: const MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550, minimumNights: 2),
    baseWeekdayPrice: 350, baseWeekendPrice: 450, baseMinNights: 1, onTap: () {},
  ))));
  expect(find.text('tydzień:'), findsOneWidget);
  expect(find.text('450 zł'), findsOneWidget);
  expect(find.text('weekend:'), findsOneWidget);
  expect(find.text('550 zł'), findsOneWidget);
  expect(find.text('2 noce'), findsOneWidget);
});

testWidgets('grid uses one column when text scale is large', (tester) async {
  await tester.pumpWidget(MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2.0)),
      child: child!,
    ),
    home: Scaffold(body: MonthGrid(draft: PricingDraft.initial(), overrides: const [], onMonthTap: (_) {})),
  ));
  final tiles = tester.widgetList(find.byType(MonthTile)).toList();
  final first = tester.getTopLeft(find.byWidget(tiles[0]));
  final second = tester.getTopLeft(find.byWidget(tiles[1]));
  expect(first.dx, second.dx);
  expect(second.dy, greaterThan(first.dy));
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/widgets/legend_card_test.dart test/pricing/widgets/month_tile_test.dart test/pricing/widgets/month_grid_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

`LegendCard` is stateful, `_expanded = initiallyExpanded` (default false). Header is an `InkWell`/`Semantics(button: true, expanded: _expanded, label: ...)`; collapsed shows hint; expanded shows definitions and swatches.
`MonthTile` is a `Card`/`InkWell` with one `Semantics(button: true, label: '...')`; content order: month name, badge, `tydzień:` + value, `weekend:` + value, minimum row, action. Border `colorScheme.outline` (3:1), marked `primary` 2 dp, focus ring 3 dp.
`MonthGrid` uses `LayoutBuilder`; 2 columns if `constraints.maxWidth >= 340` and `MediaQuery.textScalerOf(context).scale(14) <= 18`, otherwise 1. Build rows with `IntrinsicHeight` + `Row`/`Expanded` so tiles in a row share height and grow with content. No fixed tile height.

- [ ] **Step 4: Run tests and commit**

Run the three test files; expected PASS.

```bash
git add lib/pricing/widgets test/pricing/widgets
git commit -m "feat: add legend, month tile and responsive grid"
```

---

### Task 7: Edytor wpisu miesiąca

**Files:**
- Create: `lib/pricing/widgets/month_entry_editor.dart`
- Test: `test/pricing/widgets/month_entry_editor_test.dart`

**Interfaces:**
- Produces: `MonthEntryEditor({required MonthOverride override, required PricingDraft baseDraft, required ValueChanged<MonthOverride> onChanged, required VoidCallback onDelete, required bool isNew})`
- Consumes: `PricingField`, `NightStepper`.

- [ ] **Step 1: Write failing tests**

```dart
testWidgets('new entry inherits minimum by default', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: MonthEntryEditor(
    override: const MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550),
    baseDraft: PricingDraft.initial(), isNew: true, onChanged: (_) {}, onDelete: () {},
  ))));
  expect(find.text('Użyj minimum ośrodka (1 noc)'), findsOneWidget);
  expect(find.byType(NightStepper), findsNothing);
});

testWidgets('deleting asks for confirmation', (tester) async {
  var deleted = false;
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: MonthEntryEditor(
    override: const MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550, minimumNights: 2),
    baseDraft: PricingDraft.initial(), isNew: false, onChanged: (_) {}, onDelete: () => deleted = true,
  ))));
  await tester.tap(find.text('Usuń wpis'));
  expect(find.text('Usunąć wpis dla lipca?'), findsOneWidget);
  await tester.tap(find.text('Usuń'));
  expect(deleted, isTrue);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/widgets/month_entry_editor_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Checkbox/Switch „Użyj minimum ośrodka (1 noc)" checked when `override.minimumNights == null`. Unchecked reveals `NightStepper`.
Fields use `PricingField` for weekday/weekend prices.
„Usuń wpis" is a `TextButton`; on tap show `AlertDialog` with title/body/Anuluj/Usuń. On confirm call `onDelete`.
No own save button; the sticky `SaveBar` saves the whole form.

- [ ] **Step 4: Run tests and commit**

Run: `mise exec -- flutter test test/pricing/widgets/month_entry_editor_test.dart`
Expected: PASS.

```bash
git add lib/pricing/widgets/month_entry_editor.dart test/pricing/widgets/month_entry_editor_test.dart
git commit -m "feat: add month entry editor"
```

---

### Task 8: Ekran cennika, zapis i status portali

**Files:**
- Create: `lib/pricing/widgets/save_bar.dart`
- Create: `lib/pricing/widgets/sync_status_banner.dart`
- Create: `lib/pricing/pricing_screen.dart`
- Modify: `lib/app.dart` (replace placeholder with `PricingScreen`)
- Test: `test/pricing/pricing_screen_test.dart`

**Interfaces:**
- Produces: `SaveBar({required bool isDirty, required bool isSaving, required VoidCallback onSave})`, `SyncStatusBanner({required SaveResult? result, required VoidCallback onRetry})`, `PricingScreen({required PricingController controller})`.

- [ ] **Step 1: Write failing tests**

```dart
testWidgets('screen shows six fields and sticky save', (tester) async {
  final controller = PricingController(InMemoryPricingRepository());
  await tester.pumpWidget(PricingTestHarness(controller: controller));
  await tester.pumpAndSettle();
  expect(find.text('Noc w tygodniu (nd–czw)'), findsOneWidget);
  expect(find.text('Noc w weekend (pt–sob)'), findsOneWidget);
  expect(find.text('Booking — podwyższ cenę o'), findsOneWidget);
  expect(find.text('Airbnb — podwyższ cenę o'), findsOneWidget);
  expect(find.text('Zaliczka'), findsOneWidget);
  expect(find.text('Minimalny pobyt'), findsOneWidget);
  expect(find.text('Zapisz zmiany'), findsOneWidget);
});

testWidgets('invalid save focuses first error and shows message', (tester) async {
  final controller = PricingController(InMemoryPricingRepository());
  await tester.pumpWidget(PricingTestHarness(controller: controller));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('weekdayPrice')), '0');
  await tester.tap(find.text('Zapisz zmiany'));
  await tester.pumpAndSettle();
  expect(find.text('Cena musi być większa od zera.'), findsOneWidget);
  expect(FocusScope.of(tester.element(find.byKey(const Key('weekdayPrice')))).hasFocus, isTrue);
});

testWidgets('months expand and show tiles', (tester) async {
  final controller = PricingController(InMemoryPricingRepository());
  await tester.pumpWidget(PricingTestHarness(controller: controller));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Zmień ceny w miesiącach'));
  await tester.pumpAndSettle();
  expect(find.byType(MonthTile), findsNWidgets(12));
  expect(find.text('Legenda'), findsOneWidget);
  expect(find.text('Rozwiń ▼'), findsOneWidget);
});

testWidgets('back with unsaved changes asks before leaving', (tester) async {
  final controller = PricingController(InMemoryPricingRepository());
  await tester.pumpWidget(PricingTestHarness(controller: controller, withBackButton: true));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('weekdayPrice')), '400');
  await tester.pageBack();
  await tester.pumpAndSettle();
  expect(find.text('Masz niezapisane zmiany. Odrzucić?'), findsOneWidget);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `mise exec -- flutter test test/pricing/pricing_screen_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

`PricingScreen` is stateful; `initState` calls `controller.load()`, adds listener. Layout: `PopScope(canPop: !controller.isDirty, onPopInvokedWithResult: ...)`, `Scaffold` with `AppBar(title: pricingTitle)`, `ListView` of sections, `bottomNavigationBar: SafeArea(child: SaveBar(...))` with `MediaQuery.viewInsetsOf(context).bottom` padding.
Sections: `PricingField` × 4, `NightStepper`, `OutlinedButton` „Zmień ceny w miesiącach", `LegendCard`, `MonthGrid`, `MonthEntryEditor` when `editingOverride != null`.
Map `PricingError` to localized messages. On save errors, request focus on the first error's `FocusNode` and `Scrollable.ensureVisible`.
Loading: disable save and show progress. Load error: message + „Spróbuj ponownie". Save result: `SyncStatusBanner` with portal statuses and retry for failed portal. Empty state: message above grid.
Back: if dirty, show `AlertDialog` „Masz niezapisane zmiany. Odrzucić?" with „Zostań" / „Odrzuć"; on discard `controller.discardChanges()` and pop.

- [ ] **Step 4: Run tests and commit**

Run: `mise exec -- flutter test test/pricing/pricing_screen_test.dart`
Expected: PASS.

```bash
git add lib/pricing/widgets lib/pricing/pricing_screen.dart lib/app.dart test/pricing/pricing_screen_test.dart
git commit -m "feat: compose pricing screen with save and sync states"
```

---

### Task 9: Dostępność, responsywność i odbiór

**Files:**
- Create: `test/a11y_test.dart`
- Create: `test/pricing/pricing_golden_test.dart`
- Modify: `lib/pricing/widgets/*` for `Semantics`/`ExcludeSemantics`
- Modify: `lib/pricing/pricing_screen.dart` for `FocusTraversalGroup` and `Scrollable.ensureVisible`

**Interfaces:**
- Consumes all previous tasks.

- [ ] **Step 1: Write failing accessibility tests**

```dart
testWidgets('meets Android and iOS tap target guidelines', (tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(const PricingApp());
  await tester.pumpAndSettle();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `mise exec -- flutter test test/a11y_test.dart`
Expected: FAIL for unlabeled or undersized targets.

- [ ] **Step 3: Add semantics and responsive behavior**

- `MonthTile`: `Semantics(button: true, label: ..., child: ExcludeSemantics(child: ...))`; label includes month, own/shared, weekday/weekend prices, minimum, action.
- `NightStepper`: tooltips and `Semantics` labels on both buttons.
- `LegendCard`: header `Semantics(button: true, expanded: _expanded, label: ...)`.
- `PricingField`: `Semantics(textField: true, label: label, value: value)`.
- `PricingScreen`: `FocusTraversalGroup` with row-major order.
- Focus: `Scrollable.ensureVisible(focusNode.context!, alignment: 0.2)` after errors and on focus.
- Text scale: `MonthGrid` 1 column at > 130% or < 340 dp.
- Dark mode: verify `ThemeMode.system` and both schemes in a widget test.

- [ ] **Step 4: Add golden tests**

`test/pricing/pricing_golden_test.dart`: pump `MonthGrid` with 2 columns and with `TextScaler.linear(2.0)`; `expectLater(find.byType(MonthGrid), matchesGoldenFile('goldens/month_grid_2col.png'))` and `month_grid_1col_200.png`. Generate with `mise exec -- flutter test --update-goldens test/pricing/pricing_golden_test.dart`.

- [ ] **Step 5: Run full verification and commit**

Run:

```bash
mise exec -- dart format --output=none --set-exit-if-changed .
mise exec -- flutter analyze
mise exec -- flutter test
```

Expected: format clean, analyze no issues, all tests pass.

```bash
git add lib test
git commit -m "test: add accessibility, responsive and golden coverage"
```

---

## Self-Review

- **Spec coverage:** §4 flow → Task 8; §5 form → Tasks 5, 8; §6 validation → Tasks 2, 5, 8; §7 save/sync → Tasks 3, 4, 8; §8 months → Tasks 6, 7; §9 a11y/i18n → Tasks 1, 9; §10 components → file structure; §11–12 criteria/scenarios → tests across Tasks 4–9; §15 standards → Tasks 1, 5, 6, 8, 9.
- **Open decisions resolved:** offline copy from §7; section order prices → portals → reservation; „ostatnio zapisano" shown; backend = `InMemoryPricingRepository`; equal-to-base override is a no-op; retry only failed portal.
- **Type consistency:** `PricingDraft`, `MonthOverride`, `PricingField`, `PricingError`, `Portal`, `PortalSyncStatus`, `SaveResult`, `PricingRepository` names are used consistently across tasks.
- **Review Focus:** each line has a test in Task 6 (long strings/scale), Task 5 (tap targets/plurals), Task 8 (focus/keyboard/back), Task 9 (contrast/dark), Task 2 (bounds), Task 4 (errors/sync), Task 8 (dirty/back).
- **Proportion:** tasks carry interfaces and test assertions; widget bodies are left to the implementer.
