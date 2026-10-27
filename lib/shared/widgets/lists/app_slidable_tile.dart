/*
 * ==============================================================================
 * [AppSlidableTile] - Phần Tử Danh Sách Hỗ Trợ Vuốt Trái/Phải (Flutter Slidable)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `flutter_slidable`
 * - Chức năng: Cho phép người dùng vuốt item trong danh sách sang trái hoặc phải
 *   để mở các hành động nhanh (Xóa, Chỉnh sửa, Ghim, Chia sẻ, v.v.).
 * - Thường dùng: Danh sách thông báo, giỏ hàng, danh bạ, tác vụ công việc.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Swipable list tile widget supporting custom left/right slide actions powered by flutter_slidable.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../app/theme/app_colors.dart';

class AppSlideAction {
  final String? label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function(BuildContext context) onPressed;

  const AppSlideAction({
    this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
  });

  /// Action Xóa mặc định (Màu đỏ)
  factory AppSlideAction.delete({
    String label = 'Xóa',
    required void Function(BuildContext context) onPressed,
  }) {
    return AppSlideAction(
      label: label,
      icon: Icons.delete_outline,
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      onPressed: onPressed,
    );
  }

  /// Action Chỉnh sửa mặc định (Màu xanh dương)
  factory AppSlideAction.edit({
    String label = 'Sửa',
    required void Function(BuildContext context) onPressed,
  }) {
    return AppSlideAction(
      label: label,
      icon: Icons.edit_outlined,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      onPressed: onPressed,
    );
  }
}

class AppSlidableTile extends StatelessWidget {
  final Widget child;
  final List<AppSlideAction>? startActions; // Vuốt từ trái sang phải
  final List<AppSlideAction>? endActions; // Vuốt từ phải sang trái
  final bool isEnabled;

  const AppSlidableTile({
    super.key,
    required this.child,
    this.startActions,
    this.endActions,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEnabled || (startActions == null && endActions == null)) {
      return child;
    }

    return Slidable(
      key: ValueKey(key ?? UniqueKey()),
      startActionPane: startActions != null && startActions!.isNotEmpty
          ? ActionPane(
              motion: const DrawerMotion(),
              children: startActions!.map((action) {
                return SlidableAction(
                  onPressed: action.onPressed,
                  backgroundColor: action.backgroundColor ?? AppColors.primary,
                  foregroundColor: action.foregroundColor ?? Colors.white,
                  icon: action.icon,
                  label: action.label,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(8.r)),
                );
              }).toList(),
            )
          : null,
      endActionPane: endActions != null && endActions!.isNotEmpty
          ? ActionPane(
              motion: const DrawerMotion(),
              children: endActions!.map((action) {
                return SlidableAction(
                  onPressed: action.onPressed,
                  backgroundColor: action.backgroundColor ?? AppColors.error,
                  foregroundColor: action.foregroundColor ?? Colors.white,
                  icon: action.icon,
                  label: action.label,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(8.r)),
                );
              }).toList(),
            )
          : null,
      child: child,
    );
  }
}
