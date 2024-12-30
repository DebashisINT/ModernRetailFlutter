import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange, required this.maxLength})
      : assert(decimalRange > 0);

  final int decimalRange;
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (newValue.text.contains(".") && newValue.text.substring(newValue.text.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (maxLength > 0 && newValue.text.length > maxLength) {
      truncated = newValue.text.substring(0, maxLength);
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}