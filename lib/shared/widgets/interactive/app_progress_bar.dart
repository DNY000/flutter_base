/*
 * ==============================================================================
 * [AppProgressBar] - Thanh Tiến Độ Tuyến Tính & Tròn (Progress Bars)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Hiển thị thanh tiến độ phần trăm (0.0 -> 1.0) dạng đường thẳng hoặc hình tròn,
 *   tự động bo góc và có nhãn hiển thị `%` đi kèm.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Linear and circular progress bars with percentage labels and rounded caps.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_typography.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showLabel;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.progressColor,
    this.backgroundColor,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentText = '${(clampedProgress * 100).toInt()}%';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showLabel) ...[
          Text(percentText, style: AppTypography.caption),
          SizedBox(height: 4.h),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clampedProgress,
            minHeight: height.h,
            backgroundColor: backgroundColor ??
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
