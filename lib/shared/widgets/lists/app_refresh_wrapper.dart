/*
 * ==============================================================================
 * [AppRefreshWrapper] - Bao Bọc Kéo Để Làm Mới & Tải Thêm Toàn Năng
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget bao bọc bất kỳ ScrollView nào (CustomScrollView, Slivers, ListView tùy biến)
 *   với thư viện `easy_refresh`, hỗ trợ `onRefresh` và `onLoadMore`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Universal EasyRefresh wrapper for any custom scrollable widget or sliver layout.
 * ==============================================================================
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AppRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final EasyRefreshController? controller;
  final Header? header;
  final Footer? footer;

  const AppRefreshWrapper({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = true,
    this.controller,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
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
      header: header ??
          const ClassicHeader(
            dragText: 'Kéo xuống để làm mới',
            armedText: 'Thả tay để làm mới',
            readyText: 'Đang làm mới...',
            processingText: 'Đang làm mới...',
            processedText: 'Làm mới thành công',
            noMoreText: 'Không có thêm dữ liệu',
            failedText: 'Làm mới thất bại',
            textStyle: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
          ),
      footer: footer ??
          const ClassicFooter(
            dragText: 'Kéo lên để tải thêm',
            armedText: 'Thả tay để tải thêm',
            readyText: 'Đang tải thêm...',
            processingText: 'Đang tải thêm...',
            processedText: 'Tải thành công',
            noMoreText: '— Đã hiển thị toàn bộ dữ liệu —',
            failedText: 'Tải thất bại, hãy thử lại',
            textStyle: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
          ),
      child: child,
    );
  }
}
