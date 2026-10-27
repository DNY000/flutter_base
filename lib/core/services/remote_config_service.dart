/*
 * ==============================================================================
 * [RemoteConfigService] - Dịch Vụ Tải Cấu Hình Firebase Remote Config Đổ Vào AppConfig
 * ==============================================================================
 */

import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';

abstract class IRemoteConfigService {
  Future<void> initialize();
  Future<bool> fetchAndActivate();
}

class RemoteConfigServiceImpl implements IRemoteConfigService {
  final FirebaseRemoteConfig? _remoteConfig;
  final bool isDebug;

  RemoteConfigServiceImpl({
    FirebaseRemoteConfig? remoteConfig,
    this.isDebug = false,
  }) : _remoteConfig = remoteConfig;

  FirebaseRemoteConfig get _instance =>
      _remoteConfig ?? FirebaseRemoteConfig.instance;

  @override
  Future<void> initialize() async {
    try {
      AppLogger.info('⚙️ [REMOTE CONFIG] Khởi tạo Firebase Remote Config.');

      // 1. Cấu hình thời gian fetch cache
      await _instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval:
              isDebug ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // 2. Gán giá trị mặc định từ AppConfig.instance
      await _instance.setDefaults(AppConfig.instance.toDefaultsMap());

      // 3. Tải data từ Firebase và cập nhật vào AppConfig.instance
      await fetchAndActivate();

      // 4. Lắng nghe cập nhật thời gian thực
      _instance.onConfigUpdated.listen((event) async {
        await _instance.activate();
        AppConfig.updateFromFirebase(_instance);
        AppLogger.info(
            '⚙️ [REMOTE CONFIG] Tự động cập nhật AppConfig từ xa cho keys: ${event.updatedKeys}');
      });
    } catch (e) {
      AppLogger.error('⚙️ [REMOTE CONFIG] Lỗi khởi tạo Remote Config: $e');
    }
  }

  @override
  Future<bool> fetchAndActivate() async {
    try {
      final updated = await _instance.fetchAndActivate();
      AppConfig.updateFromFirebase(_instance);
      AppLogger.info(
          '⚙️ [REMOTE CONFIG] Đã cập nhật data Firebase vào AppConfig.instance.');
      return updated;
    } catch (e) {
      AppLogger.error('⚙️ [REMOTE CONFIG] Lỗi fetchAndActivate: $e');
      return false;
    }
  }
}
