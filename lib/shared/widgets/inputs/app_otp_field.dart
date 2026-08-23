/*
 * ==============================================================================
 * [AppOtpField] - Ô Nhập Mã OTP / PIN Code Chuyên Nghiệp (PinCodeFields)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `pin_code_fields`
 * - Chức năng:
 *   1. Bộ ô nhập mã OTP (4 hoặc 6 ký tự) dạng từng ô vuông bo góc riêng biệt.
 *   2. Hỗ trợ tự động dán mã (Auto Paste) từ clipboard / SMS Autofill.
 *   3. Hiệu ứng chuyển động (AnimationType.fade / scale), con trỏ nhấp nháy, kiểm soát trạng thái hoàn thành.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: PIN/OTP code input field with clipboard paste, auto-advance, and smooth box animations powered by pin_code_fields.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppOtpField extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final TextEditingController? controller;
  final double cellSize;
  final bool isPassword;
  final bool autoFocus;
  final PinCodeFieldShape shape;

  const AppOtpField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.cellSize = 48.0,
    this.isPassword = false,
    this.autoFocus = false,
    this.shape = PinCodeFieldShape.box,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widgetSize(context);

    return PinCodeTextField(
      appContext: context,
      length: length,
      controller: controller,
      autoFocus: autoFocus,
      obscureText: isPassword,
      obscuringCharacter: '●',
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textStyle: AppTypography.heading3.copyWith(
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      pinTheme: PinTheme(
        shape: shape,
        fieldHeight: size,
        fieldWidth: size,
        borderRadius: BorderRadius.circular(AppDimensions.radius8.r),
        borderWidth: 1.5,
        activeColor: AppColors.primary,
        selectedColor: AppColors.primary,
        inactiveColor: isDark ? AppColors.borderDark : AppColors.borderLight,
        activeFillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        selectedFillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        inactiveFillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      ),
      enableActiveFill: true,
      animationDuration: const Duration(milliseconds: 200),
      onChanged: (value) => onChanged?.call(value),
      onCompleted: (value) => onCompleted?.call(value),
    );
  }

  double widgetSize(BuildContext context) => cellSize.w;
}
