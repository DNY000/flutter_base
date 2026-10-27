import 'package:base_project/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_helper.dart';

void main() {
  group('Base Project Smoke Tests', () {
    testWidgets('Khung ứng dụng và hệ thống typography render chuẩn xác',
        (tester) async {
      await tester.pumpApp(
        const Center(
          child: AppText.h1('Base Project Enterprise'),
        ),
      );

      expect(find.text('Base Project Enterprise'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
