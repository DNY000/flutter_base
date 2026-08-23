/*
 * ==============================================================================
 * [AppColors] - Bảng màu & Color Tokens của ứng dụng
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Quản lý tập trung toàn bộ mã màu trong dự án (Design System Tokens).
 * - Quy tắc phân loại:
 *   1. **Brand Colors**: Màu nhận diện thương hiệu (`primary`, `secondary`, `accent`).
 *   2. **Semantic Colors**: Màu phản ánh trạng thái (`success`, `warning`, `error`, `info`).
 *   3. **Neutral Colors**: Màu nền, chữ, viền hỗ trợ cả Light Mode và Dark Mode.
 * - Cách dùng: `AppColors.primary`, hoặc truy cập ngữ cảnh qua `Theme.of(context).colorScheme.primary`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Centralized design system color palette and tokens.
 * - Usage: Use `AppColors.<color>` or `Theme.of(context).colorScheme.<color>`.
 * ==============================================================================
 */

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand / Primary Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF80CBC4);

  // Semantic Colors (Trạng thái)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF00ACC1);

  // Light Neutral Colors (Chế độ Sáng)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color dividerLight = Color(0xFFEEEEEE);

  // Dark Neutral Colors (Chế độ Tối)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color borderDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF272727);

  // Common Constants
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
