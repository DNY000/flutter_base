/*
 * ==============================================================================
 * [AppButton] - Bộ Nút Bấm Đa Dạng Phong Cách (Design System Button Suite)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Cung cấp đầy đủ các biến thể nút bấm:
 *   1. **Primary**: Nút chính nổi bật (màu chủ đạo).
 *   2. **Secondary**: Nút phụ màu tối/sáng nhẹ.
 *   3. **Outline**: Nút viền trong suốt.
 *   4. **Ghost / Text**: Nút dạng chữ không viền không nền.
 *   5. **Danger / Destructive**: Nút cảnh báo/xóa dữ liệu (màu đỏ).
 *   6. **Tonal / Soft**: Nút nền nhạt chữ đậm hiện đại (Material 3 style).
 *   7. **Gradient**: Nút dải màu chuyển sắc cao cấp.
 * - Hỗ trợ 3 kích cỡ: `Small` (36h), `Medium` (48h), `Large` (56h).
 * - Tự động quản lý Loading State, Disabled State, Icon Prefix/Suffix, Bo góc tròn Pill.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Multi-variant enterprise button suite (Primary, Secondary, Outline, Ghost, Danger, Tonal, Gradient).
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../states/app_loading_indicator.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger, tonal, gradient }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final bool isPill;
  final Widget? iconPrefix;
  final Widget? iconSuffix;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Gradient? gradient;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.gradient,
  });

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppButtonVariant.secondary,
        gradient = null;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppButtonVariant.outline,
        gradient = null;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppButtonVariant.ghost,
        gradient = null;

  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppButtonVariant.danger,
        gradient = null;

  const AppButton.tonal({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppButtonVariant.tonal,
        gradient = null;

  const AppButton.gradient({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.isPill = false,
    this.iconPrefix,
    this.iconSuffix,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.textColor = Colors.white,
  })  : variant = AppButtonVariant.gradient,
        backgroundColor = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDisabled = isDisabled || isLoading || onPressed == null;

    // Chiều cao & typography theo Size
    double buttonHeight;
    TextStyle textStyle;
    double iconPadding;

    switch (size) {
      case AppButtonSize.small:
        buttonHeight = 36.h;
        textStyle = AppTypography.caption.copyWith(fontWeight: FontWeight.w600);
        iconPadding = 6.w;
        break;
      case AppButtonSize.large:
        buttonHeight = 56.h;
        textStyle = AppTypography.button.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold);
        iconPadding = 10.w;
        break;
      case AppButtonSize.medium:
        buttonHeight = 48.h;
        textStyle = AppTypography.button;
        iconPadding = 8.w;
        break;
    }

    final effectiveHeight = height ?? buttonHeight;
    final effectiveRadius = borderRadius ??
        (isPill
            ? BorderRadius.circular(999.r)
            : BorderRadius.circular(AppDimensions.radius8.r));

    Color bg = Colors.transparent;
    Color fg = Colors.white;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? Colors.white;
        break;
      case AppButtonVariant.secondary:
        bg = backgroundColor ?? (isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9));
        fg = textColor ?? (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B));
        break;
      case AppButtonVariant.outline:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? AppColors.primary;
        border = BorderSide(color: fg, width: 1.5);
        break;
      case AppButtonVariant.ghost:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? AppColors.primary;
        break;
      case AppButtonVariant.danger:
        bg = backgroundColor ?? AppColors.error;
        fg = textColor ?? Colors.white;
        break;
      case AppButtonVariant.tonal:
        bg = backgroundColor ?? AppColors.primary.withValues(alpha: 0.12);
        fg = textColor ?? AppColors.primary;
        break;
      case AppButtonVariant.gradient:
        fg = textColor ?? Colors.white;
        break;
    }

    if (effectiveDisabled) {
      if (variant != AppButtonVariant.ghost && variant != AppButtonVariant.outline) {
        bg = bg.withValues(alpha: 0.5);
      }
      fg = fg.withValues(alpha: 0.5);
    }

    Widget content = Center(
      child: isLoading
          ? AppLoadingIndicator(size: (buttonHeight * 0.45).w, color: fg)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPrefix != null) ...[
                  iconPrefix!,
                  SizedBox(width: iconPadding),
                ],
                Text(
                  text,
                  style: textStyle.copyWith(color: fg),
                ),
                if (iconSuffix != null) ...[
                  SizedBox(width: iconPadding),
                  iconSuffix!,
                ],
              ],
            ),
    );

    Widget buttonBody = Material(
      color: variant == AppButtonVariant.gradient ? Colors.transparent : bg,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveRadius,
        side: border,
      ),
      child: InkWell(
        borderRadius: effectiveRadius,
        onTap: effectiveDisabled ? null : onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: content,
        ),
      ),
    );

    if (variant == AppButtonVariant.gradient && !effectiveDisabled) {
      buttonBody = DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: effectiveRadius,
        ),
        child: buttonBody,
      );
    }

    return SizedBox(
      width: isFullWidth ? (width ?? double.infinity) : width,
      height: effectiveHeight,
      child: buttonBody,
    );
  }
}
