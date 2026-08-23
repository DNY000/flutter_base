/*
 * ==============================================================================
 * [AppSnackBar] - Thông Báo Nổi (Toast / SnackBar Helpers)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Hiển thị SnackBar nổi (Floating) phân loại màu sắc: Success (Xanh lá),
 *   Error (Đỏ), Warning (Cam), Info (Xanh dương).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Floating snackbar/toast helpers categorized by success, error, warning, and info.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    Color bg;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        bg = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        bg = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        bg = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackBarType.info:
        bg = AppColors.info;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: action,
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.error);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.warning);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: SnackBarType.info);
}
