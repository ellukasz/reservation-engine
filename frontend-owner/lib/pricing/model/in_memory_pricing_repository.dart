import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/model/pricing_repository.dart';
import 'package:frontend_owner/pricing/model/save_result.dart';

/// Lokalne repozytorium cennika symulujące zapis i statusy portali.
class InMemoryPricingRepository implements PricingRepository {
  InMemoryPricingRepository({
    PricingDraft? initialDraft,
    List<MonthOverride> initialOverrides = const [],
    this.failingPortals = const {},
    this.loadError,
  }) : _draft = initialDraft ?? PricingDraft.initial(),
       _overrides = List<MonthOverride>.from(initialOverrides);

  PricingDraft _draft;
  final List<MonthOverride> _overrides;
  final Set<Portal> failingPortals;
  final Object? loadError;
  Map<Portal, PortalSyncStatus> _statuses = {
    for (final portal in Portal.values) portal: PortalSyncStatus.confirmed,
  };

  @override
  Future<PricingSnapshot> load() async {
    final error = loadError;
    if (error != null) {
      throw error;
    }
    return PricingSnapshot(
      draft: _draft,
      overrides: List<MonthOverride>.unmodifiable(_overrides),
    );
  }

  @override
  Future<SaveResult> save(
    PricingDraft draft,
    List<MonthOverride> overrides,
  ) async {
    _draft = draft;
    _overrides
      ..clear()
      ..addAll(overrides);
    _statuses = {
      for (final portal in Portal.values)
        portal: failingPortals.contains(portal)
            ? PortalSyncStatus.failed
            : PortalSyncStatus.confirmed,
    };
    return SaveResult(
      savedAt: DateTime.now(),
      statuses: Map<Portal, PortalSyncStatus>.unmodifiable(_statuses),
    );
  }

  @override
  Future<SaveResult> retryPortal(Portal portal) async {
    _statuses = {..._statuses, portal: PortalSyncStatus.confirmed};
    return SaveResult(
      savedAt: DateTime.now(),
      statuses: Map<Portal, PortalSyncStatus>.unmodifiable(_statuses),
    );
  }
}
