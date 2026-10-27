/*
 * ==============================================================================
 * [CrashMonitoringService Test] - Kiểm Thử Dịch Vụ Giám Sát Crashlytics
 * ==============================================================================
 */

import 'package:base_project/core/services/crash_monitoring_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CrashMonitoringServiceImpl crashService;

  setUp(() {
    crashService = CrashMonitoringServiceImpl(isEnabled: false);
    crashService.initialize();
  });

  group('CrashMonitoringService', () {
    test('ghi nhận lỗi non-fatal và breadcrumbs chính xác', () async {
      await crashService.logBreadcrumb('Bấm nút thanh toán',
          category: 'USER_FLOW');
      await crashService.setUserIdentifier('user_999');
      await crashService.setCustomKey('app_flavor', 'staging');

      await crashService.recordError(
        Exception('Network Timeout'),
        StackTrace.current,
        reason: 'Payment Timeout',
        fatal: false,
      );

      expect(crashService.recentBreadcrumbs.length, 1);
      expect(
          crashService.recentBreadcrumbs.first.contains('USER_FLOW'), isTrue);
    });
  });
}
