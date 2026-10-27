/*
 * ==============================================================================
 * [AppText] - Bộ Widget Hiển thị Văn Bản Chuẩn Hoá (Tích hợp AutoSizeText)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện hỗ trợ: `auto_size_text` (Tự động co giãn kích thước chống tràn viền).
 * - Chức năng: Rút ngắn cú pháp khai báo Text, tích hợp sẵn các kiểu Heading (H1, H2, H3), 
 *   Body (Large, Medium, Small), Caption, hỗ trợ `autoSize: true` chống lỗi RenderFlex overflow.
 * - Cách dùng: `AppText.h1('Tiêu đề')`, `AppText.autoSize('Giá: 1.000.000đ', maxLines: 1)`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Concise typography widget with auto-resizing text capabilities powered by auto_size_text.
 * ==============================================================================
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_typography.dart';

enum AppTextVariant {
  h1,
  h2,
  h3,
  bodyLarge,
  bodyMedium,
  bodySmall,
  button,
  caption
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final bool autoSize;
  final double minFontSize;
  final double? maxFontSize;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 10,
    this.maxFontSize,
  });

  const AppText.h1(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 14,
    this.maxFontSize,
  }) : variant = AppTextVariant.h1;

  const AppText.h2(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 12,
    this.maxFontSize,
  }) : variant = AppTextVariant.h2;

  const AppText.h3(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 11,
    this.maxFontSize,
  }) : variant = AppTextVariant.h3;

  const AppText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 10,
    this.maxFontSize,
  }) : variant = AppTextVariant.bodyLarge;

  const AppText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 10,
    this.maxFontSize,
  }) : variant = AppTextVariant.bodyMedium;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 9,
    this.maxFontSize,
  }) : variant = AppTextVariant.bodySmall;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.autoSize = false,
    this.minFontSize = 8,
    this.maxFontSize,
  }) : variant = AppTextVariant.caption;

  const AppText.autoSize(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.minFontSize = 9,
    this.maxFontSize,
  }) : autoSize = true;

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle;
    switch (variant) {
      case AppTextVariant.h1:
        baseStyle = AppTypography.heading1;
        break;
      case AppTextVariant.h2:
        baseStyle = AppTypography.heading2;
        break;
      case AppTextVariant.h3:
        baseStyle = AppTypography.heading3;
        break;
      case AppTextVariant.bodyLarge:
        baseStyle = AppTypography.bodyLarge;
        break;
      case AppTextVariant.bodyMedium:
        baseStyle = AppTypography.bodyMedium;
        break;
      case AppTextVariant.bodySmall:
        baseStyle = AppTypography.bodySmall;
        break;
      case AppTextVariant.button:
        baseStyle = AppTypography.button;
        break;
      case AppTextVariant.caption:
        baseStyle = AppTypography.caption;
        break;
    }

    final finalStyle = baseStyle.copyWith(
      color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

    if (autoSize) {
      return AutoSizeText(
        text,
        style: finalStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
        minFontSize: minFontSize,
        maxFontSize: maxFontSize ?? double.infinity,
      );
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
