import 'package:base_project/core/utils/currency_formatter.dart';
import 'package:base_project/core/utils/throttler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CurrencyFormatter Test', () {
    test('formatVND định dạng chuẩn tiền tệ Việt Nam', () {
      final result = CurrencyFormatter.formatVND(150000);
      expect(result.contains('150.000'), isTrue);
    });

    test('formatUSD định dạng chuẩn tiền tệ USD', () {
      final result = CurrencyFormatter.formatUSD(1250.5);
      expect(result, '\$1,250.50');
    });

    test('parseToDouble chuyển đổi chuỗi an toàn', () {
      expect(CurrencyFormatter.parseToDouble('150.000 VND'), 150.000);
      expect(CurrencyFormatter.parseToDouble(''), 0.0);
    });
  });

  group('Throttler Test', () {
    test('run chỉ thực thi 1 lần trong khoảng throttleDuration', () {
      final throttler =
          Throttler(throttleDuration: const Duration(milliseconds: 200));
      int callCount = 0;

      throttler.run(() => callCount++);
      throttler.run(() => callCount++);
      throttler.run(() => callCount++);

      expect(callCount, 1);
      throttler.dispose();
    });
  });
}
