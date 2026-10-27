/*
 * ==============================================================================
 * [AppShimmer] - Hiệu Ứng Khung Xương Tải Trang (Shimmer Skeleton)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Tạo hiệu ứng shimmer lướt sáng trên các khối placeholder hình chữ nhật, hình tròn
 *   giúp trải nghiệm người dùng mượt mà hơn hẳn so với spinner thông thường.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Shimmer skeleton loading effect wrapper for placeholder boxes and circles.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final ShapeBorder shapeBorder;

  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const AppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8.0,
  }) : shapeBorder = const RoundedRectangleBorder();

  const AppShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2C) : AppColors.shimmerBase,
      highlightColor:
          isDark ? const Color(0xFF3D3D3D) : AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: borderRadius != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius!.r),
                )
              : shapeBorder,
        ),
      ),
    );
  }
}
