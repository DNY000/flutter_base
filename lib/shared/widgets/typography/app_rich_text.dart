/*
 * ==============================================================================
 * [AppRichText] - Widget Văn Bản Phức Hợp (Đổi Màu & Nhấn Click Từng Đoạn)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Giúp tạo các đoạn văn bản có từ ngữ nổi bật, đổi màu hoặc bấm được
 *   (ví dụ: "Bằng cách đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật").
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Helper for structured rich text with clickable or highlighted spans.
 * ==============================================================================
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_typography.dart';

class AppTextSpanItem {
  final String text;
  final TextStyle? style;
  final VoidCallback? onTap;

  const AppTextSpanItem({
    required this.text,
    this.style,
    this.onTap,
  });
}

class AppRichText extends StatelessWidget {
  final List<AppTextSpanItem> spans;
  final TextStyle? defaultStyle;
  final TextAlign textAlign;
  final int? maxLines;

  const AppRichText({
    super.key,
    required this.spans,
    this.defaultStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBaseStyle = defaultStyle ?? AppTypography.bodyMedium;

    return Text.rich(
      TextSpan(
        style: effectiveBaseStyle,
        children: spans.map((item) {
          return TextSpan(
            text: item.text,
            style: item.style,
            recognizer: item.onTap != null
                ? (TapGestureRecognizer()..onTap = item.onTap)
                : null,
          );
        }).toList(),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
