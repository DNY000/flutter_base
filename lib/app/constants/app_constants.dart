/*
 * ==============================================================================
 * [AppConstants] - Các Hằng Số Cấu Hình Chung Của Toàn Bộ Dự Án
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Lưu trữ các hằng số tầng ứng dụng (App Name, Design Size, Storage Keys, Locales...).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Project-level constants (App metadata, design base resolution, storage keys, locales).
 * ==============================================================================
 */

class AppConstants {
  AppConstants._();

  static const String appName = 'Base Project';
  static const String appVersion = '1.0.0';

  // ScreenUtil design resolution (Figma base)
  static const double designWidth = 375.0;
  static const double designHeight = 812.0;

  // Storage Keys
  static const String keyAccessToken = 'ACCESS_TOKEN';
  static const String keyRefreshToken = 'REFRESH_TOKEN';
  static const String keyUserId = 'USER_ID';
  static const String keyUserData = 'USER_DATA';
  static const String keyThemeMode = 'THEME_MODE';
  static const String keyLanguageCode = 'LANGUAGE_CODE';
  static const String keyIsFirstInstall = 'IS_FIRST_INSTALL';
  static const String keyFcmToken = 'FCM_TOKEN';

  // Locales
  static const String localeVi = 'vi';
  static const String localeEn = 'en';
}
