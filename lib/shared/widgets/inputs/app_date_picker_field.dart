/*
 * ==============================================================================
 * [AppDatePickerField] - Ô Chọn Ngày Tháng Chuẩn Thiết Kế
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Ô chọn ngày tháng với DatePicker chuẩn Material 3, tự động định dạng `dd/MM/yyyy`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Form field triggering standard date picker with auto-formatted display.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../../extensions/date_ext.dart';

class AppDatePickerField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;

  const AppDatePickerField({
    super.key,
    this.labelText,
    this.hintText,
    required this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.validator,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );

    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: validator,
      builder: (state) {
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (labelText != null) ...[
              Text(
                labelText!,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimensions.space4.h),
            ],
            InkWell(
              onTap: () => unawaited(_pickDate(context)),
              borderRadius: BorderRadius.circular(AppDimensions.radius8.r),
              child: Container(
                height: AppDimensions.inputHeight.h,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16.w,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor ??
                      Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radius8.r),
                  border: Border.all(
                    color: hasError
                        ? AppColors.error
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: AppDimensions.space12.w),
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? selectedDate!.toDateString()
                            : (hintText ?? 'Chọn ngày (dd/mm/yyyy)'),
                        style: AppTypography.bodyMedium.copyWith(
                          color: selectedDate != null
                              ? null
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasError) ...[
              SizedBox(height: 4.h),
              Text(
                state.errorText ?? '',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
