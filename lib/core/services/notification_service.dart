/*
 * ==============================================================================
 * [NotificationService] - Dịch vụ Quản lý Thông báo Toàn diện (Push & Local)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Xử lý toàn bộ vòng đời của thông báo trong 3 trạng thái:
 *   1. **Foreground (Trong ứng dụng)**: Nhận tin -> Hiển thị Local Notification dạng Banner (Heads-up) 
 *      kèm âm thanh và rung -> Khi click gọi Navigation Handler.
 *   2. **Background (App chạy ngầm)**: Khi người dùng bấm vào thông báo trên thanh trạng thái 
 *      -> Đưa app lên Foreground -> Bóc tách payload và điều hướng đến màn hình đích.
 *   3. **Terminated / Killed App (App bị tắt hoàn toàn)**: Người dùng bấm thông báo để khởi động app 
 *      (Cold Start) -> Đọc `getNotificationAppLaunchDetails` -> Lưu pending navigation và điều hướng 
 *      khi Router/UI đã sẵn sàng.
 * - Hỗ trợ Deep Link & Navigation: Tích hợp trực tiếp với [AppRouter] và [RouteNames].
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Complete notification management handling all 3 lifecycle states:
 *   1. **Foreground**: Displays heads-up local notification banner.
 *   2. **Background**: Extracts payload and navigates when notification is clicked.
 *   3. **Terminated/Killed**: Handles cold start via launch details and queues pending navigation.
 * ==============================================================================
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../app/router/app_router.dart';
import '../../app/router/route_names.dart';
import '../utils/logger.dart';

abstract class INotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payloadData,
  });
  Future<void> cancel(int id);
  Future<void> cancelAll();
  void handlePendingNotificationAfterLaunch();
}

class NotificationServiceImpl implements INotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Kênh thông báo Android chuẩn mực (High Importance cho Heads-up banner)
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'Thông báo quan trọng', // title
    description: 'Kênh nhận các thông báo hệ thống và giao dịch quan trọng.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Lưu payload khi mở app từ trạng thái Killed/Terminated (Cold Start)
  String? _pendingPayload;

  @override
  Future<void> initialize() async {
    // 1. Cấu hình cài đặt cho Android và iOS
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Sẽ yêu cầu thông qua requestPermission()
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 2. Khởi tạo Android Notification Channel
    final androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_defaultChannel);
    }

    // 3. Khởi tạo Local Notification Plugin kèm Callback khi TAP vào thông báo (Foreground/Background)
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundTapHandler,
    );

    // 4. Xử lý trạng thái KILLED APP / TERMINATED (Cold Start)
    final launchDetails =
        await _localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      final payload = launchDetails.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        AppLogger.i('App launched from KILLED state with payload: $payload',
            tag: 'NOTIFICATION');
        _pendingPayload = payload;
      }
    }

    AppLogger.i('Notification Service Initialized successfully');
  }

  @override
  Future<bool> requestPermission() async {
    // Android 13+ (API 33+) yêu cầu cấp quyền POST_NOTIFICATIONS
    final androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await androidImplementation?.requestNotificationsPermission();

    // iOS Request Permissions
    final iosImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Hiển thị thông báo Local (Dùng khi app đang ở Foreground hoặc từ background task)
  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payloadData,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _defaultChannel.id,
      _defaultChannel.name,
      channelDescription: _defaultChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payloadString = payloadData != null ? jsonEncode(payloadData) : null;

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payloadString,
    );
  }

  /// Callback khi người dùng BẤM vào thông báo khi app đang chạy (Foreground hoặc Background)
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    AppLogger.i('User tapped notification: payload=$payload',
        tag: 'NOTIFICATION');
    _handlePayloadNavigation(payload);
  }

  /// Kích hoạt xử lý thông báo còn tồn đọng sau khi App & Router khởi tạo xong (Sau Splash/Login)
  @override
  void handlePendingNotificationAfterLaunch() {
    if (_pendingPayload != null) {
      AppLogger.i('Handling pending cold-start notification navigation...',
          tag: 'NOTIFICATION');
      final payload = _pendingPayload;
      _pendingPayload = null;
      // Đặt độ trễ nhỏ để đảm bảo Router Navigator Key đã gắn kết vào Widget Tree
      Future.delayed(const Duration(milliseconds: 500), () {
        _handlePayloadNavigation(payload);
      });
    }
  }

  /// =========================================================================
  /// NAVIGATION & DEEP LINK HANDLER
  /// =========================================================================
  void _handlePayloadNavigation(String? payload) {
    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) {
        AppLogger.w('Notification payload is not a JSON object: $payload',
            tag: 'NOTIFICATION');
        return;
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);
      final String? targetRoute = data['route'] as String?;
      final String? targetType = data['type'] as String?;
      final dynamic targetId = data['id'];

      AppLogger.d(
        'Routing notification: route=$targetRoute, type=$targetType, id=$targetId',
        tag: 'NOTIFICATION_NAV',
      );

      final navContext = AppRouter.rootNavigatorKey.currentContext;
      if (navContext == null) {
        AppLogger.w('Navigator context is not ready yet.');
        return;
      }

      // Xử lý điều hướng dựa trên targetRoute hoặc type
      if (targetRoute != null && targetRoute.isNotEmpty) {
        unawaited(AppRouter.router.push(targetRoute, extra: data));
      } else if (targetType == 'HOME') {
        AppRouter.router.go(RouteNames.home);
      } else {
        // Mặc định mở Home nếu không có route cụ thể
        AppRouter.router.go(RouteNames.home);
      }
    } catch (e) {
      AppLogger.e('Failed to parse notification payload: $e',
          tag: 'NOTIFICATION');
    }
  }

  @override
  Future<void> cancel(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await _localNotificationsPlugin.cancelAll();
  }
}

/// Entry point bắt buộc độc lập (Top-level / Isolate) cho sự kiện tap notification khi background
@pragma('vm:entry-point')
void notificationBackgroundTapHandler(NotificationResponse response) {
  // Được OS gọi khi tap notification từ Background isolate
}
