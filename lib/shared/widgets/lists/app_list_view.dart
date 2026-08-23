/*
 * ==============================================================================
 * [AppListView] - Danh Sách Thông Minh Phân Trang, Pull-to-Refresh & Load More
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget danh sách phân trang chuẩn Production sử dụng thư viện `easy_refresh`:
 *   1. Tự động xử lý Pull-to-Refresh (`onRefresh`) với hoạt ảnh mượt mà.
 *   2. Tự động xử lý Infinite Scroll / Load More (`onLoadMore`) khi cuộn gần đáy.
 *   3. Quản lý trạng thái hết dữ liệu (`hasMore = false` -> Hiển thị "Đã tải hết dữ liệu").
 *   4. Tự động hiển thị Loading (`AppLoadingIndicator`) khi tải lần đầu.
 *   5. Tự động hiển thị Error (`AppErrorView`) kèm nút Thử lại (`onRetry`).
 *   6. Tự động hiển thị Empty (`AppEmptyView`) khi danh sách rỗng.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Smart enterprise ListView with EasyRefresh for pull-to-refresh, infinite scroll pagination, and state handling.
 * ==============================================================================
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../states/app_empty_view.dart';
import '../states/app_error_view.dart';
import '../states/app_loading_indicator.dart';

class AppListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
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
  final Widget? separator;
  final ScrollPhysics? physics;
  final EasyRefreshController? controller;

  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
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
    this.separator,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Trạng thái Loading ban đầu
    if (isLoading && items.isEmpty) {
      return const Center(child: AppLoadingIndicator());
    }

    // 2. Trạng thái Lỗi khi danh sách trống
    if (errorMessage != null && items.isEmpty) {
      return AppErrorView(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    // 3. Trạng thái Danh sách rỗng (Hỗ trợ Pull-to-refresh ngay cả khi rỗng)
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

    // 4. Danh sách chính với EasyRefresh (Pull-to-Refresh & Load More)
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
      child: ListView.separated(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.all(16.w),
        itemCount: items.length,
        separatorBuilder: (ctx, idx) =>
            separator ?? SizedBox(height: 12.h),
        itemBuilder: (ctx, idx) => itemBuilder(ctx, items[idx], idx),
      ),
    );
  }
}
