/*
 * ==============================================================================
 * [AppScaffold] - Khung Trang Chuẩn Toàn Bộ Ứng Dụng
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget Scaffold nền tảng:
 *   1. Tự động un-focus bàn phím khi bấm ra ngoài khoảng trống (`autoUnFocus = true`).
 *   2. Tự động bao bọc `SafeArea` linh hoạt cho top và bottom.
 *   3. Đồng bộ màu nền `scaffoldBackgroundColor` theo Light/Dark Theme.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Base scaffold with auto keyboard dismissal and safe area management.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../extensions/context_ext.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final bool autoUnFocus;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.autoUnFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      child: body,
    );

    if (autoUnFocus) {
      content = GestureDetector(
        onTap: () => context.unFocusKeyboard(),
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
