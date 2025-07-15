import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final num min;
  final num max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if ((int.tryParse(newValue.text) ?? 1) < min) {
      return const TextEditingValue().copyWith(text: oldValue.text);
    } else {
      return (int.tryParse(newValue.text) ?? 1) > max ? oldValue : newValue;
    }
  }
}
