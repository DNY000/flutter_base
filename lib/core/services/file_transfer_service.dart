/*
 * ==============================================================================
 * [FileTransferService] - Dịch Vụ Tải Xuống (Download) & Tải Lên (Upload) Tệp
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng:
 *   1. Tải tệp từ máy chủ về thiết bị kèm callback % tiến độ (`onProgress`).
 *   2. Tải tệp lên máy chủ dạng Multipart kèm callback % tiến độ (`onProgress`).
 *   3. Hỗ trợ hủy luồng (`CancelToken`).
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Service for uploading and downloading files with transfer progress tracking.
 * ==============================================================================
 */

import 'dart:io';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/errors/exceptions.dart';
import '../utils/logger.dart';

typedef TransferProgressCallback = void Function(int count, int total, double percentage);

abstract class IFileTransferService {
  Future<File> downloadFile({
    required String url,
    required String savePath,
    TransferProgressCallback? onProgress,
    CancelToken? cancelToken,
  });

  Future<dynamic> uploadFile({
    required String url,
    required File file,
    String fileFieldName = 'file',
    Map<String, dynamic>? extraFields,
    TransferProgressCallback? onProgress,
    CancelToken? cancelToken,
  });
}

class FileTransferServiceImpl implements IFileTransferService {
  final DioClient _dioClient;

  FileTransferServiceImpl(this._dioClient);

  @override
  Future<File> downloadFile({
    required String url,
    required String savePath,
    TransferProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      AppLogger.info('⬇️ [DOWNLOAD] Bắt đầu tải tệp: $url -> $savePath');
      await _dioClient.dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int received, int total) {
          if (total > 0 && onProgress != null) {
            final percentage = (received / total) * 100;
            onProgress(received, total, percentage);
          }
        },
      );
      return File(savePath);
    } on DioException catch (e) {
      AppLogger.error('Lỗi khi tải tệp: ${e.message}');
      throw ServerException(message: 'Tải tệp thất bại: ${e.message}', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<dynamic> uploadFile({
    required String url,
    required File file,
    String fileFieldName = 'file',
    Map<String, dynamic>? extraFields,
    TransferProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      AppLogger.info('⬆️ [UPLOAD] Bắt đầu tải lên: $fileName -> $url');

      final formDataMap = <String, dynamic>{
        fileFieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?extraFields,
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dioClient.dio.post<dynamic>(
        url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (int sent, int total) {
          if (total > 0 && onProgress != null) {
            final percentage = (sent / total) * 100;
            onProgress(sent, total, percentage);
          }
        },
      );

      return response.data;
    } on DioException catch (e) {
      AppLogger.error('Lỗi khi tải tệp lên: ${e.message}');
      throw ServerException(message: 'Tải tệp lên thất bại: ${e.message}', statusCode: e.response?.statusCode);
    }
  }
}
