/*
 * ==============================================================================
 * [AppLoadingIndicator] - Vòng Xoay Đang Tải (Spinner)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget xoay tròn thể hiện trạng thái đang tải, tùy chỉnh kích thước, độ dày và màu sắc.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized circular loading spinner.
 * ==============================================================================
 */

import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
