import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart'
    show resolveAppLocalizations, resolveLocale;
import '../model/month_override.dart';
import '../model/pricing_draft.dart';
import '../model/pricing_error.dart';
import '../model/pricing_field.dart' as form_field;
import '../pricing_formatter.dart';
import '../pricing_validator.dart';
import 'night_stepper.dart';
import 'pricing_field.dart';

/// Panel edycji jednego wpisu miesiąca.
///
/// Nie ma własnego przycisku zapisu — zapisuje przyklejony pasek formularza.
class MonthEntryEditor extends StatelessWidget {
  const MonthEntryEditor({
    required MonthOverride override,
    required this.baseDraft,
    required this.onChanged,
    required this.onDelete,
    required this.isNew,
    super.key,
  }) : monthOverride = override;

  final MonthOverride monthOverride;
  final PricingDraft baseDraft;
  final ValueChanged<MonthOverride> onChanged;
  final VoidCallback onDelete;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final formatter = PricingFormatter(resolveLocale(context));
    final errors = PricingValidator.validateOverride(monthOverride);
    final inheritsMinimum = monthOverride.minimumNights == null;

    String? errorText(form_field.PricingField field) {
      final error = errors[field];
      return switch (error) {
        PricingError.positive => l10n.pricingErrorPositive,
        PricingError.maxPrice => l10n.pricingErrorMaxPrice,
        _ => null,
      };
    }

    final minimumLabel = l10n.pricingUseResortMinimum(baseDraft.minNights);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          l10n.pricingEntryTitle(formatter.monthLong(monthOverride.month)),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(l10n.pricingEntrySubtitle, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        PricingField(
          label: l10n.pricingWeekdayFieldLabel,
          value: monthOverride.weekdayPrice,
          suffix: l10n.pricingCurrencyUnit,
          errorText: errorText(form_field.PricingField.weekdayPrice),
          onChanged: (value) =>
              onChanged(monthOverride.copyWith(weekdayPrice: value)),
        ),
        const SizedBox(height: 16),
        PricingField(
          label: l10n.pricingWeekendFieldLabel,
          value: monthOverride.weekendPrice,
          suffix: l10n.pricingCurrencyUnit,
          errorText: errorText(form_field.PricingField.weekendPrice),
          onChanged: (value) =>
              onChanged(monthOverride.copyWith(weekendPrice: value)),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.pricingMinStayLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        MergeSemantics(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(minimumLabel),
            value: inheritsMinimum,
            onChanged: (checked) => onChanged(
              checked
                  ? monthOverride.copyWith(clearMinimumNights: true)
                  : monthOverride.copyWith(
                      minimumNights:
                          monthOverride.minimumNights ?? baseDraft.minNights,
                    ),
            ),
          ),
        ),
        if (!inheritsMinimum)
          NightStepper(
            value: monthOverride.minimumNights ?? baseDraft.minNights,
            onChanged: (value) =>
                onChanged(monthOverride.copyWith(minimumNights: value)),
          ),
        const SizedBox(height: 16),
        TextButton(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(const Size(48, 48)),
          ),
          onPressed: () => _confirmDelete(context),
          child: Text(l10n.pricingDeleteEntry),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = resolveAppLocalizations(context);
    final formatter = PricingFormatter(resolveLocale(context));
    final actionStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Semantics(
          header: true,
          child: Text(
            l10n.pricingDeleteConfirmTitle(
              formatter.monthForOfPhrase(monthOverride.month),
            ),
          ),
        ),
        content: Text(l10n.pricingDeleteConfirmBody),
        actions: <Widget>[
          TextButton(
            style: actionStyle,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.pricingCancel),
          ),
          TextButton(
            style: actionStyle,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.pricingDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete();
    }
  }
}
