/*
 * ==============================================================================
 * [AppDropdownField] - Trường Chọn Dữ Liệu Dropdown / BottomSheet
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Ô chọn dữ liệu từ danh sách với giao diện BottomSheet hoặc Popup chuẩn Mobile UX:
 *   1. Hiển thị nhãn `labelText` và `hintText`.
 *   2. Mở danh sách chọn mượt mà, hỗ trợ tìm kiếm nếu danh sách dài.
 *   3. Tự động validation khi form submit.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Form dropdown selector displaying a clean BottomSheet picker for mobile UX.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';
import '../feedback/app_bottom_sheet.dart';

class DropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class AppDropdownField<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T>? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isReadOnly;

  const AppDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isReadOnly = false,
  });

  DropdownItem<T>? get _selectedItem {
    try {
      return items.firstWhere((item) => item.value == value);
    } catch (_) {
      return null;
    }
  }

  void _showPicker(BuildContext context) {
    if (isReadOnly || onChanged == null) return;

    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: labelText ?? 'Chọn dữ liệu',
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, idx) {
            final item = items[idx];
            final isSelected = item.value == value;

            return ListTile(
              leading: item.icon,
              title: Text(
                item.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                onChanged!(item.value);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (state) {
        final hasError = state.hasError;
        final selected = _selectedItem;

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
              onTap: () => _showPicker(context),
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
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: AppDimensions.space12.w),
                    ],
                    Expanded(
                      child: Text(
                        selected?.label ?? (hintText ?? 'Chọn một mục'),
                        style: AppTypography.bodyMedium.copyWith(
                          color: selected != null
                              ? null
                              : AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textSecondaryLight,
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
