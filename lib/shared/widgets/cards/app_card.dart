/*
 * ==============================================================================
 * [AppCard] - Thẻ Chứa Nội Dung Đa Năng
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Thẻ Card bọc nội dung có bo góc chuẩn, đổ bóng (elevation/shadow), viền (border),
 *   hoặc dải màu Gradient, hỗ trợ sự kiện chạm `onTap` với hiệu ứng Ripple / Splash.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Multi-purpose container card supporting elevation, borders, gradients, and tap ripple.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double elevation;
  final BorderSide? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.gradient,
    this.elevation = 0,
    this.border,
    this.onTap,
  });

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.border = const BorderSide(color: AppColors.borderLight),
    this.onTap,
  })  : elevation = 0,
        gradient = null;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppDimensions.radius12.r;
    final effectivePadding = padding ?? EdgeInsets.all(AppDimensions.space16.w);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: gradient == null
            ? (backgroundColor ??
                (isDark ? AppColors.surfaceDark : AppColors.surfaceLight))
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: border != null ? Border.fromBorderSide(border!) : null,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(effectiveRadius),
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
