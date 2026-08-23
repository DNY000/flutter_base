/*
 * ==============================================================================
 * [AppCachedImage] - Tải Ảnh Từ Mạng Kèm Bộ Nhớ Đệm & Hiệu Ứng Khung Xương
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Bọc `CachedNetworkImage` tự động cache ảnh vào Disk/Memory, tích hợp
 *   hiệu ứng Shimmer skeleton khi đang tải và ảnh fallback khi gặp lỗi kết nối.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Network image loader with disk caching, shimmer loading skeleton, and fallback error placeholder.
 * ==============================================================================
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final Widget? errorWidget;
  final Widget? placeholder;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radius8;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.shimmerBase.withValues(alpha: 0.3),
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.textSecondaryLight,
              ),
            ),
      ),
    );
  }
}
