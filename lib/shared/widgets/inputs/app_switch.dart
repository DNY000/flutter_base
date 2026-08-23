/*
 * ==============================================================================
 * [AppSwitch] - Công Tắc Chuyển Đổi Bật/Tắt Chuẩn Design System
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Switch toggle tích hợp nhãn `label`, chú thích `subtitle`, 
 *   hỗ trợ hiệu ứng mượt mà và style đồng nhất hệ màu.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Custom switch toggle with optional label and subtitle.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? subtitle;
  final Color? activeColor;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? AppColors.primary,
    );

    if (label == null) return switchWidget;

    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label!, style: AppTypography.bodyMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.caption,
                    ),
                  ],
                ],
              ),
            ),
            switchWidget,
          ],
        ),
      ),
    );
  }
}
