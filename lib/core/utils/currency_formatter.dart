/*
 * ==============================================================================
 * [CurrencyFormatter] - Tiện Ích Định Dạng Tiền Tệ & Con Số Chuẩn Quốc Tế
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Định dạng tiền tệ VND, USD, EUR... theo Locale và chuẩn ngân hàng.
 * - Hỗ trợ rút gọn số lớn (1.2K, 3.5M, 10B).
 * - Chuyển đổi chuỗi thành số thực an toàn (Safe Parser).
 * 
 * 🇬🇧 ENGLISH:
 * - Unified currency formatting, large number compacting, and safe parsing.
 * ==============================================================================
 */

import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Định dạng tiền Việt Nam Đồng (VND), ví dụ: `150.000 ₫` hoặc `150,000 VND`
  static String formatVND(
    num amount, {
    String symbol = '₫',
    bool showSymbol = true,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: showSymbol ? symbol : '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }

  /// Định dạng tiền Đô la Mỹ (USD), ví dụ: `$1,250.50`
  static String formatUSD(num amount, {int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Định dạng tiền tệ linh hoạt theo mã ISO và Locale
  static String formatCurrency(
    num amount, {
    String currencyCode = 'VND',
    String? locale,
    int? decimalDigits,
  }) {
    final formatter = NumberFormat.simpleCurrency(
      name: currencyCode,
      locale: locale ?? (currencyCode == 'VND' ? 'vi_VN' : 'en_US'),
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Rút gọn số lượng lớn (VD: 1500 -> "1.5K", 2500000 -> "2.5M")
  static String formatCompact(num number, {String locale = 'en_US'}) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(number);
  }

  /// Chuyển đổi chuỗi tiền tệ nhập từ bàn phím về dạng `double` an toàn
  static double parseToDouble(String text) {
    if (text.isEmpty) return 0.0;
    // Loại bỏ mọi ký tự không phải số hoặc dấu chấm/phẩy
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
