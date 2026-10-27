/*
 * ==============================================================================
 * [AnalyticsService Test] - Kiểm Thử Dịch Vụ Phân Tích Dữ Liệu Firebase
 * ==============================================================================
 */

import 'package:base_project/core/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AnalyticsServiceImpl analyticsService;

  setUp(() {
    analyticsService = AnalyticsServiceImpl(isEnabled: false);
  });

  group('AnalyticsService', () {
    test('ghi nhận event, screen view và conversion step mà không gây lỗi',
        () async {
      await analyticsService
          .logEvent('test_event', parameters: {'key': 'value'});
      await analyticsService.logScreenView('HomeScreen');
      await analyticsService.setUserId('user_123');
      await analyticsService.setUserProperty('tier', 'vip');
      await analyticsService.logLogin(loginMethod: 'google');
      await analyticsService.logSignUp(signUpMethod: 'apple');
      await analyticsService.logConversionStep(
        funnelName: 'checkout',
        stepNumber: 1,
        stepName: 'cart_viewed',
      );

      expect(analyticsService.isEnabled, isFalse);
    });
  });
}
