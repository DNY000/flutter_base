import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import 'errors/exceptions.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required ISecureStorage secureStorage, Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: ApiEndpoints.connectTimeout,
            receiveTimeout: ApiEndpoints.receiveTimeout,
            sendTimeout: ApiEndpoints.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    // Interceptor: Auth & Token Refresh
    _dio.interceptors.add(
      AuthInterceptor(secureStorage: secureStorage, dio: _dio),
    );

    // Interceptor: Logger (Chỉ bật khi Debug)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Dio get instance => _dio;
  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required File file,
    required String fileKey,
    Map<String, dynamic>? extraData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        ...?extraData,
        fileKey: await MultipartFile.fromFile(file.path, filename: fileName),
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Kết nối quá thời gian chờ. Vui lòng kiểm tra lại mạng.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        String errorMessage = 'Đã xảy ra lỗi từ máy chủ.';
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              errorMessage;
        }

        if (statusCode == 401) {
          return UnauthorizedException(errorMessage);
        }

        return ServerException(
          message: errorMessage,
          statusCode: statusCode,
          errorData: responseData,
        );

      case DioExceptionType.cancel:
        return const ServerException(message: 'Yêu cầu đã bị hủy bỏ.');

      default:
        return ServerException(
          message: error.message ?? 'Đã xảy ra lỗi không xác định.',
        );
    }
  }
}
