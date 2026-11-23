import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart';

/// Stepper liczby nocy: bez klawiatury, bez przyspieszania przy przytrzymaniu.
class NightStepper extends StatefulWidget {
  const NightStepper({
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 14,
    this.errorText,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String? errorText;

  @override
  State<NightStepper> createState() => _NightStepperState();
}

class _NightStepperState extends State<NightStepper> {
  late int _value = widget.value;

  int _clamp(int candidate) {
    if (candidate < widget.min) {
      return widget.min;
    }
    if (candidate > widget.max) {
      return widget.max;
    }
    return candidate;
  }

  void _changeBy(int delta) {
    final next = _clamp(_value + delta);
    if (next == _value) {
      return;
    }
    // Aktualizujemy wartość od razu, żeby kolejne dotknięcie nie korzystało
    // z nieodświeżonego jeszcze przez rodzica widżetu.
    setState(() => _value = next);
    widget.onChanged(next);
  }

  @override
  void didUpdateWidget(covariant NightStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = _clamp(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = resolveAppLocalizations(context);
    final decreaseLabel = l10n.pricingDecreaseMinStay;
    final increaseLabel = l10n.pricingIncreaseMinStay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Semantics(
              button: true,
              label: decreaseLabel,
              child: IconButton(
                tooltip: decreaseLabel,
                icon: const Icon(Icons.remove),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: _value <= widget.min ? null : () => _changeBy(-1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Center(
                child: Text(
                  l10n.pricingNightsCount(_value),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: increaseLabel,
              child: IconButton(
                tooltip: increaseLabel,
                icon: const Icon(Icons.add),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: _value >= widget.max ? null : () => _changeBy(1),
              ),
            ),
          ],
        ),
        if (widget.errorText != null)
          Semantics(
            liveRegion: true,
            child: Row(
              children: <Widget>[
                Icon(Icons.error_outline, size: 20, color: colors.error),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.errorText!,
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
