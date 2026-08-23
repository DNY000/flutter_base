/*
 * ==============================================================================
 * [Network Failures] - Các Lớp Thất Bại Nghiệp Vụ Chuẩn Hóa (Domain Layer)
 * ==============================================================================
 */

abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic data;

  const Failure({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Lỗi kết nối máy chủ, vui lòng thử lại sau',
    super.statusCode,
    super.data,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại',
    super.statusCode = 401,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Không có kết nối Internet, vui lòng kiểm tra mạng',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Lỗi truy xuất dữ liệu lưu trữ',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Dữ liệu đầu vào không hợp lệ',
    super.data,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Đã xảy ra lỗi không xác định',
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Đã xảy ra lỗi không mong muốn',
  });
}
