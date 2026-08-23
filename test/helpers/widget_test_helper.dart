/*
 * ==============================================================================
 * [WidgetTestHelper] - Dựng Môi Trường Widget Test Tự Động (Test Harness)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Tiện ích mở rộng `WidgetTester` giúp render bất kỳ Widget nào trong môi trường hoàn chỉnh:
 *   1. Tự động bao bọc `ScreenUtilInit` (375x812) để các extension `.w`, `.h`, `.sp` hoạt động 100%.
 *   2. Tự động bao bọc `MaterialApp` kèm `AppTheme.lightTheme`.
 *   3. Hỗ trợ truyền danh sách `BlocProvider` nếu widget yêu cầu lắng nghe State Management.
 * - Cách dùng: `await tester.pumpApp(const AppButton(text: 'Click'));`
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Extension on WidgetTester providing a full test environment with ScreenUtil, MaterialApp, and Blocs.
 * ==============================================================================
 */

import 'package:base_project/app/theme/app_theme.dart';
import 'package:base_project/app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<BlocProvider>? blocProviders,
    ThemeData? theme,
    Locale? locale,
  }) async {
    Widget child = widget;

    if (blocProviders != null && blocProviders.isNotEmpty) {
      child = MultiBlocProvider(
        providers: blocProviders,
        child: child,
      );
    }

    await pumpWidget(
      ScreenUtilInit(
        designSize: const Size(
          AppConstants.designWidth,
          AppConstants.designHeight,
        ),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme ?? AppTheme.lightTheme,
          locale: locale ?? const Locale('vi'),
          home: Scaffold(body: child),
        ),
      ),
    );

    // Chờ frame đầu tiên render xong
    await pump();
  }
}
