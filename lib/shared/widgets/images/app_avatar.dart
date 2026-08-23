/*
 * ==============================================================================
 * [AppAvatar] - Ảnh Đại Diện Người Dùng (Avatar with Fallback & Online Status)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget Avatar người dùng:
 *   1. Tải ảnh đại diện qua URL (`imageUrl`) với bộ nhớ đệm cache.
 *   2. Tự động hiển thị chữ cái đầu tên người dùng (`initials`) nếu chưa có ảnh.
 *   3. Hỗ trợ chấm tròn trạng thái hoạt động (`isOnline = true`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: User avatar widget with cached image, initials fallback, and online status badge.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import 'app_cached_image.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool isOnline;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48.0,
    this.isOnline = false,
    this.onTap,
  });

  String get _initials {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.w;

    Widget avatarContent;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = ClipOval(
        child: AppCachedImage(
          imageUrl: imageUrl!,
          width: effectiveSize,
          height: effectiveSize,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarContent = Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: (effectiveSize * 0.4).sp,
            ),
          ),
        ),
      );
    }

    if (onTap != null) {
      avatarContent = InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatarContent,
      );
    }

    if (isOnline) {
      return Stack(
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: (effectiveSize * 0.28).w,
              height: (effectiveSize * 0.28).w,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    return avatarContent;
  }
}
