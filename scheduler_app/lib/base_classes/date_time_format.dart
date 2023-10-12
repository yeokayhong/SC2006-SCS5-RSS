import 'package:intl/intl.dart';

extension dateTimeFormat on DateTime {
  String fullDate() {
    return DateFormat.yMMMMd('en_US').format(
        DateTime.fromMicrosecondsSinceEpoch(this.microsecondsSinceEpoch));
  }
}
