/*
 * ==============================================================================
 * [DateFormatter Test] - Kiểm Thử Định Dạng Ngày Giờ
 * ==============================================================================
 */

import 'package:base_project/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testDateTime = DateTime(2026, 8, 22, 14, 30);

  group('DateFormatter', () {
    test('toDisplayDate định dạng chính xác dd/MM/yyyy', () {
      final result = DateFormatter.toDisplayDate(testDateTime);
      expect(result, '22/08/2026');
    });

    test('toDisplayDateTime định dạng chính xác dd/MM/yyyy HH:mm', () {
      final result = DateFormatter.toDisplayDateTime(testDateTime);
      expect(result, '22/08/2026 14:30');
    });

    test('toTimeOnly định dạng chính xác HH:mm', () {
      final result = DateFormatter.toTimeOnly(testDateTime);
      expect(result, '14:30');
    });

    test('trả về chuỗi rỗng khi dateTime là null', () {
      expect(DateFormatter.toDisplayDate(null), '');
      expect(DateFormatter.toDisplayDateTime(null), '');
      expect(DateFormatter.toTimeOnly(null), '');
    });
  });
}
