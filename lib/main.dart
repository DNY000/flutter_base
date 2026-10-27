/*
 * ==============================================================================
 * [Main Entry Point] - Điểm Khởi Đầu Của Ứng Dụng Flutter Enterprise
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Khởi tạo đầy đủ các nền tảng:
 *   1. Môi trường cấu hình (AppConfig Flavors: DEV, STAGING, PROD).
 *   2. Đa ngôn ngữ (EasyLocalization).
 *   3. Service Locator Dependency Injection (GetIt).
 *   4. Cấu hình động từ xa (Firebase Remote Config).
 *   5. Giám sát lỗi và Crashlytics toàn cục (CrashMonitoringService).
 *   6. Dịch vụ Thông báo (NotificationService - Foreground, Background, Kill App).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Main application entry point initializing configs, monitoring, i18n, DI, and notifications.
 * ==============================================================================
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/services/crash_monitoring_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/storage/hive_storage.dart';
import 'core/utils/logger.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo cấu hình môi trường ban đầu
  AppConfig.init(environment: Environment.dev);

  // 2. Khởi tạo Firebase Core
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('🔥 [FIREBASE] Khởi tạo Firebase Core thành công.');
  } catch (e) {
    AppLogger.error(
        '🔥 [FIREBASE] Lỗi khởi tạo Firebase Core (chưa có google-services.json hoặc mock): $e');
  }

  // 3. Khởi tạo đa ngôn ngữ
  await EasyLocalization.ensureInitialized();

  // 3. Khởi tạo toàn bộ Dependency Injection
  await initDependencies();

  // 4. Khởi tạo Hive CE Local Cache & Offline Storage
  try {
    await sl<IHiveStorage>().initialize();
  } catch (e) {
    AppLogger.error('Không thể khởi tạo HiveStorage: $e');
  }

  // 5. Lấy cấu hình động từ xa (Firebase Remote Config) đổ vào AppConfig
  try {
    await sl<IRemoteConfigService>().initialize();
  } catch (e) {
    AppLogger.error('Không thể tải Remote Config: $e');
  }

  // 5. Kích hoạt giám sát Crashlytics & Error Tracking toàn cục
  sl<ICrashMonitoringService>().initialize();

  // 6. Khởi tạo dịch vụ Notification
  try {
    await sl<INotificationService>().initialize();
  } catch (e) {
    AppLogger.error('Không thể khởi tạo NotificationService: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: const MyApp(),
    ),
  );
}
