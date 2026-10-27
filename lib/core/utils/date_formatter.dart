import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String toDisplayDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String toDisplayDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String toTimeOnly(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  static String toIsoDateString(DateTime? dateTime) {
    if (dateTime == null) return '';
    return dateTime.toIso8601String();
  }

  static DateTime? parseIsoString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    return DateTime.tryParse(dateStr);
  }
}
