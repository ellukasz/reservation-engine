import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart'
    show resolveAppLocalizations, resolveLocale;
import '../model/month_override.dart';
import '../pricing_formatter.dart';

/// Jeden kafelek miesiąca — cały jest jednym przyciskiem.
class MonthTile extends StatefulWidget {
  const MonthTile({
    required MonthOverride? override,
    required this.month,
    required this.baseWeekdayPrice,
    required this.baseWeekendPrice,
    required this.baseMinNights,
    required this.onTap,
    super.key,
  }) : monthOverride = override;

  final MonthOverride? monthOverride;
  final int month;
  final int baseWeekdayPrice;
  final int baseWeekendPrice;
  final int baseMinNights;
  final VoidCallback onTap;

  @override
  State<MonthTile> createState() => _MonthTileState();
}

class _MonthTileState extends State<MonthTile> {
  late final FocusNode _focusNode = FocusNode()
    ..addListener(_handleFocusChange);
  bool _focused = false;

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = resolveAppLocalizations(context);
    final colors = Theme.of(context).colorScheme;
    final locale = resolveLocale(context);
    final formatter = PricingFormatter(locale);

    final hasOwnPrice = widget.monthOverride != null;
    final weekdayPrice =
        widget.monthOverride?.weekdayPrice ?? widget.baseWeekdayPrice;
    final weekendPrice =
        widget.monthOverride?.weekendPrice ?? widget.baseWeekendPrice;
    final minimumNights =
        widget.monthOverride?.minimumNights ?? widget.baseMinNights;

    final monthName = formatter.monthLong(widget.month);
    final weekdayText = formatter.zloty(weekdayPrice);
    final weekendText = formatter.zloty(weekendPrice);
    final minimumText = widget.monthOverride?.minimumNights == null
        ? l10n.pricingInheritedMinStay
        : l10n.pricingNightsCount(minimumNights);
    final actionText = hasOwnPrice ? l10n.pricingChange : l10n.pricingSet;
    final badgeText = hasOwnPrice
        ? l10n.pricingTileOwn
        : l10n.pricingTileShared;

    final label = l10n.pricingTileSemantics(
      monthName,
      hasOwnPrice ? l10n.pricingTileOwnPrice : l10n.pricingTileSharedPrice,
      weekdayText,
      weekendText,
      minimumText,
      hasOwnPrice ? l10n.pricingChangeSpoken : l10n.pricingSetSpoken,
    );

    final borderColor = _focused || hasOwnPrice
        ? colors.primary
        : colors.outline;
    final borderWidth = _focused ? 3.0 : (hasOwnPrice ? 2.0 : 1.0);

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Semantics(
          button: true,
          label: label,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onTap,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      monthName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hasOwnPrice
                            ? colors.primaryContainer
                            : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 14,
                          color: hasOwnPrice
                              ? colors.onPrimaryContainer
                              : colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.pricingWeekdayPriceLabel,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(weekdayText, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      l10n.pricingWeekendPriceLabel,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(weekendText, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          l10n.pricingMinStayShort,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(minimumText, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          actionText,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: colors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
