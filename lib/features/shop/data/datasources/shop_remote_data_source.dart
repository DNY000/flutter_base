/*
 * ==============================================================================
 * [ShopRemoteDataSource] - Nguồn Dữ Liệu Gọi API Từ Xa (DummyJSON Public API)
 * ==============================================================================
 */

import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/errors/exceptions.dart';
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
  static const String _apiBase = 'https://dummyjson.com';

  ShopRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> fetchProducts({
    int limit = 20,
    int skip = 0,
    String? category,
  }) async {
    try {
      final path = category != null && category.isNotEmpty && category != 'All'
          ? '$_apiBase/products/category/$category?limit=$limit&skip=$skip'
          : '$_apiBase/products?limit=$limit&skip=$skip';

      final response = await _dioClient.dio.get<Map<String, dynamic>>(path);
      final data = response.data;
      if (data == null || data['products'] == null) return [];

      final list = data['products'] as List<dynamic>;
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi khi tải danh sách sản phẩm từ máy chủ.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> fetchProductDetail(int id) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>('$_apiBase/products/$id');
      if (response.data == null) {
        throw const ServerException(message: 'Không tìm thấy thông tin sản phẩm.');
      }
      return ProductModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi khi tải chi tiết sản phẩm.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '$_apiBase/products/search',
        queryParameters: {'q': query},
      );
      final data = response.data;
      if (data == null || data['products'] == null) return [];

      final list = data['products'] as List<dynamic>;
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi khi tìm kiếm sản phẩm.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final response = await _dioClient.dio.get<dynamic>('$_apiBase/products/category-list');
      if (response.data is List) {
        return (response.data as List).map((e) => e.toString()).toList();
      }
      return ['beauty', 'fragrances', 'furniture', 'groceries'];
    } catch (_) {
      return ['beauty', 'fragrances', 'furniture', 'groceries'];
    }
  }
}
