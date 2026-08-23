/*
 * ==============================================================================
 * [AppGridView] - Lưới Hiển Thị Thông Minh Phân Trang, Refresh & Load More
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget GridView responsive chuẩn Production sử dụng thư viện `easy_refresh`:
 *   1. Hỗ trợ Pull-to-Refresh (`onRefresh`) và Infinite Scroll / Load More (`onLoadMore`).
 *   2. Tự động xử lý trạng thái Loading, Empty, Error kèm nút Retry.
 *   3. Quản lý trạng thái hết trang (`hasMore = false`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Smart responsive GridView with EasyRefresh for pull-to-refresh, load more pagination, and state handling.
 * ==============================================================================
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../states/app_empty_view.dart';
import '../states/app_error_view.dart';
import '../states/app_loading_indicator.dart';

class AppGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final String emptyTitle;
  final String? emptySubtitle;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final EasyRefreshController? controller;

  const AppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 1.0,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = true,
    this.emptyTitle = 'Không có dữ liệu',
    this.emptySubtitle,
    this.emptyWidget,
    this.padding,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Trạng thái Loading ban đầu
    if (isLoading && items.isEmpty) {
      return const Center(child: AppLoadingIndicator());
    }

    // 2. Trạng thái Lỗi khi rỗng
    if (errorMessage != null && items.isEmpty) {
      return AppErrorView(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    // 3. Trạng thái Rỗng
    if (items.isEmpty) {
      final emptyChild = emptyWidget ??
          AppEmptyView(
            title: emptyTitle,
            subtitle: emptySubtitle,
            onAction: onRetry,
            actionText: onRetry != null ? 'Tải lại' : null,
          );

      if (onRefresh != null) {
        return EasyRefresh(
          onRefresh: onRefresh,
          header: const ClassicHeader(
            dragText: 'Kéo xuống để làm mới',
            armedText: 'Thả tay để làm mới',
            readyText: 'Đang làm mới...',
            processingText: 'Đang làm mới...',
            processedText: 'Làm mới thành công',
            noMoreText: 'Không có thêm dữ liệu',
            failedText: 'Làm mới thất bại',
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 450.h,
              child: Center(child: emptyChild),
            ),
          ),
        );
      }
      return emptyChild;
    }

    // 4. Lưới chính với EasyRefresh
    return EasyRefresh(
      controller: controller,
      onRefresh: onRefresh,
      onLoad: onLoadMore != null && hasMore
          ? () async {
              await onLoadMore!();
              if (!hasMore) {
                return IndicatorResult.noMore;
              }
              return IndicatorResult.success;
            }
          : null,
      header: const ClassicHeader(
        dragText: 'Kéo xuống để làm mới',
        armedText: 'Thả tay để làm mới',
        readyText: 'Đang làm mới...',
        processingText: 'Đang làm mới...',
        processedText: 'Làm mới thành công',
        noMoreText: 'Không có thêm dữ liệu',
        failedText: 'Làm mới thất bại',
        textStyle: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
      ),
      footer: const ClassicFooter(
        dragText: 'Kéo lên để tải thêm',
        armedText: 'Thả tay để tải thêm',
        readyText: 'Đang tải thêm...',
        processingText: 'Đang tải thêm...',
        processedText: 'Tải thành công',
        noMoreText: '— Đã hiển thị toàn bộ dữ liệu —',
        failedText: 'Tải thất bại, hãy thử lại',
        textStyle: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
      ),
      child: GridView.builder(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing.w,
          mainAxisSpacing: mainAxisSpacing.h,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, idx) => itemBuilder(ctx, items[idx], idx),
      ),
    );
  }
}
