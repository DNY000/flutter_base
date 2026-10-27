/*
 * ==============================================================================
 * [LocalStorage Test] - Kiểm Thử SharedPreferences Wrapper
 * ==============================================================================
 */

import 'package:base_project/core/storage/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ILocalStorage localStorage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'test_str': 'hello',
      'test_bool': true,
      'test_int': 42,
      'valid_obj': '{"id": 1, "name": "Antigravity"}',
      'corrupt_obj': '{invalid_json',
      'non_map_obj': '["item1", "item2"]',
    });
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorageImpl(prefs: prefs);
  });

  group('LocalStorageImpl', () {
    test('đọc các kiểu dữ liệu nguyên thủy chính xác', () {
      expect(localStorage.getString('test_str'), 'hello');
      expect(localStorage.getBool('test_bool'), isTrue);
      expect(localStorage.getInt('test_int'), 42);
      expect(localStorage.getString('non_existent'), isNull);
    });

    test('lưu và cập nhật dữ liệu nguyên thủy', () async {
      await localStorage.setString('new_key', 'new_val');
      expect(localStorage.getString('new_key'), 'new_val');

      await localStorage.setBool('is_dark', false);
      expect(localStorage.getBool('is_dark'), isFalse);

      await localStorage.setInt('count', 100);
      expect(localStorage.getInt('count'), 100);
    });

    test('getObject giải mã Map<String, dynamic> an toàn', () {
      final obj = localStorage.getObject('valid_obj');
      expect(obj, isNotNull);
      expect(obj!['id'], 1);
      expect(obj['name'], 'Antigravity');
    });

    test('getObject trả về null khi dữ liệu corrupt hoặc không phải map', () {
      expect(localStorage.getObject('corrupt_obj'), isNull);
      expect(localStorage.getObject('non_map_obj'), isNull);
      expect(localStorage.getObject('unknown_key'), isNull);
    });

    test('setObject serialize map thành JSON chính xác', () async {
      await localStorage
          .setObject('saved_obj', {'key': 'value', 'active': true});
      final retrieved = localStorage.getObject('saved_obj');
      expect(retrieved, isNotNull);
      expect(retrieved!['key'], 'value');
      expect(retrieved['active'], isTrue);
    });

    test('cấu hình theme, ngôn ngữ và first install', () async {
      expect(localStorage.getThemeMode(), 'system');
      await localStorage.setThemeMode('dark');
      expect(localStorage.getThemeMode(), 'dark');

      expect(localStorage.getLanguageCode(), 'vi');
      await localStorage.setLanguageCode('en');
      expect(localStorage.getLanguageCode(), 'en');

      expect(localStorage.isFirstInstall(), isTrue);
      await localStorage.setIsFirstInstall(false);
      expect(localStorage.isFirstInstall(), isFalse);
    });
  });
}
