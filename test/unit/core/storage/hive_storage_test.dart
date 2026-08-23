/*
 * ==============================================================================
 * [HiveStorage & BaseCachePolicy Test] - Kiểm Thử Cache Entry & Offline Policy
 * ==============================================================================
 */

import 'package:base_project/core/network/network_info.dart';
import 'package:base_project/core/storage/base_cache_policy.dart';
import 'package:base_project/core/storage/hive_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheEntry Test', () {
    test('CacheEntry kiểm tra hết hạn chính xác theo thời gian', () {
      final now = DateTime.now();
      final expiredEntry = CacheEntry(
        data: {'name': 'John'},
        cachedAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.subtract(const Duration(minutes: 1)),
      );

      final validEntry = CacheEntry(
        data: {'name': 'Jane'},
        cachedAt: now,
        expiresAt: now.add(const Duration(hours: 1)),
      );

      expect(expiredEntry.isExpired, isTrue);
      expect(validEntry.isExpired, isFalse);
    });

    test('CacheEntry toMap và fromMap bảo toàn dữ liệu', () {
      final entry = CacheEntry(
        data: 'cached_string_data',
        cachedAt: DateTime(2026, 1, 1, 10, 0),
        expiresAt: DateTime(2026, 1, 1, 11, 0),
      );

      final map = entry.toMap();
      final restored = CacheEntry.fromMap(map);

      expect(restored.data, 'cached_string_data');
      expect(restored.cachedAt, DateTime(2026, 1, 1, 10, 0));
      expect(restored.expiresAt, DateTime(2026, 1, 1, 11, 0));
    });
  });

  group('BaseCachePolicy Test', () {
    late MockHiveStorage mockHiveStorage;
    late MockNetworkInfo mockNetworkInfo;
    late BaseCachePolicy cachePolicy;

    setUp(() {
      mockHiveStorage = MockHiveStorage();
      mockNetworkInfo = MockNetworkInfo();
      cachePolicy = BaseCachePolicy(
        hiveStorage: mockHiveStorage,
        networkInfo: mockNetworkInfo,
      );
    });

    test('khi mất mạng (Offline), tự động lấy dữ liệu từ Hive cache fallback', () async {
      // Giả lập mất mạng
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockHiveStorage.get(
            'user_profile',
            boxName: any(named: 'boxName'),
            ignoreExpiration: true,
          )).thenAnswer((_) async => {'id': '123', 'name': 'Offline User'});

      final result = await cachePolicy.fetchWithCache<Map<String, dynamic>>(
        cacheKey: 'user_profile',
        remoteCall: () async => {'id': '123', 'name': 'Remote User'},
        toJson: (data) => data,
        fromJson: (json) => Map<String, dynamic>.from(json as Map),
      );

      expect(result['name'], 'Offline User');
      verify(() => mockHiveStorage.get(
            'user_profile',
            boxName: any(named: 'boxName'),
            ignoreExpiration: true,
          )).called(1);
    });
  });
}
