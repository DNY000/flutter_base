/*
 * ==============================================================================
 * [AppIconButton] - Nút Bấm Icon kèm Huy Hiệu Badge & Tooltip
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Nút bấm Icon có hiệu ứng chạm mượt, hỗ trợ hiển thị số lượng thông báo (Badge count),
 *   màu sắc nền (Filled/Outlined/Transparent) và tooltip giải thích.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized icon button supporting badge count, tooltip, and multiple visual styles.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final int? badgeCount;
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderSide? border;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.badgeCount,
    this.size,
    this.backgroundColor,
    this.iconColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 40.w;

    Widget button = InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
      onTap: onPressed,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
          border: border != null ? Border.fromBorderSide(border!) : null,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              color: iconColor ?? Theme.of(context).iconTheme.color,
              size: 20.w,
            ),
            child: icon,
          ),
        ),
      ),
    );

    if (badgeCount != null && badgeCount! > 0) {
      button = Badge(
        label: Text(
          badgeCount! > 99 ? '99+' : badgeCount.toString(),
          style: TextStyle(fontSize: 10.sp, color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        child: button,
      );
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
