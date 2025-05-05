import 'dart:ui';

import 'package:intl/intl.dart';

extension FormatDateTime on DateTime {
  String toFormatedString(String pattern) {
    try {
      return DateFormat(
        pattern,
      ).format(this);
    } catch (e) {
      return "";
    }
  }
}

extension StringToDateTime on String {
  DateTime? stringToDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = false}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
