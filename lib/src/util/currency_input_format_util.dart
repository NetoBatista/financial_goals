import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatUtil extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    var newText = stringToMoney(text);
    newText = newText.trim();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String stringToMoney(
    String text, {
    bool symbol = false,
  }) {
    var value = double.parse(text);
    final formatter = NumberFormat.simpleCurrency(
      locale: "pt_Br",
      name: !symbol ? '' : null,
    );
    return formatter.format(value / 100);
  }
}
