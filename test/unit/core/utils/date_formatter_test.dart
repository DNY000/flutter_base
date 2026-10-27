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

    test('toIsoDateString trả về ISO 8601 string hoặc chuỗi rỗng khi null', () {
      expect(DateFormatter.toIsoDateString(testDateTime),
          testDateTime.toIso8601String());
      expect(DateFormatter.toIsoDateString(null), '');
    });

    test('parseIsoString parse chuỗi ISO an toàn, trả về null khi không hợp lệ',
        () {
      expect(
          DateFormatter.parseIsoString('2026-08-22T14:30:00.000'), isNotNull);
      expect(DateFormatter.parseIsoString(''), isNull);
      expect(DateFormatter.parseIsoString(null), isNull);
      expect(DateFormatter.parseIsoString('invalid-date-string'), isNull);
    });
  });
}
