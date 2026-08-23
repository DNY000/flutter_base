/*
 * ==============================================================================
 * [ApiEndpoints] - Danh Sách Đường Dẫn API & Cấu Hình Network
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Tập trung khai báo toàn bộ Endpoints (Auth, User, Notifications...)
 *   và cấu hình Timeout mạng của tầng Network.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Centralized API endpoints and network configuration constants.
 * ==============================================================================
 */

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.example.com/v1';

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/me';

  // User endpoints
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Notifications
  static const String registerFcm = '/notifications/fcm-token';
  static const String getNotifications = '/notifications';
}
