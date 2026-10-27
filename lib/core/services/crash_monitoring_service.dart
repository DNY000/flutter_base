/*
 * ==============================================================================
 * [CrashMonitoringService] - Giám Sát Crash & Báo Cáo Lỗi (Firebase Crashlytics)
 * ==============================================================================
 */

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

abstract class ICrashMonitoringService {
  void initialize();
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  });
  Future<void> logBreadcrumb(String message, {String? category});
  Future<void> setUserIdentifier(String? userId);
  Future<void> setCustomKey(String key, Object value);
}

class CrashMonitoringServiceImpl implements ICrashMonitoringService {
  final FirebaseCrashlytics? _crashlytics;
  final bool isEnabled;
  final List<String> _breadcrumbs = [];
  static const int _maxBreadcrumbs = 25;

  CrashMonitoringServiceImpl({
    FirebaseCrashlytics? crashlytics,
    this.isEnabled = true,
  }) : _crashlytics = crashlytics;

  FirebaseCrashlytics get _instance =>
      _crashlytics ?? FirebaseCrashlytics.instance;

  @override
  void initialize() {
    if (!isEnabled) {
      try {
        _instance.setCrashlyticsCollectionEnabled(false);
      } catch (e) {
        AppLogger.d('Crashlytics disable failed: $e', tag: 'CRASHLYTICS');
      }
      return;
    }

    try {
      // 1. Tự động bắt toàn bộ ngoại lệ từ Flutter UI Framework
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        recordError(
          details.exception,
          details.stack,
          reason: details.context,
          fatal: true,
        );
        try {
          _instance.recordFlutterFatalError(details);
        } catch (e) {
          AppLogger.d('Firebase recordFlutterFatalError failed: $e',
              tag: 'CRASHLYTICS');
        }
      };

      // 2. Tự động bắt toàn bộ ngoại lệ bất đồng bộ (Async / Platform Engine)
      PlatformDispatcher.instance.onError = (error, stack) {
        recordError(error, stack, fatal: true);
        try {
          _instance.recordError(error, stack, fatal: true);
        } catch (e) {
          AppLogger.d('Firebase recordError on PlatformDispatcher failed: $e',
              tag: 'CRASHLYTICS');
        }
        return true; // Ngăn chặn app bị dừng đột ngột nếu có thể khôi phục
      };

      AppLogger.info(
          '🛡️ [CRASHLYTICS] Đã kích hoạt giám sát ngoại lệ và crash toàn cầu.');
    } catch (e) {
      AppLogger.error('🛡️ [CRASHLYTICS] Lỗi khi khởi tạo Crashlytics: $e');
    }
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) async {
    final prefix = fatal ? '🔥 [FATAL CRASH]' : '⚠️ [NON-FATAL ERROR]';
    AppLogger.error(
      '$prefix Reason: $reason | Exception: $exception',
      error: exception,
      stackTrace: stackTrace,
    );

    if (!isEnabled) return;
    try {
      await _instance.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      AppLogger.error('🛡️ [CRASHLYTICS] Lỗi gửi recordError: $e');
    }
  }

  @override
  Future<void> logBreadcrumb(String message, {String? category}) async {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '[$timestamp] [${category ?? 'ACTION'}] $message';

    if (_breadcrumbs.length >= _maxBreadcrumbs) {
      _breadcrumbs.removeAt(0);
    }
    _breadcrumbs.add(entry);

    if (!isEnabled) return;
    try {
      await _instance.log(entry);
    } catch (e) {
      AppLogger.d('Firebase Crashlytics log breadcrumb failed: $e',
          tag: 'CRASHLYTICS');
    }
  }

  @override
  Future<void> setUserIdentifier(String? userId) async {
    if (userId != null) {
      AppLogger.info('👤 [CRASHLYTICS] Gắn định danh User ID: $userId');
      if (!isEnabled) return;
      try {
        await _instance.setUserIdentifier(userId);
      } catch (e) {
        AppLogger.error('🛡️ [CRASHLYTICS] Lỗi setUserIdentifier: $e');
      }
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!isEnabled) return;
    try {
      await _instance.setCustomKey(key, value);
    } catch (e) {
      AppLogger.error('🛡️ [CRASHLYTICS] Lỗi setCustomKey: $e');
    }
  }

  List<String> get recentBreadcrumbs => List.unmodifiable(_breadcrumbs);
}
