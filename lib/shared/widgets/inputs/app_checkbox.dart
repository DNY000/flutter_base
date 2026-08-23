/*
 * ==============================================================================
 * [AppCheckbox] - Hộp Chọn Kiểm Tra (Checkbox) Chuẩn Hoá
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Checkbox tích hợp nhãn mô tả `label`, hỗ trợ click cả dòng chữ để toggle.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Custom checkbox widget with full-row click support and label.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final checkbox = Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    if (label == null) return checkbox;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: 8),
            Flexible(child: Text(label!, style: AppTypography.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
