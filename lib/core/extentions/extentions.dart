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
