/*
 * ==============================================================================
 * [AppAccordion] - Thẻ Mở Rộng / Thu Gọn (Accordion / Expandable Panel)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Thẻ chứa nội dung có thể mở ra hoặc gấp lại (dùng cho câu hỏi thường gặp FAQ, 
 *   chi tiết đơn hàng, cài đặt nâng cao) với icon xoay mượt mà.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Expandable / collapsible accordion card with smooth rotation animations.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppAccordion extends StatefulWidget {
  final String title;
  final Widget? leading;
  final Widget content;
  final bool initiallyExpanded;
  final Color? backgroundColor;

  const AppAccordion({
    super.key,
    required this.title,
    this.leading,
    required this.content,
    this.initiallyExpanded = false,
    this.backgroundColor,
  });

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppDimensions.radius12.r),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          leading: widget.leading,
          title: Text(
            widget.title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          onExpansionChanged: (val) => setState(() => _isExpanded = val),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondaryLight,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.space16.w,
                0,
                AppDimensions.space16.w,
                AppDimensions.space16.h,
              ),
              child: widget.content,
            ),
          ],
        ),
      ),
    );
  }
}
