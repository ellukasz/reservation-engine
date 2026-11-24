import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_owner/pricing/model/in_memory_pricing_repository.dart';
import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/model/pricing_error.dart';
import 'package:frontend_owner/pricing/model/pricing_field.dart';
import 'package:frontend_owner/pricing/model/pricing_repository.dart';
import 'package:frontend_owner/pricing/model/save_result.dart';
import 'package:frontend_owner/pricing/pricing_controller.dart';

/// Repozytorium, które zawodzi określoną liczbę pierwszych zapisów.
class FlakySaveRepository implements PricingRepository {
  FlakySaveRepository({this.failuresRemaining = 0});

  final InMemoryPricingRepository _inner = InMemoryPricingRepository();
  int failuresRemaining;

  @override
  Future<PricingSnapshot> load() => _inner.load();

  @override
  Future<SaveResult> save(PricingDraft draft, List<MonthOverride> overrides) {
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw StateError('zapis niedostępny');
    }
    return _inner.save(draft, overrides);
  }

  @override
  Future<SaveResult> retryPortal(Portal portal) => _inner.retryPortal(portal);
}

/// Repozytorium pozwalające zatrzymać zapis w trakcie, by sprawdzić blokadę.
class GatedSaveRepository implements PricingRepository {
  final InMemoryPricingRepository _inner = InMemoryPricingRepository();
  final Completer<void> gate = Completer<void>();

  @override
  Future<PricingSnapshot> load() => _inner.load();

  @override
  Future<SaveResult> save(
    PricingDraft draft,
    List<MonthOverride> overrides,
  ) async {
    await gate.future;
    return _inner.save(draft, overrides);
  }

  @override
  Future<SaveResult> retryPortal(Portal portal) => _inner.retryPortal(portal);
}

void main() {
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

    controller.openMonth(7);
    controller.updateOverridePrice(weekday: 450, weekend: 550);

    controller.discardChanges();

    expect(controller.draft.weekdayPrice, 350);
    expect(controller.overrides, isEmpty);
    expect(controller.editingOverride, isNull);
    expect(controller.isDirty, isFalse);
  });

  test('all draft fields can be updated before saving', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller
      ..updateWeekdayPrice(400)
      ..updateWeekendPrice(500)
      ..updateBookingMarkup(16)
      ..updateAirbnbMarkup(10)
      ..updateDepositPercent(40)
      ..updateMinNights(2);

    expect(
      controller.draft,
      const PricingDraft(
        weekdayPrice: 400,
        weekendPrice: 500,
        bookingMarkup: 16,
        airbnbMarkup: 10,
        depositPercent: 40,
        minNights: 2,
      ),
    );
    expect(controller.isDirty, isTrue);
  });

  test('save blocks invalid draft and exposes errors', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller.updateWeekdayPrice(0);

    expect(await controller.save(), isFalse);
    expect(controller.errors[PricingField.weekdayPrice], PricingError.positive);
  });

  test('successful save clears validation errors', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller.updateWeekdayPrice(0);
    expect(await controller.save(), isFalse);

    controller.updateWeekdayPrice(400);
    expect(await controller.save(), isTrue);
    expect(controller.errors, isEmpty);
  });

  test(
    'saveError is exposed on failure and cleared after a successful save',
    () async {
      final repo = FlakySaveRepository(failuresRemaining: 1);
      final controller = PricingController(repo);
      await controller.load();
      controller.updateWeekdayPrice(400);

      expect(await controller.save(), isFalse);
      expect(controller.saveError, isA<StateError>());
      expect(controller.isDirty, isTrue);
      expect(controller.lastSaveResult, isNull);

      expect(await controller.save(), isTrue);
      expect(controller.saveError, isNull);
      expect(controller.isDirty, isFalse);
      expect(controller.lastSaveResult, isNotNull);
    },
  );

  test('saving an override with base values is a no-op', () async {
    final repo = InMemoryPricingRepository();
    final controller = PricingController(repo);
    await controller.load();

    controller.openMonth(7);
    expect(controller.editingOverrideEqualsBase, isTrue);

    expect(await controller.save(), isTrue);
    expect(controller.overrides, isEmpty);
    expect(controller.editingOverride, isNull);
    expect((await repo.load()).overrides, isEmpty);
  });

  test('saving a real override adds it and keeps the editor open', () async {
    final repo = InMemoryPricingRepository();
    final controller = PricingController(repo);
    await controller.load();

    controller.openMonth(7);
    controller.updateOverridePrice(weekday: 450, weekend: 550);
    expect(controller.editingOverrideEqualsBase, isFalse);

    expect(await controller.save(), isTrue);
    expect(controller.overrides.single.month, 7);
    expect(controller.overrides.single.weekdayPrice, 450);
    expect(controller.overrides.single.weekendPrice, 550);
    expect(controller.editingOverride, isNotNull);
    expect(controller.editingOverride!.month, 7);
    expect(controller.isDirty, isFalse);
    expect((await repo.load()).overrides.single.weekdayPrice, 450);
  });

  test('saving an edited month replaces the existing entry', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller.openMonth(7);
    controller.updateOverridePrice(weekday: 450, weekend: 550);
    expect(await controller.save(), isTrue);

    controller.updateOverridePrice(weekday: 480, weekend: 600);
    expect(await controller.save(), isTrue);

    expect(controller.overrides, hasLength(1));
    expect(controller.overrides.single.weekdayPrice, 480);
    expect(controller.overrides.single.weekendPrice, 600);
  });

  test('override minimum outside 1-14 blocks save', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller.openMonth(7);
    controller
      ..updateOverridePrice(weekday: 450, weekend: 550)
      ..updateOverrideMinimum(15);

    expect(await controller.save(), isFalse);
    expect(
      controller.errors[PricingField.minNights],
      PricingError.minNightsRange,
    );
    expect(controller.overrides, isEmpty);

    controller.updateOverrideMinimum(0);
    expect(await controller.save(), isFalse);
    expect(
      controller.errors[PricingField.minNights],
      PricingError.minNightsRange,
    );

    controller.updateOverrideMinimum(2);
    expect(await controller.save(), isTrue);
    expect(controller.overrides.single.minimumNights, 2);
  });

  test(
    'override minimum can be switched back to the property minimum',
    () async {
      final controller = PricingController(InMemoryPricingRepository());
      await controller.load();

      controller.openMonth(7);
      controller
        ..updateOverridePrice(weekday: 450, weekend: 550)
        ..updateOverrideMinimum(2);
      expect(controller.editingOverride!.minimumNights, 2);

      controller.setOverrideMinimumInherited(true);
      expect(controller.editingOverride!.minimumNights, isNull);

      expect(await controller.save(), isTrue);
      expect(controller.overrides.single.minimumNights, isNull);
    },
  );

  test(
    'opening a month reuses its override and closeMonth leaves the editor',
    () async {
      const july = MonthOverride(
        month: 7,
        weekdayPrice: 450,
        weekendPrice: 550,
        minimumNights: 2,
      );
      final controller = PricingController(
        InMemoryPricingRepository(initialOverrides: const [july]),
      );
      await controller.load();

      controller.openMonth(7);
      expect(controller.editingOverride, july);
      expect(controller.editingOverrideEqualsBase, isFalse);

      controller.closeMonth();
      expect(controller.editingOverride, isNull);
    },
  );

  test('load failure sets error state and blocks save', () async {
    final controller = PricingController(
      InMemoryPricingRepository(loadError: StateError('offline')),
    );

    await controller.load();

    expect(controller.loadState, PricingLoadState.error);
    expect(controller.loadError, isA<StateError>());
    expect(await controller.save(), isFalse);
  });

  test('retrySave retries only failed portals and merges statuses', () async {
    final repo = InMemoryPricingRepository(failingPortals: {Portal.airbnb});
    final controller = PricingController(repo);
    await controller.load();
    controller.updateWeekdayPrice(400);
    expect(await controller.save(), isTrue);

    final firstResult = controller.lastSaveResult!;
    expect(firstResult.statuses[Portal.booking], PortalSyncStatus.confirmed);
    expect(firstResult.statuses[Portal.airbnb], PortalSyncStatus.failed);

    await controller.retrySave();

    final retriedResult = controller.lastSaveResult!;
    expect(retriedResult.statuses[Portal.booking], PortalSyncStatus.confirmed);
    expect(retriedResult.statuses[Portal.airbnb], PortalSyncStatus.confirmed);
    expect(retriedResult.savedAt, firstResult.savedAt);
  });

  test('second save is rejected while the first one is in flight', () async {
    final repo = GatedSaveRepository();
    final controller = PricingController(repo);
    await controller.load();
    controller.updateWeekdayPrice(400);

    final firstSave = controller.save();
    expect(controller.isSaving, isTrue);
    expect(await controller.save(), isFalse);

    repo.gate.complete();

    expect(await firstSave, isTrue);
    expect(controller.isSaving, isFalse);
  });

  test('validateField checks a field on focus loss without saving', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller.updateWeekdayPrice(0);
    expect(controller.errors, isEmpty);

    controller.validateField(PricingField.weekdayPrice);
    expect(controller.errors[PricingField.weekdayPrice], PricingError.positive);

    controller.updateWeekdayPrice(400);
    controller.validateField(PricingField.weekdayPrice);
    expect(controller.errors, isEmpty);
  });

  test('empty draft field blocks save until it is filled', () async {
    final controller = PricingController(InMemoryPricingRepository());
    await controller.load();

    controller
      ..updateBookingMarkup(0)
      ..setFieldEmpty(PricingField.bookingMarkup, true);

    expect(
      controller.errors[PricingField.bookingMarkup],
      PricingError.required,
    );
    expect(await controller.save(), isFalse);

    controller
      ..updateBookingMarkup(16)
      ..setFieldEmpty(PricingField.bookingMarkup, false);

    expect(controller.errors[PricingField.bookingMarkup], isNull);
    expect(await controller.save(), isTrue);
  });

  test(
    'empty override price blocks save and validates on focus loss',
    () async {
      final controller = PricingController(InMemoryPricingRepository());
      await controller.load();
      controller.openMonth(7);

      controller
        ..updateOverridePrice(weekday: 0, weekend: 550)
        ..validateOverrideField(PricingField.weekdayPrice);

      expect(
        controller.errors[PricingField.weekdayPrice],
        PricingError.positive,
      );

      controller.setOverridePriceEmpty(PricingField.weekdayPrice, true);
      expect(
        controller.errors[PricingField.weekdayPrice],
        PricingError.required,
      );
      expect(await controller.save(), isFalse);

      controller
        ..updateOverridePrice(weekday: 450, weekend: 550)
        ..setOverridePriceEmpty(PricingField.weekdayPrice, false);

      expect(controller.errors[PricingField.weekdayPrice], isNull);
      expect(await controller.save(), isTrue);
    },
  );

  test('state changes notify listeners', () async {
    final controller = PricingController(InMemoryPricingRepository());
    var notifications = 0;
    controller.addListener(() => notifications++);

    await controller.load();
    final afterLoad = notifications;
    expect(afterLoad, greaterThan(0));

    controller.updateWeekdayPrice(400);
    expect(notifications, greaterThan(afterLoad));
  });
}
