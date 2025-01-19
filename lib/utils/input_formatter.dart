import 'package:flutter/services.dart';

class InputFormatter extends TextInputFormatter {
  final int decimalRange;
  final int beforeDecimal;

  InputFormatter({
    this.decimalRange = 2,
    this.beforeDecimal = 5,
  }) : assert(decimalRange >= 0 && beforeDecimal >= 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Handle empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle non-numeric input
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text)) {
      return oldValue;
    }

    String newText = newValue.text;
    TextSelection newSelection = newValue.selection;

    // Split the input into before and after decimal parts
    List<String> parts = newText.split('.');

    // Check the length of the part before the decimal
    if (parts[0].length > beforeDecimal) {
      parts[0] = parts[0].substring(0, beforeDecimal);
    }

    // Check the length of the part after the decimal
    if (parts.length > 1 && parts[1].length > decimalRange) {
      parts[1] = parts[1].substring(0, decimalRange);
    }

    // Reconstruct the new text
    newText = parts.join('.');

    // Update the text value
    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}