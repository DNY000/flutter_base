/*
 * ==============================================================================
 * [AppSegmentedControl] - Thanh Chuyển Tab Dạng Viên Thuốc (Pill Tabs / Segmented)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Bộ chuyển đổi Tab dạng viên thuốc bo tròn (Segmented Control) có hoạt ảnh
 *   trượt mượt mà (Animated Slide Indicator).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Modern animated segmented control / sliding pill tabs.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppSegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onSegmentSelected;
  final Color? activeColor;
  final Color? backgroundColor;
  final double? height;

  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onSegmentSelected,
    this.activeColor,
    this.backgroundColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 40.h;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: effectiveHeight,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? const Color(0xFF252525) : const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(AppDimensions.radius24.r),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSegmentSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (activeColor ??
                          (isDark ? AppColors.surfaceDark : Colors.white))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radius24.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    segments[index],
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
