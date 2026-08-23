/*
 * ==============================================================================
 * [AppValidators Test] - Kiểm Thử Tính Hợp Lệ Của Form Validators
 * ==============================================================================
 */

import 'package:base_project/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators - Email Validation', () {
    test('trả về null khi email hợp lệ', () {
      expect(AppValidators.email('admin@example.com'), isNull);
      expect(AppValidators.email('user.test+tag@domain.co'), isNull);
    });

    test('trả về thông báo lỗi khi email trống', () {
      expect(AppValidators.email(''), isNotNull);
      expect(AppValidators.email(null), isNotNull);
    });

    test('trả về thông báo lỗi khi email sai định dạng', () {
      expect(AppValidators.email('invalid-email'), isNotNull);
      expect(AppValidators.email('user@'), isNotNull);
      expect(AppValidators.email('@domain.com'), isNotNull);
    });
  });

  group('AppValidators - Password Validation', () {
    test('trả về null khi mật khẩu đủ 6 ký tự trở lên', () {
      expect(AppValidators.password('123456'), isNull);
      expect(AppValidators.password('securePassword@123'), isNull);
    });

    test('trả về lỗi khi mật khẩu rỗng hoặc dưới 6 ký tự', () {
      expect(AppValidators.password(''), isNotNull);
      expect(AppValidators.password('12345'), isNotNull);
      expect(AppValidators.password(null), isNotNull);
    });
  });

  group('AppValidators - Phone Validation', () {
    test('trả về null khi số điện thoại Việt Nam hợp lệ', () {
      expect(AppValidators.phone('0987654321'), isNull);
      expect(AppValidators.phone('+84987654321'), isNull);
    });

    test('trả về lỗi khi số điện thoại không hợp lệ', () {
      expect(AppValidators.phone('12345'), isNotNull);
      expect(AppValidators.phone('abcdefghij'), isNotNull);
    });
  });
}
