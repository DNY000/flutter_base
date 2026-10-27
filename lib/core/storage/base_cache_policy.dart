/*
 * ==============================================================================
 * [BaseCachePolicy] - Chiến Lược Cache Dữ Liệu Tự Động & Hỗ Trợ Offline Mode
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Helper bọc các lệnh gọi API với cơ chế Cache First / Network First:
 *   1. Tự động trả về dữ liệu cache khi mất mạng (Offline Mode).
 *   2. Tự động làm mới cache khi có dữ liệu mới từ Server.
 *   3. Tiết kiệm băng thông và tối ưu tốc độ phản hồi người dùng.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Cache policy helper facilitating Network-First and Cache-Fallback strategies for offline mode.
 * ==============================================================================
 */

import '../network/errors/exceptions.dart';
import '../network/network_info.dart';
import '../utils/logger.dart';
import 'hive_storage.dart';

class BaseCachePolicy {
  final IHiveStorage _hiveStorage;
  final INetworkInfo _networkInfo;

  BaseCachePolicy({
    required IHiveStorage hiveStorage,
    required INetworkInfo networkInfo,
  })  : _hiveStorage = hiveStorage,
        _networkInfo = networkInfo;

  /// Thực thi tác vụ lấy dữ liệu kèm chính sách Cache:
  /// - Khi Online: Gọi `remoteCall`, lưu cache với `ttl`, trả về dữ liệu mới.
  /// - Khi Offline: Tự động fallback đọc cache từ Hive (kể cả khi đã hết hạn `ignoreExpiration: true`).
  /// - Khi `forceRefresh = true`: Bỏ qua cache, ép gọi Remote API.
  Future<T> fetchWithCache<T>({
    required String cacheKey,
    required Future<T> Function() remoteCall,
    required dynamic Function(T data) toJson,
    required T Function(dynamic json) fromJson,
    Duration ttl = const Duration(hours: 1),
    bool forceRefresh = false,
    String boxName = HiveStorageImpl.defaultBoxName,
  }) async {
    final isConnected = await _networkInfo.isConnected;

    // 1. Nếu không ép refresh và còn cache hợp lệ, có thể đọc ngay
    if (!forceRefresh && isConnected) {
      final cached = await _hiveStorage.get(cacheKey, boxName: boxName);
      if (cached != null) {
        try {
          return fromJson(cached);
        } catch (e) {
          AppLogger.w('Không thể giải mã dữ liệu cache cho key $cacheKey: $e');
        }
      }
    }

    Object? remoteError;
    StackTrace? remoteStackTrace;

    // 2. Khi có mạng: Gọi Remote API
    if (isConnected) {
      try {
        final remoteData = await remoteCall();
        // Lưu dữ liệu mới vào Hive cache
        await _hiveStorage.put(
          cacheKey,
          toJson(remoteData),
          ttl: ttl,
          boxName: boxName,
        );
        return remoteData;
      } catch (e, st) {
        remoteError = e;
        remoteStackTrace = st;
        AppLogger.warning(
            '🌐 [CACHE POLICY] Gọi API từ xa lỗi: $e. Thử đọc Offline Cache...');
      }
    }

    // 3. Khi mất mạng hoặc API lỗi: Đọc Offline Cache
    final offlineCached = await _hiveStorage.get(
      cacheKey,
      boxName: boxName,
      ignoreExpiration: true, // Chấp nhận lấy data cũ để hiển thị khi offline
    );

    if (offlineCached != null) {
      try {
        AppLogger.info(
            '📶 [OFFLINE MODE] Sử dụng dữ liệu lưu cục bộ từ Hive cho key: "$cacheKey"');
        return fromJson(offlineCached);
      } catch (e) {
        AppLogger.w('Không thể giải mã dữ liệu offline cache: $e');
      }
    }

    // 4. Nếu không có cache:
    // - Ném lại lỗi từ remoteCall nếu đã gọi trước đó (tránh duplicate call)
    // - Nếu mất mạng từ đầu, ném NetworkException ngay lập tức
    if (remoteError != null) {
      Error.throwWithStackTrace(
          remoteError, remoteStackTrace ?? StackTrace.current);
    }

    throw const NetworkException(
        'Không có kết nối mạng và không có dữ liệu ngoại tuyến.');
  }
}
