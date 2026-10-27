import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'api_endpoints.dart';

class AuthInterceptor extends QueuedInterceptor {
  final ISecureStorage _secureStorage;
  final Dio _dio;

  AuthInterceptor({
    required ISecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Không đính kèm token cho các endpoint public
    if (options.path.contains(ApiEndpoints.login) ||
        options.path.contains(ApiEndpoints.register) ||
        options.path.contains(ApiEndpoints.refreshToken)) {
      return handler.next(options);
    }

    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    final isPublicPath = path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.register) ||
        path.contains(ApiEndpoints.refreshToken);

    // Không kích hoạt refresh token nếu request bị 401 là public route (vd: nhập sai mật khẩu khi login)
    if (err.response?.statusCode == 401 && !isPublicPath) {
      AppLogger.w(
          '401 Unauthorized detected on protected route ($path). Attempting to refresh token...');
      final refreshToken = await _secureStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final refreshDio = Dio(
            BaseOptions(
              baseUrl: AppConfig.instance.apiBaseUrl,
              connectTimeout: ApiEndpoints.connectTimeout,
              receiveTimeout: ApiEndpoints.receiveTimeout,
              sendTimeout: ApiEndpoints.sendTimeout,
              headers: {'Content-Type': 'application/json'},
            ),
          );

          final response = await refreshDio.post<Map<String, dynamic>>(
            ApiEndpoints.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final resMap = response.data!;
            final dataMap = resMap['data'] is Map
                ? Map<String, dynamic>.from(resMap['data'] as Map)
                : null;
            final newAccessToken = dataMap?['accessToken']?.toString() ??
                resMap['accessToken']?.toString();
            final newRefreshToken = dataMap?['refreshToken']?.toString() ??
                resMap['refreshToken']?.toString();

            if (newAccessToken != null) {
              await _secureStorage.saveAccessToken(newAccessToken);
              if (newRefreshToken != null) {
                await _secureStorage.saveRefreshToken(newRefreshToken);
              }

              // Cập nhật lại header của request ban đầu và retry
              final reqOptions = err.requestOptions;
              reqOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await _dio.fetch<dynamic>(reqOptions);
              return handler.resolve(retryResponse);
            }
          }
        } catch (e) {
          AppLogger.e('Failed to refresh token: $e');
          await _secureStorage.clearAll();
        }
      } else {
        await _secureStorage.clearAll();
      }
    }

    return handler.next(err);
  }
}
