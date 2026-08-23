class ApiResponse<T> {
  final bool success;
  final String? message;
  final String? errorCode;
  final T? data;
  final PaginationMeta? meta;

  const ApiResponse({
    required this.success,
    this.message,
    this.errorCode,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalItems;

  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalItems: json['totalItems'] as int? ?? 0,
    );
  }
}
