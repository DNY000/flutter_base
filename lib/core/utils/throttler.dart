/*
 * ==============================================================================
 * [Throttler] - Tiện Ích Giới Hạn Tần Suất Gọi Hàm (Rate Limiting / Throttling)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Đảm bảo một hàm chỉ được thực thi tối đa 1 lần trong khoảng thời gian `throttleDuration`.
 * - Ứng dụng: Chống spam bấm nút thanh toán, hạn chế gọi API refresh liên tục, xử lý Scroll / Drag.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Rate-limit function execution within a specified duration window.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/foundation.dart';

class Throttler {
  final Duration throttleDuration;
  Timer? _timer;
  bool _isThrottled = false;

  Throttler({this.throttleDuration = const Duration(milliseconds: 1000)});

  /// Thực thi hàm `action` nếu chưa bị throttle trong khoảng thời gian quy định
  void run(VoidCallback action) {
    if (_isThrottled) return;

    _isThrottled = true;
    action();

    _timer?.cancel();
    _timer = Timer(throttleDuration, () {
      _isThrottled = false;
    });
  }

  /// Reset trạng thái throttler ngay lập tức
  void dispose() {
    _timer?.cancel();
    _isThrottled = false;
  }
}
