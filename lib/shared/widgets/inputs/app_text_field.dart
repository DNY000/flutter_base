/*
 * ==============================================================================
 * [AppTextField] - Ô Nhập Liệu Văn Bản Chuẩn Design System
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget TextField tùy biến:
 *   1. Hỗ trợ hiển thị nhãn `labelText` và gợi ý `hintText`.
 *   2. Tự động chuyển đổi ẩn/hiện mật khẩu nếu `isPassword = true`.
 *   3. Hỗ trợ icon đầu (`prefixIcon`) và icon cuối (`suffixIcon`).
 *   4. Tích hợp sẵn hàm kiểm tra tính hợp lệ `validator`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Form field supporting password toggling, prefix/suffix icons, and validations.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isPassword;
  final bool isReadOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool autoFocus;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.initialValue,
    this.isPassword = false,
    this.isReadOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.autoFocus = false,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.space4.h),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          obscureText: _obscureText,
          readOnly: widget.isReadOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: AppDimensions.iconSizeMedium.w,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
