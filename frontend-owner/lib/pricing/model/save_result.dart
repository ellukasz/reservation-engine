import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';

/// Wynik zapisu cennika wraz ze stanem wysyłki do portali.
class SaveResult {
  const SaveResult({required this.savedAt, required this.statuses});

  final DateTime savedAt;
  final Map<Portal, PortalSyncStatus> statuses;
}

/// Cennik wczytany z repozytorium.
class PricingSnapshot {
  const PricingSnapshot({required this.draft, required this.overrides});

  final PricingDraft draft;
  final List<MonthOverride> overrides;
}
