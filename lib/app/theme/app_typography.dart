/*
 * ==============================================================================
 * [AppTypography] - Hệ thống Phông chữ & Kiểu chữ Typography
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Chuẩn hóa kích thước font chữ, độ đậm (font weight) và độ giãn dòng (line-height).
 * - Tự động co giãn: Tích hợp đuôi `.sp` từ `flutter_screenutil` để kích thước chữ tương thích
 *   hoàn hảo trên mọi kích cỡ màn hình thiết bị.
 * - Cách dùng: `style: AppTypography.heading2.copyWith(color: Colors.blue)`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardizes typography styles, weights, and heights.
 * - Responsive: Uses `.sp` from `flutter_screenutil` for screen-density-aware font sizing.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  /// Tiêu đề lớn nhất (H1) - Dùng cho Header chính, Splash, v.v.
  static TextStyle get heading1 => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// Tiêu đề vừa (H2) - Dùng cho AppBar lớn, tiêu đề module
  static TextStyle get heading2 => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
        height: 1.25,
      );

  /// Tiêu đề nhỏ (H3) - Dùng cho AppBar chuẩn, Card title
  static TextStyle get heading3 => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Nội dung chính (Body Large)
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  /// Nội dung thông thường (Body Medium) - Mặc định cho hầu hết văn bản
  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  /// Nội dung phụ / chú thích nhỏ (Body Small)
  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  /// Văn bản trong nút bấm (Button)
  static TextStyle get button => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  /// Nhãn mác, thời gian, chú thích phụ (Caption)
  static TextStyle get caption => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryLight,
      );
}
