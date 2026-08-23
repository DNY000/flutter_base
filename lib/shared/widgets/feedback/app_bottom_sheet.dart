/*
 * ==============================================================================
 * [AppBottomSheet] - Tấm Trượt Dưới Đáy Chuẩn Thiết Kế (Modal Bottom Sheet)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Hiển thị BottomSheet bo góc phía trên, có thanh kéo cử chỉ (Drag Indicator),
 *   tự động xử lý bàn phím đẩy lên (`viewInsets.bottom`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Modal bottom sheet wrapper with rounded top borders and drag handle.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius16.r),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppDimensions.space8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              if (title != null) ...[
                Padding(
                  padding: EdgeInsets.all(AppDimensions.space16.w),
                  child: Text(
                    title,
                    style: AppTypography.heading3,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
              ],
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}
