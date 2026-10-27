/*
 * ==============================================================================
 * [AppConfig] - Lớp Cấu Hình Toàn Cục (Flavors, Môi Trường & Remote Config Properties)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng:
 *   1. Chứa toàn bộ các biến cấu hình (Môi trường DEV/STAGING/PROD, Base URL, Version, Maintenance...).
 *   2. Cung cấp dữ liệu mặc định an toàn khi khởi chạy app.
 *   3. Nhận dữ liệu cập nhật từ Firebase Remote Config và ghi đè vào `AppConfig.instance`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Global application configuration holding flavors, environment URLs, and Remote Config values.
 * ==============================================================================
 */

import 'package:firebase_remote_config/firebase_remote_config.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final String minAppVersion;
  final bool isForceUpdateRequired;
  final bool isMaintenanceMode;
  final String maintenanceMessage;
  final String supportHotline;
  final bool enablePromoBanner;
  final int apiTimeoutSeconds;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final List<String> sslFingerprints;

  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? defaultDev;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.minAppVersion = '1.0.0',
    this.isForceUpdateRequired = false,
    this.isMaintenanceMode = false,
    this.maintenanceMessage =
        'Hệ thống đang được nâng cấp định kỳ. Xin vui lòng quay lại sau.',
    this.supportHotline = '1900 6868',
    this.enablePromoBanner = true,
    this.apiTimeoutSeconds = 30,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    this.sslFingerprints = const [],
  });

  static AppConfig get defaultDev => const AppConfig(
        environment: Environment.dev,
        appName: 'Base App [DEV]',
        apiBaseUrl: 'https://api-dev.example.com/v1',
        enableLogging: true,
        enableCrashlytics: false,
        enableAnalytics: false,
      );

  static AppConfig get defaultStaging => const AppConfig(
        environment: Environment.staging,
        appName: 'Base App [STAGING]',
        apiBaseUrl: 'https://api-staging.example.com/v1',
        enableLogging: true,
        enableCrashlytics: true,
        enableAnalytics: true,
      );

  static AppConfig get defaultProd => const AppConfig(
        environment: Environment.prod,
        appName: 'Base App',
        apiBaseUrl: 'https://api.example.com/v1',
        enableLogging: false,
        enableCrashlytics: true,
        enableAnalytics: true,
        sslFingerprints: [
          'AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD',
        ],
      );

  /// Khởi tạo cấu hình ban đầu
  static void init({
    required Environment environment,
    String? customBaseUrl,
  }) {
    switch (environment) {
      case Environment.dev:
        _instance = customBaseUrl != null
            ? defaultDev.copyWith(apiBaseUrl: customBaseUrl)
            : defaultDev;
        break;
      case Environment.staging:
        _instance = customBaseUrl != null
            ? defaultStaging.copyWith(apiBaseUrl: customBaseUrl)
            : defaultStaging;
        break;
      case Environment.prod:
        _instance = customBaseUrl != null
            ? defaultProd.copyWith(apiBaseUrl: customBaseUrl)
            : defaultProd;
        break;
    }
  }

  /// Cập nhật dữ liệu từ Firebase Remote Config đổ vào AppConfig.instance
  static void updateFromFirebase(FirebaseRemoteConfig rc) {
    if (_instance == null) return;

    final envString = rc.getString('app_environment').trim().toLowerCase();
    Environment? remoteEnv;
    if (envString == 'prod' || envString == 'production') {
      remoteEnv = Environment.prod;
    } else if (envString == 'staging') {
      remoteEnv = Environment.staging;
    } else if (envString == 'dev' || envString == 'development') {
      remoteEnv = Environment.dev;
    }

    final remoteApiBaseUrl = rc.getString('api_base_url');
    final remoteAppName = rc.getString('app_name');

    _instance = _instance!.copyWith(
      environment: remoteEnv ?? _instance!.environment,
      appName: remoteAppName.isNotEmpty ? remoteAppName : _instance!.appName,
      apiBaseUrl: remoteApiBaseUrl.isNotEmpty
          ? remoteApiBaseUrl
          : _instance!.apiBaseUrl,
      minAppVersion: rc.getString('min_app_version').isNotEmpty
          ? rc.getString('min_app_version')
          : _instance!.minAppVersion,
      isForceUpdateRequired: rc.getBool('force_update_required'),
      isMaintenanceMode: rc.getBool('is_maintenance_mode'),
      maintenanceMessage: rc.getString('maintenance_message').isNotEmpty
          ? rc.getString('maintenance_message')
          : _instance!.maintenanceMessage,
      supportHotline: rc.getString('support_hotline').isNotEmpty
          ? rc.getString('support_hotline')
          : _instance!.supportHotline,
      enablePromoBanner: rc.getBool('enable_promo_banner'),
      apiTimeoutSeconds: rc.getInt('api_timeout_seconds') > 0
          ? rc.getInt('api_timeout_seconds')
          : _instance!.apiTimeoutSeconds,
    );
  }

  /// Cung cấp Map giá trị mặc định cho Firebase Remote Config setDefaults()
  Map<String, dynamic> toDefaultsMap() => {
        'app_environment': environment.name,
        'app_name': appName,
        'api_base_url': apiBaseUrl,
        'min_app_version': minAppVersion,
        'force_update_required': isForceUpdateRequired,
        'is_maintenance_mode': isMaintenanceMode,
        'maintenance_message': maintenanceMessage,
        'support_hotline': supportHotline,
        'enable_promo_banner': enablePromoBanner,
        'api_timeout_seconds': apiTimeoutSeconds,
      };

  AppConfig copyWith({
    Environment? environment,
    String? appName,
    String? apiBaseUrl,
    String? minAppVersion,
    bool? isForceUpdateRequired,
    bool? isMaintenanceMode,
    String? maintenanceMessage,
    String? supportHotline,
    bool? enablePromoBanner,
    int? apiTimeoutSeconds,
    bool? enableLogging,
    bool? enableCrashlytics,
    bool? enableAnalytics,
    List<String>? sslFingerprints,
  }) {
    return AppConfig(
      environment: environment ?? this.environment,
      appName: appName ?? this.appName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      minAppVersion: minAppVersion ?? this.minAppVersion,
      isForceUpdateRequired:
          isForceUpdateRequired ?? this.isForceUpdateRequired,
      isMaintenanceMode: isMaintenanceMode ?? this.isMaintenanceMode,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      supportHotline: supportHotline ?? this.supportHotline,
      enablePromoBanner: enablePromoBanner ?? this.enablePromoBanner,
      apiTimeoutSeconds: apiTimeoutSeconds ?? this.apiTimeoutSeconds,
      enableLogging: enableLogging ?? this.enableLogging,
      enableCrashlytics: enableCrashlytics ?? this.enableCrashlytics,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      sslFingerprints: sslFingerprints ?? this.sslFingerprints,
    );
  }

  bool get isProduction => environment == Environment.prod;
  bool get isDevelopment => environment == Environment.dev;
}
