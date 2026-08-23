/*
 * ==============================================================================
 * [AppAppBar] - Thanh Tiêu Đề Ứng Dụng Chuẩn (App Bar)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: AppBar tùy biến có nút quay lại (Back button) mặc định, tiêu đề căn giữa, 
 *   và các nút hành động (`actions`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized custom app bar with back navigation and action buttons.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;

  const AppAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(title, style: AppTypography.heading3),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
