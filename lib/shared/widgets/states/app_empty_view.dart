/*
 * ==============================================================================
 * [AppEmptyView] - Màn Hình Trống / Không Có Dữ Liệu
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Hiển thị minh họa, tiêu đề và nút kêu gọi hành động khi danh sách hoặc nội dung rỗng.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Empty state view with icon, title, subtitle, and action button.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../buttons/app_button.dart';

class AppEmptyView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyView({
    super.key,
    this.title = 'Không có dữ liệu',
    this.subtitle,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                Icon(
                  Icons.inbox_outlined,
                  size: 64.w,
                  color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
                ),
            SizedBox(height: AppDimensions.space16.h),
            Text(
              title,
              style: AppTypography.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppDimensions.space8.h),
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppDimensions.space24.h),
              AppButton(
                text: actionText!,
                onPressed: onAction,
                width: 160.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
