import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations_lookup.dart';

/// Pole numeryczne cennika: tylko cyfry, jednostka po prawej stronie.
class PricingField extends StatefulWidget {
  const PricingField({
    required this.label,
    required this.value,
    required this.suffix,
    required this.onChanged,
    this.errorText,
    this.focusNode,
    this.onEmptyChanged,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final int value;
  final String suffix;
  final String? errorText;
  final ValueChanged<int> onChanged;

  /// Informuje o pustym wpisie; liczbowy [onChanged] dostaje wtedy `0`.
  final ValueChanged<bool>? onEmptyChanged;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction textInputAction;
  final String? semanticLabel;

  @override
  State<PricingField> createState() => _PricingFieldState();
}

class _PricingFieldState extends State<PricingField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value.toString(),
  );
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  late int _lastValue;
  int? _expectedInputValue;
  bool _isEmptyInput = false;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.value;
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_selectAllOnFocus);
  }

  @override
  void didUpdateWidget(covariant PricingField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_selectAllOnFocus);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_selectAllOnFocus);
    }

    if (widget.value != _lastValue) {
      // Zmiana z zewnątrz (np. odrzucenie zmian) przywraca liczbę w polu.
      if (_expectedInputValue != widget.value) {
        _isEmptyInput = false;
      }
      _expectedInputValue = null;
      _lastValue = widget.value;
    }
    final nextText = _isEmptyInput ? '' : widget.value.toString();
    if (_controller.text != nextText) {
      _controller.value = _controller.value.copyWith(
        text: nextText,
        selection: TextSelection.collapsed(offset: nextText.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_selectAllOnFocus);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _selectAllOnFocus() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    }
  }

  void _handleChanged(String text) {
    final isEmpty = text.trim().isEmpty;
    final value = int.tryParse(text) ?? 0;
    _isEmptyInput = isEmpty;
    _expectedInputValue = value;
    widget.onChanged(value);
    widget.onEmptyChanged?.call(isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = resolveAppLocalizations(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colors.outline),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colors.primary, width: 3),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colors.error, width: 3),
    );

    final errorMessage = widget.errorText;

    return MergeSemantics(
      child: Semantics(
        textField: true,
        liveRegion: errorMessage != null,
        label: widget.semanticLabel ?? widget.label,
        value: _isEmptyInput ? '' : widget.value.toString(),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          textInputAction: widget.textInputAction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          onChanged: _handleChanged,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(fontSize: 14),
            floatingLabelStyle: const TextStyle(fontSize: 14),
            suffixText: widget.suffix,
            suffixIcon: errorMessage == null
                ? null
                : Icon(Icons.error_outline, color: colors.error),
            helperText: errorMessage == null ? l10n.pricingFieldHelper : null,
            errorText: errorMessage,
            // Komunikat może się zawijać; nie skracamy go do jednej linii.
            errorMaxLines: 4,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
        ),
      ),
    );
  }
}
