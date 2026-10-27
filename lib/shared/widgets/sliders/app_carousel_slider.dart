/*
 * ==============================================================================
 * [AppCarouselSlider] - Trình Chiếu Ảnh & Banner (Carousel Slider)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget trình chiếu Banner/Hình ảnh lướt ngang với chỉ báo chấm tròn (Dot Indicators),
 *   hỗ trợ tự động chuyển trang (`autoPlay = true`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Horizontal banner/image carousel slider with active dot page indicators.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';

class AppCarouselSlider extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double? viewportFraction;
  final ValueChanged<int>? onPageChanged;

  const AppCarouselSlider({
    super.key,
    required this.items,
    this.height = 180.0,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.viewportFraction = 1.0,
    this.onPageChanged,
  });

  @override
  State<AppCarouselSlider> createState() => _AppCarouselSliderState();
}

class _AppCarouselSliderState extends State<AppCarouselSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: widget.viewportFraction ?? 1.0);
    if (widget.autoPlay && widget.items.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_pageController.hasClients && widget.items.isNotEmpty) {
        final nextPage = (_currentPage + 1) % widget.items.length;
        unawaited(
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (idx) {
              setState(() => _currentPage = idx);
              widget.onPageChanged?.call(idx);
            },
            itemBuilder: (ctx, idx) => widget.items[idx],
          ),
        ),
        if (widget.items.length > 1) ...[
          SizedBox(height: AppDimensions.space8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (index) {
              final isCurrent = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isCurrent ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
