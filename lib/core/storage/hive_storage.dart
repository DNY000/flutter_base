/*
 * ==============================================================================
 * [HiveStorage / HiveCacheService] - Bộ Quản Lý Cache Cục Bộ & Offline Mode Siêu Tốc (Hive CE)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Thư viện chính: `hive_ce` và `hive_ce_flutter` (Cộng đồng Hive CE duy trì, hiệu năng NoSQL cực cao).
 * - Tính năng:
 *   1. Quản lý Cache dữ liệu API kèm thời gian sống (TTL - Time To Live / Expiration).
 *   2. Hỗ trợ chế độ ngoại tuyến (**Offline First / Offline Mode**): Đọc dữ liệu đã cache khi mất mạng.
 *   3. Chiến lược **Stale-While-Revalidate**: Cho phép đọc dữ liệu cũ hiển thị ngay lập tức trong khi gọi API ngầm.
 *   4. Tự động dọn dẹp các bản ghi cache đã hết hạn (`clearExpired`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: High-performance NoSQL local caching service powered by Hive CE with TTL and offline-mode support.
 * ==============================================================================
 */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../utils/logger.dart';

/// Đối tượng bọc dữ liệu kèm thông tin thời gian hết hạn TTL
class CacheEntry {
  final dynamic data;
  final DateTime cachedAt;
  final DateTime? expiresAt;

  const CacheEntry({
    required this.data,
    required this.cachedAt,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toMap() => {
        'data': data,
        'cachedAt': cachedAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
      };

  factory CacheEntry.fromMap(Map<dynamic, dynamic> map) {
    return CacheEntry(
      data: map['data'],
      cachedAt: DateTime.parse(map['cachedAt'] as String),
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
    );
  }
}

abstract class IHiveStorage {
  Future<void> initialize();
  
  /// Lưu dữ liệu vào cache kèm thời gian sống TTL tùy chọn (Ví dụ: Duration(hours: 2))
  Future<void> put(
    String key,
    dynamic value, {
    Duration? ttl,
    String boxName = HiveStorageImpl.defaultBoxName,
  });

  /// Lấy dữ liệu từ cache.
  /// [ignoreExpiration] = true: Cho phép lấy data dù đã hết hạn (phục vụ Offline Mode / Stale-While-Revalidate).
  Future<dynamic> get(
    String key, {
    String boxName = HiveStorageImpl.defaultBoxName,
    bool ignoreExpiration = false,
  });

  /// Lấy dữ liệu dạng JSON Map
  Future<Map<String, dynamic>?> getJsonMap(
    String key, {
    String boxName = HiveStorageImpl.defaultBoxName,
    bool ignoreExpiration = false,
  });

  /// Lấy dữ liệu dạng JSON List
  Future<List<dynamic>?> getJsonList(
    String key, {
    String boxName = HiveStorageImpl.defaultBoxName,
    bool ignoreExpiration = false,
  });

  /// Kiểm tra key có tồn tại và còn hạn sử dụng không
  Future<bool> has(
    String key, {
    String boxName = HiveStorageImpl.defaultBoxName,
  });

  /// Xóa key cụ thể khỏi box
  Future<void> delete(
    String key, {
    String boxName = HiveStorageImpl.defaultBoxName,
  });

  /// Xóa toàn bộ dữ liệu trong box
  Future<void> clear({
    String boxName = HiveStorageImpl.defaultBoxName,
  });

  /// Dọn dẹp toàn bộ các bản ghi đã quá hạn TTL trong box
  Future<void> clearExpired({
    String boxName = HiveStorageImpl.defaultBoxName,
  });
}

class HiveStorageImpl implements IHiveStorage {
  static const String defaultBoxName = 'app_data_cache';
  final Map<String, Box<dynamic>> _openBoxes = {};

  @override
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      await _getBox(defaultBoxName);
      AppLogger.info('📦 [HIVE STORAGE] Khởi tạo Hive CE thành công.');
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi khởi tạo Hive CE: $e');
    }
  }

  Future<Box<dynamic>> _getBox(String boxName) async {
    if (_openBoxes.containsKey(boxName) && _openBoxes[boxName]!.isOpen) {
      return _openBoxes[boxName]!;
    }
    final box = await Hive.openBox<dynamic>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  @override
  Future<void> put(
    String key,
    dynamic value, {
    Duration? ttl,
    String boxName = defaultBoxName,
  }) async {
    try {
      final box = await _getBox(boxName);
      final now = DateTime.now();
      final expiresAt = ttl != null ? now.add(ttl) : null;

      final entry = CacheEntry(
        data: value,
        cachedAt: now,
        expiresAt: expiresAt,
      );

      await box.put(key, entry.toMap());
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi khi ghi cache key "$key": $e');
    }
  }

  @override
  Future<dynamic> get(
    String key, {
    String boxName = defaultBoxName,
    bool ignoreExpiration = false,
  }) async {
    try {
      final box = await _getBox(boxName);
      final raw = box.get(key);
      if (raw == null) return null;

      if (raw is Map) {
        final entry = CacheEntry.fromMap(raw);
        if (!ignoreExpiration && entry.isExpired) {
          // Tự động xóa nếu đã hết hạn và không yêu cầu ignore
          await box.delete(key);
          return null;
        }
        return entry.data;
      }
      return raw;
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi khi đọc cache key "$key": $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getJsonMap(
    String key, {
    String boxName = defaultBoxName,
    bool ignoreExpiration = false,
  }) async {
    final res = await get(key, boxName: boxName, ignoreExpiration: ignoreExpiration);
    if (res is Map<String, dynamic>) return res;
    if (res is Map) return Map<String, dynamic>.from(res);
    if (res is String) {
      try {
        final decoded = jsonDecode(res);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<List<dynamic>?> getJsonList(
    String key, {
    String boxName = defaultBoxName,
    bool ignoreExpiration = false,
  }) async {
    final res = await get(key, boxName: boxName, ignoreExpiration: ignoreExpiration);
    if (res is List) return res;
    if (res is String) {
      try {
        final decoded = jsonDecode(res);
        if (decoded is List) return decoded;
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<bool> has(
    String key, {
    String boxName = defaultBoxName,
  }) async {
    final value = await get(key, boxName: boxName, ignoreExpiration: false);
    return value != null;
  }

  @override
  Future<void> delete(
    String key, {
    String boxName = defaultBoxName,
  }) async {
    try {
      final box = await _getBox(boxName);
      await box.delete(key);
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi khi xóa key "$key": $e');
    }
  }

  @override
  Future<void> clear({
    String boxName = defaultBoxName,
  }) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi khi xóa box "$boxName": $e');
    }
  }

  @override
  Future<void> clearExpired({
    String boxName = defaultBoxName,
  }) async {
    try {
      final box = await _getBox(boxName);
      final keysToDelete = <dynamic>[];

      for (final key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          final entry = CacheEntry.fromMap(raw);
          if (entry.isExpired) {
            keysToDelete.add(key);
          }
        }
      }

      if (keysToDelete.isNotEmpty) {
        await box.deleteAll(keysToDelete);
        AppLogger.info('📦 [HIVE STORAGE] Đã dọn dẹp ${keysToDelete.length} bản ghi cache hết hạn.');
      }
    } catch (e) {
      AppLogger.error('📦 [HIVE STORAGE] Lỗi dọn dẹp cache hết hạn: $e');
    }
  }
}
