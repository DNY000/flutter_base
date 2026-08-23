/*
 * ==============================================================================
 * [AppRatingBar] - Thanh Đánh Giá Sao (Star Rating Bar)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget đánh giá sao từ 1 đến 5:
 *   1. Chế độ tương tác (`isReadOnly = false`): Người dùng nhấn để chọn số sao.
 *   2. Chế độ hiển thị (`isReadOnly = true`): Chỉ đọc để hiển thị điểm số.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: 5-star rating bar supporting interactive touch input or read-only display.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';

class AppRatingBar extends StatelessWidget {
  final double rating;
  final int maxRating;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool isReadOnly;

  const AppRatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.onRatingChanged,
    this.size = 24.0,
    this.activeColor = AppColors.warning,
    this.inactiveColor = AppColors.borderLight,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.w;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1.0;
        final isFilled = rating >= starValue;
        final isHalf = rating >= starValue - 0.5 && !isFilled;

        IconData iconData = Icons.star_border_rounded;
        Color color = inactiveColor;

        if (isFilled) {
          iconData = Icons.star_rounded;
          color = activeColor;
        } else if (isHalf) {
          iconData = Icons.star_half_rounded;
          color = activeColor;
        }

        Widget star = Icon(
          iconData,
          color: color,
          size: effectiveSize,
        );

        if (!isReadOnly && onRatingChanged != null) {
          star = GestureDetector(
            onTap: () => onRatingChanged!(starValue),
            child: star,
          );
        }

        return star;
      }),
    );
  }
}
