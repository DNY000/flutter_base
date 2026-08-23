/*
 * ==============================================================================
 * [AppDivider] - Đường Kẻ Phân Cách Nội Dung (Divider with Spacing)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Kẻ vạch phân cách có khoảng cách lề trên/dưới và màu sắc chuẩn theo Theme.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized divider with custom vertical spacing and indentations.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const AppDivider({
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? (isDark ? AppColors.dividerDark : AppColors.dividerLight),
    );
  }
}
