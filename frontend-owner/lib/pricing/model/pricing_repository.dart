import 'package:frontend_owner/pricing/model/month_override.dart';
import 'package:frontend_owner/pricing/model/portal.dart';
import 'package:frontend_owner/pricing/model/pricing_draft.dart';
import 'package:frontend_owner/pricing/model/save_result.dart';

/// Źródło cennika: wczytanie, zapis i ponowienie wysyłki do portalu.
abstract interface class PricingRepository {
  Future<PricingSnapshot> load();

  Future<SaveResult> save(PricingDraft draft, List<MonthOverride> overrides);

  Future<SaveResult> retryPortal(Portal portal);
}
