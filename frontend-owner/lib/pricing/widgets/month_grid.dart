import 'package:material_ui/material_ui.dart';

import '../model/month_override.dart';
import '../model/pricing_draft.dart';
import 'month_tile.dart';

/// Siatka dwunastu miesięcy: 2 kolumny na telefonie, 1 przy dużej czcionce
/// lub na wąskim ekranie.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.draft,
    required this.overrides,
    required this.onMonthTap,
    super.key,
  });

  final PricingDraft draft;
  final List<MonthOverride> overrides;
  final ValueChanged<int> onMonthTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 340 &&
                MediaQuery.textScalerOf(context).scale(14) <= 18
            ? 2
            : 1;
        final overrideByMonth = <int, MonthOverride>{
          for (final override in overrides) override.month: override,
        };

        final tiles = List<Widget>.generate(12, (index) {
          final month = index + 1;
          return MonthTile(
            month: month,
            override: overrideByMonth[month],
            baseWeekdayPrice: draft.weekdayPrice,
            baseWeekendPrice: draft.weekendPrice,
            baseMinNights: draft.minNights,
            onTap: () => onMonthTap(month),
          );
        });

        final rows = <Widget>[];
        for (var start = 0; start < tiles.length; start += columns) {
          final end = start + columns > tiles.length
              ? tiles.length
              : start + columns;
          final rowTiles = <Widget>[];
          for (var index = start; index < end; index++) {
            if (rowTiles.isNotEmpty) {
              rowTiles.add(const SizedBox(width: 12));
            }
            rowTiles.add(Expanded(child: tiles[index]));
          }
          rows.add(IntrinsicHeight(child: Row(children: rowTiles)));
          if (end < tiles.length) {
            rows.add(const SizedBox(height: 12));
          }
        }

        return SingleChildScrollView(
          key: const PageStorageKey<String>('pricing-months-grid'),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          ),
        );
      },
    );
  }
}
