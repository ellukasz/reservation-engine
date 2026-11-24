import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_lookup.dart';
import '../model/portal.dart';
import '../model/save_result.dart';

/// Status zapisu i wysyłki cen do portali.
///
/// Komunikat pozostaje widoczny do następnej zmiany cennika — nie znika
/// automatycznie po kilku sekundach.
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({
    required this.result,
    required this.onRetry,
    super.key,
  });

  final SaveResult? result;
  final VoidCallback onRetry;

  static String _portalName(AppLocalizations l10n, Portal portal) =>
      switch (portal) {
        Portal.booking => l10n.pricingPortalBooking,
        Portal.airbnb => l10n.pricingPortalAirbnb,
      };

  String _statusText(
    AppLocalizations l10n,
    Portal portal,
    PortalSyncStatus status,
  ) {
    final name = _portalName(l10n, portal);
    return switch (status) {
      PortalSyncStatus.confirmed => l10n.pricingSyncConfirmed(name),
      PortalSyncStatus.pending => l10n.pricingSyncPending(name),
      PortalSyncStatus.failed => l10n.pricingSyncFailedRow(name),
    };
  }

  @override
  Widget build(BuildContext context) {
    final saveResult = result;
    if (saveResult == null || saveResult.statuses.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = resolveAppLocalizations(context);
    final colors = Theme.of(context).colorScheme;
    final failed = saveResult.statuses.entries
        .where((entry) => entry.value == PortalSyncStatus.failed)
        .map((entry) => entry.key)
        .toList();
    final offline = failed.length == saveResult.statuses.length;
    final warning = failed.isNotEmpty;
    final background = warning
        ? colors.errorContainer
        : colors.primaryContainer;
    final foreground = warning
        ? colors.onErrorContainer
        : colors.onPrimaryContainer;

    final headline = offline
        ? l10n.pricingSyncOffline
        : warning
        ? l10n.pricingSyncFailedBanner(_portalName(l10n, failed.first))
        : l10n.pricingSyncSaved;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  warning ? Icons.cloud_off : Icons.cloud_done,
                  color: foreground,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    headline,
                    style: TextStyle(color: foreground, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final portal in Portal.values)
              if (saveResult.statuses.containsKey(portal))
                Padding(
                  padding: const EdgeInsets.only(left: 34, top: 2),
                  child: Text(
                    _statusText(l10n, portal, saveResult.statuses[portal]!),
                    style: TextStyle(color: foreground, fontSize: 14),
                  ),
                ),
            if (warning)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: onRetry,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(48, 48)),
                    foregroundColor: WidgetStateProperty.all(foreground),
                  ),
                  child: Text(l10n.pricingSyncRetryNow),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
