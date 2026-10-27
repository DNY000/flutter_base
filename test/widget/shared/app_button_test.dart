/*
 * ==============================================================================
 * [AppButton Widget Test] - Kiểm Thử Render & Tương Tác Của Nút Bấm
 * ==============================================================================
 */

import 'package:base_project/shared/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helper.dart';

void main() {
  group('AppButton Widget Test', () {
    testWidgets('hiển thị đúng text và kích hoạt sự kiện onTap khi bấm',
        (tester) async {
      bool wasPressed = false;

      await tester.pumpApp(
        AppButton(
          text: 'Xác nhận',
          onPressed: () => wasPressed = true,
        ),
      );

      // Tìm thấy text
      expect(find.text('Xác nhận'), findsOneWidget);

      // Chạm vào nút
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('hiển thị spinner và không trigger tap khi isLoading = true',
        (tester) async {
      bool wasPressed = false;

      await tester.pumpApp(
        AppButton(
          text: 'Đăng nhập',
          isLoading: true,
          onPressed: () => wasPressed = true,
        ),
      );

      // Tìm thấy spinner loading
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      expect(find.text('Đăng nhập'), findsNothing);

      // Chạm vào nút đang loading
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('không kích hoạt sự kiện khi isDisabled = true',
        (tester) async {
      bool wasPressed = false;

      await tester.pumpApp(
        AppButton(
          text: 'Tiếp tục',
          isDisabled: true,
          onPressed: () => wasPressed = true,
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });
  });
}
