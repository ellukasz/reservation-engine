import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart';

/// Przyklejony pasek zapisu całego cennika.
///
/// Stan „Zapisano" jest krótkim potwierdzeniem — znika po [savedFeedback]
/// albo przy kolejnej zmianie formularza.
class SaveBar extends StatelessWidget {
  const SaveBar({
    required this.isDirty,
    required this.isSaving,
    required this.onSave,
    this.enabled = true,
    this.showSaved = false,
    this.lastSavedAt,
    super.key,
  });

  final bool isDirty;
  final bool isSaving;
  final VoidCallback onSave;

  /// Wczytywanie i błąd wczytania blokują zapis niezależnie od [isDirty].
  final bool enabled;

  /// Czy pokazać krótkie potwierdzenie „Zapisano".
  final bool showSaved;

  /// Godzina ostatniego udanego zapisu.
  final DateTime? lastSavedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final canSave = enabled && isDirty && !isSaving;
    final label = isSaving
        ? l10n.pricingSaving
        : showSaved
        ? l10n.pricingSaved
        : l10n.pricingSave;
    final savedAt = lastSavedAt;

    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canSave ? onSave : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 56)),
              child: isSaving
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(label),
                      ],
                    )
                  : Text(label),
            ),
          ),
          if (savedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                l10n.pricingLastSaved(
                  DateFormat.Hm(resolveLocale(context).toLanguageTag())
                      .format(savedAt),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
