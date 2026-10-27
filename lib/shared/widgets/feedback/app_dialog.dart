/*
 * ==============================================================================
 * [AppDialog] - Hộp Thoại Xác Nhận & Loading Toàn Cục
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Cung cấp các hàm tiện ích hiển thị Dialog:
 *   1. `confirm`: Dialog xác nhận thao tác (Xác nhận / Hủy), hỗ trợ cảnh báo màu đỏ (`isDestructive`).
 *   2. `showLoading` & `hideLoading`: Dialog chặn màn hình khi đang thực thi tác vụ nền.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardized dialogs for user confirmation and loading states.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../buttons/app_button.dart';

class AppDialog {
  AppDialog._();

  /// Hiển thị Dialog xác nhận thao tác
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy bỏ',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16.r),
        ),
        title: Text(title, style: AppTypography.heading3),
        content: Text(message, style: AppTypography.bodyMedium),
        actionsPadding: EdgeInsets.all(AppDimensions.space16.w),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: cancelText,
                  height: 40.h,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
              ),
              SizedBox(width: AppDimensions.space12.w),
              Expanded(
                child: AppButton(
                  text: confirmText,
                  height: 40.h,
                  backgroundColor:
                      isDestructive ? AppColors.error : AppColors.primary,
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Hiển thị Dialog Loading chặn tương tác
  static void showLoading(BuildContext context,
      {String message = 'Đang xử lý...'}) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space24.w,
                vertical: AppDimensions.space20.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(width: AppDimensions.space16.w),
                  Text(message, style: AppTypography.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Ẩn Dialog Loading
  static void hideLoading(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
