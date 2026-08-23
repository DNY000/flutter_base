/*
 * ==============================================================================
 * [AppErrorView] - Màn Hình Thông Báo Lỗi Kèm Nút Thử Lại (Retry)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Hiển thị thông báo lỗi thân thiện kèm nút Retry để tải lại dữ liệu khi API thất bại hoặc mất mạng.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Error state view with retry action button.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../buttons/app_button.dart';

class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final Widget? icon;

  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = 'Thử lại',
    this.icon,
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
                  Icons.error_outline_rounded,
                  size: 64.w,
                  color: AppColors.error,
                ),
            SizedBox(height: AppDimensions.space16.h),
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppDimensions.space24.h),
              AppButton(
                text: retryText,
                onPressed: onRetry,
                width: 140.w,
                iconPrefix: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
