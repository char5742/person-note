import 'package:intl/intl.dart';

String formatDate(DateTime? datetime, {String delimiter = '-'}) {
  if (datetime == null) {
    return '00${delimiter}00';
  }
  DateFormat outputFormat = DateFormat('MM${delimiter}dd');
  String date = outputFormat.format(datetime);
  return date;
}
