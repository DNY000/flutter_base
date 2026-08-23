/*
 * ==============================================================================
 * [PermissionService] - Quản Lý Các Quyền Hệ Thống Cơ Bản (Runtime Permissions)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `permission_handler`
 * - Chức năng:
 *   1. Quản lý yêu cầu cấp quyền cơ bản của ứng dụng:
 *      - 🔔 Thông báo (Notification)
 *      - 📍 Vị trí (Location - Khi đang dùng app)
 *      - 📷 Camera (Chụp ảnh, Quét mã QR)
 *      - 🖼️ Thư viện ảnh / Tệp tin (Photos / Media Library)
 *      - 🎙️ Microphone (Ghi âm, Voice chat)
 *   2. Hỗ trợ hàm khởi tạo / xin đồng loạt quyền cơ bản: `requestBasicPermissions()`.
 *   3. Điều hướng mở Cài Đặt Ứng Dụng (App Settings) khi người dùng từ chối vĩnh viễn.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Essential runtime permissions management (Notifications, Location, Camera, Photos, Mic).
 * ==============================================================================
 */

import 'package:permission_handler/permission_handler.dart';
import '../utils/logger.dart';

abstract class IPermissionService {
  // Từng quyền riêng biệt
  Future<bool> requestNotificationPermission();
  Future<bool> requestLocationPermission();
  Future<bool> requestCameraPermission();
  Future<bool> requestPhotosPermission();
  Future<bool> requestMicrophonePermission();

  // Khởi tạo / Yêu cầu đồng loạt các quyền cơ bản
  Future<Map<Permission, PermissionStatus>> requestBasicPermissions({
    bool includeNotification = true,
    bool includeLocation = false,
    bool includeCamera = false,
    bool includePhotos = false,
  });

  // Kiểm tra trạng thái & Mở Settings
  Future<bool> hasPermission(Permission permission);
  Future<bool> openAppSettingsPage();
}

class PermissionServiceImpl implements IPermissionService {
  @override
  Future<bool> requestNotificationPermission() async {
    return _requestSinglePermission(Permission.notification, name: 'Thông báo');
  }

  @override
  Future<bool> requestLocationPermission() async {
    return _requestSinglePermission(Permission.locationWhenInUse, name: 'Vị trí');
  }

  @override
  Future<bool> requestCameraPermission() async {
    return _requestSinglePermission(Permission.camera, name: 'Camera');
  }

  @override
  Future<bool> requestPhotosPermission() async {
    return _requestSinglePermission(Permission.photos, name: 'Thư viện ảnh');
  }

  @override
  Future<bool> requestMicrophonePermission() async {
    return _requestSinglePermission(Permission.microphone, name: 'Microphone');
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestBasicPermissions({
    bool includeNotification = true,
    bool includeLocation = false,
    bool includeCamera = false,
    bool includePhotos = false,
  }) async {
    final permissionsToRequest = <Permission>[];
    if (includeNotification) permissionsToRequest.add(Permission.notification);
    if (includeLocation) permissionsToRequest.add(Permission.locationWhenInUse);
    if (includeCamera) permissionsToRequest.add(Permission.camera);
    if (includePhotos) permissionsToRequest.add(Permission.photos);

    if (permissionsToRequest.isEmpty) return {};

    AppLogger.info('🔑 [PERMISSION] Khởi tạo yêu cầu cấp quyền hàng loạt: $permissionsToRequest');
    final statuses = await permissionsToRequest.request();
    return statuses;
  }

  @override
  Future<bool> hasPermission(Permission permission) async {
    try {
      final status = await permission.status;
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> openAppSettingsPage() async {
    return openAppSettings();
  }

  Future<bool> _requestSinglePermission(Permission permission, {required String name}) async {
    try {
      final status = await permission.request();
      if (status.isGranted) {
        AppLogger.info('🔑 [PERMISSION] Quyền $name đã được cấp.');
        return true;
      } else if (status.isPermanentlyDenied) {
        AppLogger.warning('🔑 [PERMISSION] Quyền $name bị từ chối vĩnh viễn, người dùng cần mở Cài đặt ứng dụng.');
        return false;
      }
      return false;
    } catch (e) {
      AppLogger.error('🔑 [PERMISSION] Lỗi xin quyền $name: $e');
      return false;
    }
  }
}
