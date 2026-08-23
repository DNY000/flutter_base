/*
 * ==============================================================================
 * [AppMasonryGridView] - Lưới So Le Phong Cách Pinterest (Masonry Staggered Grid)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `flutter_staggered_grid_view`
 * - Chức năng: Hiển thị danh sách thẻ hình ảnh, sản phẩm, tin tức với chiều cao linh hoạt,
 *   tự động sắp xếp so le (Masonry Grid) cực kỳ đẹp mắt, không bị khoảng trống thừa.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Masonry staggered grid view supporting variable height items powered by flutter_staggered_grid_view.
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../app/theme/app_dimensions.dart';

class AppMasonryGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AppMasonryGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 12.0,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing.h,
      crossAxisSpacing: crossAxisSpacing.w,
      padding: padding ?? EdgeInsets.all(AppDimensions.space16.w),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
