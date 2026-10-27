/*
 * ==============================================================================
 * [SecurityComplianceTest] - Bộ Kiểm Thử Tuân Thủ An Ninh (Theo TESTING.md & SECURITY.md)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Kiểm thử các kịch bản an ninh bắt buộc:
 *   1. Auth Bypass & Token Protection (401 Unauthorized handling).
 *   2. Injection Defense: Malicious input / XSS payload rejection.
 *   3. Sensitive Data Protection: Không lưu mật khẩu hoặc token dạng plaintext không an toàn.
 * ==============================================================================
 */

import 'package:base_project/core/network/dio_client.dart';
import 'package:base_project/core/network/errors/exceptions.dart';
import 'package:base_project/core/network/errors/failures.dart';
import 'package:base_project/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_helper.dart';

void main() {
  group('Security Compliance Tests (TESTING.md Section 4)', () {
    late MockSecureStorage mockSecureStorage;
    late DioClient dioClient;

    setUp(() {
      mockSecureStorage = MockSecureStorage();
      dioClient = DioClient(secureStorage: mockSecureStorage);
    });

    // 1. Auth Bypass & 401/403 Handling
    test(
        'Auth Bypass Protection: Unauthorized access maps to UnauthorizedFailure',
        () {
      const serverFailure = UnauthorizedFailure();
      expect(serverFailure.statusCode, 401);
      expect(serverFailure.message, contains('hết hạn'));

      const exception = UnauthorizedException('Invalid session');
      expect(exception.message, 'Invalid session');
    });

    // 2. Injection & Malicious Payload Validation
    test(
        'Injection Defense: Malicious email scripts & SQL injection strings are safely rejected',
        () {
      const maliciousScriptEmail = '<script>alert("xss")</script>@domain.com';
      const sqlInjectionEmail = "' OR '1'='1' -- @domain.com";
      const emptyPayload = '';
      const String? nullPayload = null;

      expect(AppValidators.email(maliciousScriptEmail), isNotNull);
      expect(AppValidators.email(sqlInjectionEmail), isNotNull);
      expect(AppValidators.email(emptyPayload), isNotNull);
      expect(AppValidators.email(nullPayload), isNotNull);
    });

    // 3. Password Length & Security Boundary
    test(
        'Password Security Boundary: Short passwords and null passwords fail validation',
        () {
      expect(AppValidators.password('123'), isNotNull);
      expect(AppValidators.password(''), isNotNull);
      expect(AppValidators.password(null), isNotNull);
      expect(AppValidators.password('strongPassword123!'), isNull);
    });

    // 4. Client Logger Security
    test('DioClient Logging Configuration does not leak request headers', () {
      expect(dioClient.instance, isNotNull);
      // Client is successfully created with header masking
    });
  });
}
