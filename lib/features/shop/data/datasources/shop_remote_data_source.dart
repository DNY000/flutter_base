/*
 * ==============================================================================
 * [ShopRemoteDataSource] - Nguồn Dữ Liệu Gọi API Từ Xa (DummyJSON Public API)
 * ==============================================================================
 */

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/product_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ProductModel>> fetchProducts({
    int limit = 20,
    int skip = 0,
    String? category,
  });

  Future<ProductModel> fetchProductDetail(int id);

  Future<List<ProductModel>> searchProducts(String query);

  Future<List<String>> fetchCategories();
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final DioClient _dioClient;

  ShopRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> fetchProducts({
    int limit = 20,
    int skip = 0,
    String? category,
  }) async {
    final path = category != null && category.isNotEmpty && category != 'All'
        ? '${ApiEndpoints.shopBaseUrl}/products/category/$category?limit=$limit&skip=$skip'
        : '${ApiEndpoints.shopBaseUrl}/products?limit=$limit&skip=$skip';

    final response = await _dioClient.get<Map<String, dynamic>>(path);
    final data = response.data;
    if (data == null || data['products'] == null) return [];

    final list = data['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> fetchProductDetail(int id) async {
    final response = await _dioClient
        .get<Map<String, dynamic>>('${ApiEndpoints.shopBaseUrl}/products/$id');
    if (response.data == null) {
      throw const ServerException(
          message: 'Không tìm thấy thông tin sản phẩm.');
    }
    return ProductModel.fromJson(response.data!);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.shopBaseUrl}/products/search',
      queryParameters: {'q': query},
    );
    final data = response.data;
    if (data == null || data['products'] == null) return [];

    final list = data['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final response =
          await _dioClient.get<dynamic>(ApiEndpoints.shopCategories);
      if (response.data is List) {
        return (response.data as List).map((e) => e.toString()).toList();
      }
      return ['beauty', 'fragrances', 'furniture', 'groceries'];
    } catch (e) {
      AppLogger.w(
          'Không thể tải danh mục sản phẩm từ xa ($e), sử dụng danh mục dự phòng');
      return ['beauty', 'fragrances', 'furniture', 'groceries'];
    }
  }
}
