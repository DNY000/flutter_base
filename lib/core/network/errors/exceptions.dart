/*
 * ==============================================================================
 * [Network Exceptions] - Các Lớp Ngoại Lệ Mạng & Hệ Thống (Data Layer)
 * ==============================================================================
 */

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const ServerException({
    this.message = 'Đã có lỗi xảy ra từ máy chủ',
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Phiên đăng nhập đã hết hạn']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Không có kết nối mạng']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Lỗi lưu trữ dữ liệu cục bộ']);

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Dữ liệu không hợp lệ']);

  @override
  String toString() => 'ValidationException: $message';
}

class UnknownException implements Exception {
  final String message;
  const UnknownException([this.message = 'Lỗi không xác định']);

  @override
  String toString() => 'UnknownException: $message';
}
