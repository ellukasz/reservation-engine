import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart';

/// Zwijana legenda kafelków miesięcy.
///
/// Stan jest wyłącznie lokalny: po ponownym wejściu w widok miesięcy legenda
/// znów jest zwinięta.
class LegendCard extends StatefulWidget {
  const LegendCard({this.initiallyExpanded = false, super.key});

  final bool initiallyExpanded;

  @override
  State<LegendCard> createState() => _LegendCardState();
}

class _LegendCardState extends State<LegendCard> {
  late bool _expanded = widget.initiallyExpanded;

  Widget _definition({required String title, required String body}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(body, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _meaning({
    required String text,
    required Color swatch,
    required bool outlined,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2, right: 10),
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : swatch,
            border: outlined ? Border.all(color: swatch, width: 2) : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Semantics(
            explicitChildNodes: true,
            button: true,
            expanded: _expanded,
            label: _expanded
                ? l10n.pricingLegendExpandedLabel
                : l10n.pricingLegendCollapsedLabel,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            l10n.pricingLegendTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _expanded
                              ? l10n.pricingLegendCollapse
                              : l10n.pricingLegendExpand,
                          style: TextStyle(fontSize: 14, color: colors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_expanded)
            Semantics(
              container: true,
              explicitChildNodes: true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _definition(
                      title: l10n.pricingMonthsLegendWeekTitle,
                      body: l10n.pricingMonthsLegendWeek,
                    ),
                    const SizedBox(height: 12),
                    _definition(
                      title: l10n.pricingMonthsLegendWeekendTitle,
                      body: l10n.pricingMonthsLegendWeekend,
                    ),
                    const Divider(height: 24),
                    _meaning(
                      text: l10n.pricingMonthsLegendOwn,
                      swatch: colors.primary,
                      outlined: false,
                    ),
                    const SizedBox(height: 8),
                    _meaning(
                      text: l10n.pricingMonthsLegendShared,
                      swatch: colors.outline,
                      outlined: true,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
