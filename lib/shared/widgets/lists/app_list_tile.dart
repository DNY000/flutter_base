/*
 * ==============================================================================
 * [AppListTile] - Hàng Danh Sách Chuẩn Hoá
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget hàng danh sách gồm icon/avatar đầu (`leading`), tiêu đề (`title`), 
 *   phụ đề (`subtitle`), nút/icon cuối (`trailing`), tự động bo góc và hiệu ứng chạm.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized list tile widget with leading, title, subtitle, and trailing elements.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool showDivider;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing = const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: leading,
      title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTypography.caption) : null,
      trailing: trailing,
      onTap: onTap,
      tileColor: backgroundColor,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: AppDimensions.space16.w,
            vertical: AppDimensions.space4.h,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius8.r),
      ),
    );

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tile,
          const Divider(indent: 16, endIndent: 16),
        ],
      );
    }

    return tile;
  }
}
