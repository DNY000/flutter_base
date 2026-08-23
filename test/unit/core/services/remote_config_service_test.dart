/*
 * ==============================================================================
 * [RemoteConfig & AppConfig Test] - Kiểm Thử Cấu Hình Toàn Cục & Remote Config
 * ==============================================================================
 */

import 'package:base_project/core/config/app_config.dart';
import 'package:base_project/core/services/remote_config_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RemoteConfigServiceImpl remoteConfigService;

  setUp(() {
    AppConfig.init(environment: Environment.dev);
    remoteConfigService = RemoteConfigServiceImpl(isDebug: true);
  });

  group('AppConfig & RemoteConfigService', () {
    test('AppConfig chứa đầy đủ các thuộc tính môi trường và remote config', () {
      final config = AppConfig.instance;

      expect(config.environment, Environment.dev);
      expect(config.appName, 'Base App [DEV]');
      expect(config.minAppVersion, '1.0.0');
      expect(config.isForceUpdateRequired, isFalse);
      expect(config.isMaintenanceMode, isFalse);
      expect(config.maintenanceMessage.isNotEmpty, isTrue);
      expect(config.supportHotline, '1900 6868');
      expect(config.apiTimeoutSeconds, 30);
      expect(config.enablePromoBanner, isTrue);
    });

    test('toDefaultsMap tạo đúng map cấu hình cho Firebase setDefaults', () {
      final map = AppConfig.instance.toDefaultsMap();

      expect(map['app_environment'], 'dev');
      expect(map['min_app_version'], '1.0.0');
      expect(map['force_update_required'], isFalse);
      expect(map['is_maintenance_mode'], isFalse);
    });
  });
}
