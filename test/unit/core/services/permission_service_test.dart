/*
 * ==============================================================================
 * [PermissionService Test] - Kiểm Thử Dịch Vụ Cấp Quyền Cơ Bản
 * ==============================================================================
 */

import 'package:base_project/core/services/permission_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late IPermissionService permissionService;

  setUp(() {
    permissionService = PermissionServiceImpl();
  });

  group('PermissionService Test', () {
    test('khởi tạo PermissionServiceImpl thành công', () {
      expect(permissionService, isA<IPermissionService>());
    });

    test('requestBasicPermissions trả về map rỗng khi không chọn quyền nào',
        () async {
      final res = await permissionService.requestBasicPermissions(
        includeNotification: false,
        includeLocation: false,
        includeCamera: false,
        includePhotos: false,
      );
      expect(res, isEmpty);
    });
  });
}
