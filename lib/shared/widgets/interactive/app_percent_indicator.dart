/*
 * ==============================================================================
 * [AppPercentIndicator] - Vòng Tròn & Thanh Tiến Độ Phần Trăm (Percent Indicator)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `percent_indicator`
 * - Chức năng:
 *   1. `AppCircularPercent`: Hiển thị % tiến độ dạng vòng tròn (Dung lượng, pin, hoàn thành mục tiêu).
 *   2. `AppLinearPercent`: Hiển thị % tiến độ dạng thanh ngang mượt mà có animation.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Circular and Linear animated percentage indicators powered by percent_indicator.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AppCircularPercent extends StatelessWidget {
  final double percent; // 0.0 -> 1.0
  final double radius;
  final double lineWidth;
  final Widget? center;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool animation;
  final String? label;

  const AppCircularPercent({
    super.key,
    required this.percent,
    this.radius = 48.0,
    this.lineWidth = 8.0,
    this.center,
    this.progressColor,
    this.backgroundColor,
    this.animation = true,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedPercent = percent.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: radius.r,
          lineWidth: lineWidth.w,
          percent: clampedPercent,
          animation: animation,
          animationDuration: 800,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: progressColor ?? AppColors.primary,
          backgroundColor: backgroundColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight),
          center: center ??
              Text(
                '${(clampedPercent * 100).toInt()}%',
                style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold),
              ),
        ),
        if (label != null) ...[
          SizedBox(height: 8.h),
          Text(label!, style: AppTypography.caption),
        ],
      ],
    );
  }
}

class AppLinearPercent extends StatelessWidget {
  final double percent; // 0.0 -> 1.0
  final double lineHeight;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? trailing;
  final Widget? center;
  final bool animation;

  const AppLinearPercent({
    super.key,
    required this.percent,
    this.lineHeight = 12.0,
    this.progressColor,
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.center,
    this.animation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedPercent = percent.clamp(0.0, 1.0);

    return LinearPercentIndicator(
      percent: clampedPercent,
      lineHeight: lineHeight.h,
      animation: animation,
      animationDuration: 800,
      barRadius: Radius.circular(lineHeight.r / 2),
      progressColor: progressColor ?? AppColors.primary,
      backgroundColor: backgroundColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight),
      leading: leading,
      trailing: trailing,
      center: center,
      padding: EdgeInsets.zero,
    );
  }
}
