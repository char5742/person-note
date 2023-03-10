import 'package:intl/intl.dart';

String formatDate(DateTime? datetime, {String delimiter = '-'}) {
  if (datetime == null) {
    return '00${delimiter}00';
  }
  DateFormat outputFormat = DateFormat('MMMMd');
  String date = outputFormat.format(datetime);
  return date;
}

String formatDateTime(DateTime? datetime, {String delimiter = '-'}) {
  if (datetime == null) {
    return '0000${delimiter}00${delimiter}00 ( )';
  }
  DateFormat outputFormat =
      DateFormat('yyyy${delimiter}MM${delimiter}dd (EEE)');
  String date = outputFormat.format(datetime);
  return date;
}
