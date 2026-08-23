/*
 * ==============================================================================
 * [AppTooltip] - Bong Bóng Chú Thích Cao Cấp (SuperTooltip)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `super_tooltip`
 * - Chức năng:
 *   1. Hiển thị Tooltip dạng bong bóng đàm thoại kèm mũi tên (Arrow / Tail) chỉ đúng mục tiêu.
 *   2. Hỗ trợ hiển thị chuỗi text đơn giản (`message`) hoặc bất kỳ Widget tùy chỉnh (`content`).
 *   3. Chạm nhẹ (Tap) là mở ngay, không cần nhấn giữ lâu.
 *   4. Hỗ trợ làm mờ nền (Backdrop Scrim) và điều khiển lập trình qua `SuperTooltipController`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Rich tooltip bubble with customizable arrow, backdrop, and widget content powered by super_tooltip.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AppTooltip extends StatefulWidget {
  final Widget child;
  final String? message;
  final Widget? content;
  final TooltipDirection popupDirection;
  final SuperTooltipController? controller;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? arrowLength;
  final double? arrowBaseWidth;
  final bool hasShadow;
  final bool showDropBoxFilter;
  final VoidCallback? onDismiss;
  final bool enableTapToShow;

  const AppTooltip({
    super.key,
    required this.child,
    this.message,
    this.content,
    this.popupDirection = TooltipDirection.up,
    this.controller,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.arrowLength,
    this.arrowBaseWidth,
    this.hasShadow = true,
    this.showDropBoxFilter = false,
    this.onDismiss,
    this.enableTapToShow = true,
  }) : assert(message != null || content != null, 'Phải cung cấp message hoặc content cho AppTooltip');

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  late final SuperTooltipController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = SuperTooltipController();
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ?? (isDark ? AppColors.surfaceDark : const Color(0xFF1E293B));
    final txtColor = widget.textColor ?? Colors.white;

    final tooltipContent = widget.content ??
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            widget.message ?? '',
            style: AppTypography.caption.copyWith(
              color: txtColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

    final tooltipWidget = SuperTooltip(
      controller: _controller,
      popupDirection: widget.popupDirection,
      backgroundColor: bg,
      borderRadius: widget.borderRadius ?? 8.r,
      arrowLength: widget.arrowLength ?? 10.h,
      arrowBaseWidth: widget.arrowBaseWidth ?? 14.w,
      hasShadow: widget.hasShadow,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shadowBlurRadius: 10,
      showDropBoxFilter: widget.showDropBoxFilter,
      content: Material(
        color: Colors.transparent,
        child: tooltipContent,
      ),
      child: widget.child,
    );

    if (widget.enableTapToShow) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (_controller.isVisible) {
            await _controller.hideTooltip();
          } else {
            await _controller.showTooltip();
          }
        },
        child: tooltipWidget,
      );
    }

    return tooltipWidget;
  }
}
