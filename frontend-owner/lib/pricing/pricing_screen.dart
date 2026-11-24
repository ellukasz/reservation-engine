import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_lookup.dart';
import 'model/month_override.dart';
import 'model/pricing_error.dart';
import 'model/pricing_field.dart' as form_field;
import 'pricing_controller.dart';
import 'pricing_formatter.dart';
import 'widgets/legend_card.dart';
import 'widgets/month_entry_editor.dart';
import 'widgets/month_grid.dart';
import 'widgets/night_stepper.dart';
import 'widgets/pricing_field.dart';
import 'widgets/save_bar.dart';
import 'widgets/sync_status_banner.dart';

/// Jeden ekran cennika: pola, miesiące, zapis i status portali.
class PricingScreen extends StatefulWidget {
  const PricingScreen({required this.controller, super.key});

  final PricingController controller;

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  static const double _contentMaxWidth = 480;
  static const Duration _savedFeedback = Duration(seconds: 2);
  static final OrderedTraversalPolicy _focusPolicy = OrderedTraversalPolicy();

  final Map<form_field.PricingField, FocusNode> _focusNodes = {
    for (final field in form_field.PricingField.values)
      field: FocusNode(debugLabel: 'pricing-$field'),
  };
  final GlobalKey _editorKey = GlobalKey(debugLabel: 'pricing-month-editor');
  final Map<form_field.PricingField, bool> _fieldHadFocus = {
    for (final field in form_field.PricingField.values) field: false,
  };

  bool _monthsExpanded = false;
  bool _showSaved = false;
  bool _basePricesNotice = false;
  bool _syncRetryError = false;
  DateTime? _lastSavedAt;
  Timer? _savedTimer;

  @override
  void initState() {
    super.initState();
    for (final entry in _focusNodes.entries) {
      entry.value.addListener(() => _onFieldFocused(entry.key, entry.value));
    }
    widget.controller.addListener(_onControllerChanged);
    widget.controller.load();
  }

  @override
  void dispose() {
    _savedTimer?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    if (widget.controller.isDirty) {
      _showSaved = false;
      _basePricesNotice = false;
      _syncRetryError = false;
    }
    setState(() {});
  }

  void _onFieldFocused(form_field.PricingField field, FocusNode node) {
    final context = node.context;
    if (node.hasFocus && context != null) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.2,
        duration: const Duration(milliseconds: 150),
      );
    }
    if (_fieldHadFocus[field] == true && !node.hasFocus) {
      widget.controller.validateField(field);
    }
    _fieldHadFocus[field] = node.hasFocus;
  }

  String? _errorText(AppLocalizations l10n, PricingError? error) =>
      switch (error) {
        PricingError.required => l10n.pricingErrorRequired,
        PricingError.positive => l10n.pricingErrorPositive,
        PricingError.wholeZloty => l10n.pricingErrorWholeZloty,
        PricingError.percentRange => l10n.pricingErrorPercentRange,
        PricingError.depositRange => l10n.pricingErrorDepositRange,
        PricingError.minNightsRange => l10n.pricingErrorMinNightsRange,
        PricingError.maxPrice => l10n.pricingErrorMaxPrice,
        null => null,
      };

  Widget _field({
    required AppLocalizations l10n,
    required Key fieldKey,
    required form_field.PricingField field,
    required String label,
    required String semanticLabel,
    required int value,
    required String suffix,
    required ValueChanged<int> onChanged,
    required bool enabled,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return PricingField(
      key: fieldKey,
      label: label,
      value: value,
      suffix: suffix,
      errorText: _errorText(l10n, widget.controller.draftErrors[field]),
      focusNode: _focusNodes[field],
      enabled: enabled,
      textInputAction: textInputAction,
      semanticLabel: semanticLabel,
      onChanged: onChanged,
      onEmptyChanged: (isEmpty) =>
          widget.controller.setFieldEmpty(field, isEmpty),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );

  Widget _portalCaption({
    required AppLocalizations l10n,
    required PricingFormatter formatter,
    required String portalName,
    required int basePrice,
    required int markup,
  }) {
    if (markup == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 12),
        child: Text(
          l10n.pricingPortalUnchanged,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }
    final portalPrice = ((basePrice * (100 + markup)) / 100).round();
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.pricingPortalPriceIntro(portalName),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            formatter.zloty(portalPrice),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _depositCaption({
    required AppLocalizations l10n,
    required PricingFormatter formatter,
    required int depositPercent,
  }) {
    if (depositPercent == 100) {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 12),
        child: Text(
          l10n.pricingDepositFullOnline,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }
    const exampleTotal = 1000;
    final online = (exampleTotal * depositPercent / 100).round();
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 12),
      child: Text(
        l10n.pricingDepositExample(
          formatter.zloty(exampleTotal),
          formatter.zloty(online),
          formatter.zloty(exampleTotal - online),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _noticeCard({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.error_outline, color: colors.onErrorContainer),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(color: colors.onErrorContainer),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onAction,
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(48, 48)),
                foregroundColor: WidgetStateProperty.all(
                  colors.onErrorContainer,
                ),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDiscard() => showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final dialogL10n = resolveAppLocalizations(dialogContext);
      return AlertDialog(
        title: Semantics(
          header: true,
          child: Text(dialogL10n.pricingDiscardTitle),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogL10n.pricingStay),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogL10n.pricingDiscard),
          ),
        ],
      );
    },
  );

  Future<void> _openMonth(int month) async {
    if (widget.controller.isDirty) {
      final discard = await _confirmDiscard();
      if (!mounted || discard != true) return;
      widget.controller.discardChanges();
      widget.controller.closeMonth();
    }
    widget.controller.openMonth(month);
    _scrollToEditor();
  }

  void _updateEntry(MonthOverride next) {
    final current = widget.controller.editingOverride;
    if (current == null) return;
    if (next.minimumNights != current.minimumNights) {
      final minimum = next.minimumNights;
      if (minimum == null) {
        widget.controller.setOverrideMinimumInherited(true);
      } else {
        if (current.minimumNights == null) {
          widget.controller.setOverrideMinimumInherited(false);
        }
        widget.controller.updateOverrideMinimum(minimum);
      }
      return;
    }
    if (next.weekdayPrice != current.weekdayPrice ||
        next.weekendPrice != current.weekendPrice) {
      widget.controller.updateOverridePrice(
        weekday: next.weekdayPrice,
        weekend: next.weekendPrice,
      );
    }
  }

  void _scrollToEditor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final editorContext = _editorKey.currentContext;
      if (editorContext != null) {
        Scrollable.ensureVisible(
          editorContext,
          alignment: 0.2,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  Future<void> _toggleMonths() async {
    if (_monthsExpanded && widget.controller.isDirty) {
      final discard = await _confirmDiscard();
      if (!mounted || discard != true) return;
      widget.controller.discardChanges();
    }
    setState(() {
      if (_monthsExpanded) {
        _monthsExpanded = false;
        widget.controller.closeMonth();
      } else {
        _monthsExpanded = true;
      }
    });
  }

  void _focusFirstError() {
    for (final field in form_field.PricingField.values) {
      if (!widget.controller.errors.containsKey(field)) continue;
      final node = _focusNodes[field];
      if (node == null) continue;
      node.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final fieldContext = node.context;
        if (fieldContext != null) {
          Scrollable.ensureVisible(fieldContext, alignment: 0.2);
        }
      });
      return;
    }
  }

  Future<void> _save() async {
    final closedBaseEntry =
        widget.controller.editingOverride != null &&
        widget.controller.editingOverrideEqualsBase;
    final saved = await widget.controller.save();
    if (!mounted) return;

    setState(() {
      _syncRetryError = false;
      _showSaved = saved;
      if (saved) {
        _lastSavedAt = DateTime.now();
        _basePricesNotice = closedBaseEntry;
        _savedTimer?.cancel();
        _savedTimer = Timer(_savedFeedback, () {
          if (!mounted) return;
          setState(() => _showSaved = false);
        });
      }
    });
    if (!saved) {
      _focusFirstError();
    }
  }

  Future<void> _retryPortals() async {
    try {
      await widget.controller.retrySave();
      if (!mounted) return;
      setState(() => _syncRetryError = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _syncRetryError = true);
    }
  }

  Future<void> _leaveScreen() async {
    final discard = await _confirmDiscard();
    if (!mounted || discard != true) return;
    widget.controller.discardChanges();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final formatter = PricingFormatter(resolveLocale(context));
    final controller = widget.controller;
    final draft = controller.draft;
    final ready = controller.loadState == PricingLoadState.ready;
    final loadFailed = controller.loadState == PricingLoadState.error;
    final hasSaveError = controller.saveError != null || _syncRetryError;
    final editing = controller.editingOverride;
    final editingMonth = editing?.month;
    final isNewEntry =
        editingMonth != null &&
        !controller.overrides.any((entry) => entry.month == editingMonth);
    final showSync =
        ready && !controller.isDirty && controller.lastSaveResult != null;

    return PopScope(
      canPop: !controller.isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_leaveScreen());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.pricingTitle)),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: Column(
              // Center daje luźne ograniczenia — kolumna z Expanded wymusza
              // wypełnienie dostępnej wysokości, więc pola są widoczne.
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    key: const PageStorageKey<String>('pricing-form'),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: FocusTraversalGroup(
                      policy: _focusPolicy,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            l10n.pricingSubtitle,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (controller.loadState == PricingLoadState.loading)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          if (loadFailed)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: _noticeCard(
                                message: l10n.pricingLoadError,
                                actionLabel: l10n.pricingRetry,
                                onAction: () => unawaited(controller.load()),
                              ),
                            ),
                          if (ready && hasSaveError)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: _noticeCard(
                                message: l10n.pricingSaveError,
                                actionLabel: l10n.pricingRetry,
                                onAction: () => unawaited(_save()),
                              ),
                            ),
                          if (_basePricesNotice)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                l10n.pricingBasePricesNotice,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (showSync)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: SyncStatusBanner(
                                result: controller.lastSaveResult,
                                onRetry: () => unawaited(_retryPortals()),
                              ),
                            ),
                          if (ready && controller.errors.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Semantics(
                                container: true,
                                liveRegion: true,
                                label: l10n.pricingErrorSummary(
                                  controller.errors.length,
                                ),
                                child: Text(
                                  l10n.pricingErrorSummary(
                                    controller.errors.length,
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          _sectionLabel(l10n.pricingSectionNightly),
                          _field(
                            l10n: l10n,
                            fieldKey: const Key('weekdayPrice'),
                            field: form_field.PricingField.weekdayPrice,
                            label: l10n.pricingWeekdayLabel,
                            semanticLabel: l10n.pricingWeekdaySemantic,
                            value: draft.weekdayPrice,
                            suffix: l10n.pricingCurrencyUnit,
                            enabled: ready,
                            onChanged: controller.updateWeekdayPrice,
                          ),
                          const SizedBox(height: 16),
                          _field(
                            l10n: l10n,
                            fieldKey: const Key('weekendPrice'),
                            field: form_field.PricingField.weekendPrice,
                            label: l10n.pricingWeekendLabel,
                            semanticLabel: l10n.pricingWeekendSemantic,
                            value: draft.weekendPrice,
                            suffix: l10n.pricingCurrencyUnit,
                            enabled: ready,
                            onChanged: controller.updateWeekendPrice,
                          ),
                          _sectionLabel(l10n.pricingSectionPortals),
                          _field(
                            l10n: l10n,
                            fieldKey: const Key('bookingMarkup'),
                            field: form_field.PricingField.bookingMarkup,
                            label: l10n.pricingBookingIncrease,
                            semanticLabel: l10n.pricingBookingSemantic,
                            value: draft.bookingMarkup,
                            suffix: l10n.pricingPercentUnit,
                            enabled: ready,
                            onChanged: controller.updateBookingMarkup,
                          ),
                          _portalCaption(
                            l10n: l10n,
                            formatter: formatter,
                            portalName: l10n.pricingPortalBooking,
                            basePrice: draft.weekendPrice,
                            markup: draft.bookingMarkup,
                          ),
                          _field(
                            l10n: l10n,
                            fieldKey: const Key('airbnbMarkup'),
                            field: form_field.PricingField.airbnbMarkup,
                            label: l10n.pricingAirbnbIncrease,
                            semanticLabel: l10n.pricingAirbnbSemantic,
                            value: draft.airbnbMarkup,
                            suffix: l10n.pricingPercentUnit,
                            enabled: ready,
                            onChanged: controller.updateAirbnbMarkup,
                          ),
                          _portalCaption(
                            l10n: l10n,
                            formatter: formatter,
                            portalName: l10n.pricingPortalAirbnb,
                            basePrice: draft.weekendPrice,
                            markup: draft.airbnbMarkup,
                          ),
                          _sectionLabel(l10n.pricingSectionReservation),
                          _field(
                            l10n: l10n,
                            fieldKey: const Key('depositPercent'),
                            field: form_field.PricingField.depositPercent,
                            label: l10n.pricingDepositLabel,
                            semanticLabel: l10n.pricingDepositSemantic,
                            value: draft.depositPercent,
                            suffix: l10n.pricingPercentUnit,
                            enabled: ready,
                            onChanged: controller.updateDepositPercent,
                            textInputAction: TextInputAction.done,
                          ),
                          _depositCaption(
                            l10n: l10n,
                            formatter: formatter,
                            depositPercent: draft.depositPercent,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Text(
                              l10n.pricingMinStayLabel,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Semantics(
                            label: l10n.pricingMinStaySemantic,
                            child: NightStepper(
                              key: const Key('minNights'),
                              value: draft.minNights,
                              enabled: ready,
                              errorText: _errorText(
                                l10n,
                                controller.draftErrors[form_field
                                    .PricingField
                                    .minNights],
                              ),
                              onChanged: controller.updateMinNights,
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () => unawaited(_toggleMonths()),
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(
                                const Size(0, 48),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(child: Text(l10n.pricingMonthsAction)),
                                const SizedBox(width: 8),
                                Icon(
                                  _monthsExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                              ],
                            ),
                          ),
                          if (_monthsExpanded) ...<Widget>[
                            const SizedBox(height: 12),
                            Semantics(
                              header: true,
                              child: Text(
                                l10n.pricingMonthsHint,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Nowa instancja przy każdym wejściu: legenda znów jest zwinięta.
                            const LegendCard(),
                            const SizedBox(height: 12),
                            if (controller.overrides.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  l10n.pricingMonthsEmpty,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            SizedBox(
                              height: 520,
                              child: MonthGrid(
                                draft: draft,
                                overrides: controller.overrides,
                                onMonthTap: (month) =>
                                    unawaited(_openMonth(month)),
                              ),
                            ),
                            if (editing != null)
                              Container(
                                key: _editorKey,
                                padding: const EdgeInsets.only(top: 16),
                                child: MonthEntryEditor(
                                  override: editing,
                                  baseDraft: draft,
                                  isNew: isNewEntry,
                                  onChanged: (next) => _updateEntry(next),
                                  onDelete: () => controller
                                      .deleteMonthOverride(editing.month),
                                  emptyFields: controller.emptyOverrideFields,
                                  onFieldLeft: controller.validateOverrideField,
                                  onPriceEmptyChanged: (field, isEmpty) =>
                                      controller.setOverridePriceEmpty(
                                        field,
                                        isEmpty,
                                      ),
                                ),
                              ),
                            TextButton(
                              onPressed: () => unawaited(_toggleMonths()),
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(
                                  const Size(48, 48),
                                ),
                              ),
                              child: Text(l10n.pricingMonthsCollapse),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: _bottomInset(context),
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  child: SaveBar(
                    isDirty:
                        controller.isDirty ||
                        controller.editingOverride != null,
                    isSaving: controller.isSaving,
                    enabled: ready,
                    showSaved: _showSaved,
                    lastSavedAt: _lastSavedAt,
                    onSave: () => unawaited(_save()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// SafeArea zdejmuje dolnyInsets z MediaQuery.padding — dodajemy go z powrotem
  /// razem z przestrzenią zajętą przez klawiaturę, ale bez podwójnego liczenia.
  double _bottomInset(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final system = MediaQuery.viewPaddingOf(context).bottom;
    return keyboard > system ? keyboard : system;
  }
}
