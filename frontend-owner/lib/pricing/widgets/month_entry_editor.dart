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
class MonthEntryEditor extends StatefulWidget {
  const MonthEntryEditor({
    required MonthOverride override,
    required this.baseDraft,
    required this.onChanged,
    required this.onDelete,
    required this.isNew,
    this.emptyFields = const {},
    this.onFieldLeft,
    this.onPriceEmptyChanged,
    super.key,
  }) : monthOverride = override;

  final MonthOverride monthOverride;
  final PricingDraft baseDraft;
  final ValueChanged<MonthOverride> onChanged;
  final VoidCallback onDelete;
  final bool isNew;

  /// Puste ceny wpisu; pustej ceny nie wolno potraktować jako zera.
  final Set<form_field.PricingField> emptyFields;

  /// Wywoływane po opuszczeniu ceny wpisu.
  final ValueChanged<form_field.PricingField>? onFieldLeft;

  /// Wywoływane, gdy użytkownik wyczyści lub uzupełni cenę wpisu.
  final void Function(form_field.PricingField field, bool isEmpty)?
  onPriceEmptyChanged;

  @override
  State<MonthEntryEditor> createState() => _MonthEntryEditorState();
}

class _MonthEntryEditorState extends State<MonthEntryEditor> {
  static const _weekday = form_field.PricingField.weekdayPrice;
  static const _weekend = form_field.PricingField.weekendPrice;

  final Map<form_field.PricingField, FocusNode> _focusNodes =
      <form_field.PricingField, FocusNode>{
        _weekday: FocusNode(debugLabel: 'entry-weekday-price'),
        _weekend: FocusNode(debugLabel: 'entry-weekend-price'),
      };
  final Map<form_field.PricingField, bool> _hadFocus =
      <form_field.PricingField, bool>{_weekday: false, _weekend: false};

  @override
  void initState() {
    super.initState();
    for (final entry in _focusNodes.entries) {
      final field = entry.key;
      final node = entry.value;
      node.addListener(() {
        final hadFocus = _hadFocus[field] ?? false;
        if (hadFocus && !node.hasFocus) {
          widget.onFieldLeft?.call(field);
        }
        _hadFocus[field] = node.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final formatter = PricingFormatter(resolveLocale(context));
    final override = widget.monthOverride;
    final errors = PricingValidator.validateOverride(
      override,
      emptyFields: widget.emptyFields,
    );
    final inheritsMinimum = override.minimumNights == null;

    String? errorText(form_field.PricingField field) {
      final error = errors[field];
      return switch (error) {
        PricingError.required => l10n.pricingErrorRequired,
        PricingError.positive => l10n.pricingErrorPositive,
        PricingError.maxPrice => l10n.pricingErrorMaxPrice,
        _ => null,
      };
    }

    final minimumLabel = l10n.pricingUseResortMinimum(
      widget.baseDraft.minNights,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          l10n.pricingEntryTitle(formatter.monthLong(override.month)),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(l10n.pricingEntrySubtitle, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        PricingField(
          label: l10n.pricingWeekdayFieldLabel,
          value: override.weekdayPrice,
          suffix: l10n.pricingCurrencyUnit,
          errorText: errorText(_weekday),
          focusNode: _focusNodes[_weekday],
          onEmptyChanged: (isEmpty) =>
              widget.onPriceEmptyChanged?.call(_weekday, isEmpty),
          onChanged: (value) =>
              widget.onChanged(override.copyWith(weekdayPrice: value)),
        ),
        const SizedBox(height: 16),
        PricingField(
          label: l10n.pricingWeekendFieldLabel,
          value: override.weekendPrice,
          suffix: l10n.pricingCurrencyUnit,
          errorText: errorText(_weekend),
          focusNode: _focusNodes[_weekend],
          onEmptyChanged: (isEmpty) =>
              widget.onPriceEmptyChanged?.call(_weekend, isEmpty),
          onChanged: (value) =>
              widget.onChanged(override.copyWith(weekendPrice: value)),
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
            onChanged: (checked) => widget.onChanged(
              checked
                  ? override.copyWith(clearMinimumNights: true)
                  : override.copyWith(
                      minimumNights:
                          override.minimumNights ?? widget.baseDraft.minNights,
                    ),
            ),
          ),
        ),
        if (!inheritsMinimum)
          NightStepper(
            value: override.minimumNights ?? widget.baseDraft.minNights,
            onChanged: (value) =>
                widget.onChanged(override.copyWith(minimumNights: value)),
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
              formatter.monthForOfPhrase(widget.monthOverride.month),
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
      widget.onDelete();
    }
  }
}
