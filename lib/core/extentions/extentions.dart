import 'package:intl/intl.dart';

extension FormatDateTime on DateTime {
  String toFormatedString(String pattern) {
    try {
      return DateFormat(pattern).format(this);
    } catch (e) {
      return "";
    }
  }
}
