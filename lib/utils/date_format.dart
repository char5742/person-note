import 'package:intl/intl.dart';

String formatDate(DateTime? datetime, {String delimiter = '-'}) {
  if (datetime == null) {
    return '00${delimiter}00';
  }
  final outputFormat = DateFormat('MMMMd');
  final date = outputFormat.format(datetime);
  return date;
}

String formatDateTime(DateTime? datetime, {String delimiter = '-'}) {
  if (datetime == null) {
    return '0000${delimiter}00${delimiter}00 ( )';
  }
  final outputFormat = DateFormat('yyyy${delimiter}MM${delimiter}dd (EEE)');
  final date = outputFormat.format(datetime);
  return date;
}
