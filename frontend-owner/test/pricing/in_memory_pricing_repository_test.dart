import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_owner/pricing/model/in_memory_pricing_repository.dart';
import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';

void main() {
  test('loads seeded snapshot', () async {
    final repo = InMemoryPricingRepository();
    final snapshot = await repo.load();
    expect(snapshot.draft.depositPercent, 30);
    expect(snapshot.overrides, isEmpty);
  });

  test('loads caller-provided draft and overrides', () async {
    const draft = PricingDraft(
      weekdayPrice: 400,
      weekendPrice: 500,
      bookingMarkup: 16,
      airbnbMarkup: 10,
      depositPercent: 40,
      minNights: 2,
    );
    const overrides = [
      MonthOverride(month: 7, weekdayPrice: 450, weekendPrice: 550),
    ];
    final repo = InMemoryPricingRepository(
      initialDraft: draft,
      initialOverrides: overrides,
    );
    final snapshot = await repo.load();
    expect(snapshot.draft, draft);
    expect(snapshot.overrides, overrides);
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
}
