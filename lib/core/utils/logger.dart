/*
 * ==============================================================================
 * [AppLogger] - Trình Ghi Nhật Ký Chuẩn Production
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Ghi log có màu sắc, emoji và tag rõ ràng, tự động ẩn toàn bộ log khi build Release.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Production-safe logger with tags, log levels, and automatic stripping in release mode.
 * ==============================================================================
 */

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void d(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      developer.log('💡 [$tag] $message', name: tag);
    }
  }

  static void i(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      developer.log('ℹ️ [$tag] $message', name: tag);
    }
  }

  static void w(String message, {String tag = 'WARN'}) {
    if (kDebugMode) {
      developer.log('⚠️ [$tag] $message', name: tag);
    }
  }

  static void e(
    String message, {
    String tag = 'ERROR',
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        '❌ [$tag] $message',
        name: tag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Aliases for clear naming
  static void debug(String message, {String tag = 'DEBUG'}) =>
      d(message, tag: tag);
  static void info(String message, {String tag = 'INFO'}) =>
      i(message, tag: tag);
  static void warning(String message, {String tag = 'WARN'}) =>
      w(message, tag: tag);
  static void error(
    String message, {
    String tag = 'ERROR',
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      e(message, tag: tag, error: error, stackTrace: stackTrace);
}
