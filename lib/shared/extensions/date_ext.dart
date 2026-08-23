import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String toDateString({String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(this);
  }

  String toDateTimeString({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(this);
  }

  String toTimeString({String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension NumberExt on num {
  String toCurrency({String symbol = '₫', String locale = 'vi_VN'}) {
    final format = NumberFormat.currency(locale: locale, symbol: symbol);
    return format.format(this);
  }

  String toFormattedNumber() {
    return NumberFormat('#,###').format(this);
  }
}
