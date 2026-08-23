/*
 * ==============================================================================
 * [AppRadioGroup] - Nhóm Chọn Đơn Một Lựa Chọn (Radio Group)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Bộ nút chọn một mục duy nhất trong danh sách lựa chọn kèm tiêu đề và mô tả.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Radio button list group for single-choice selections.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class RadioOption<T> {
  final T value;
  final String title;
  final String? subtitle;

  const RadioOption({
    required this.value,
    required this.title,
    this.subtitle,
  });
}

class AppRadioGroup<T> extends StatelessWidget {
  final List<RadioOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final Color? activeColor;

  const AppRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isSelected = opt.value == selectedValue;

        return RadioListTile<T>(
          value: opt.value,
          groupValue: selectedValue,
          activeColor: activeColor ?? AppColors.primary,
          title: Text(
            opt.title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: opt.subtitle != null
              ? Text(opt.subtitle!, style: AppTypography.caption)
              : null,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        );
      }).toList(),
    );
  }
}
