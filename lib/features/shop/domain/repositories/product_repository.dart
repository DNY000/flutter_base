/*
 * ==============================================================================
 * [ProductRepository] - Hợp Đồng Giao Tiếp Tầng Dữ Liệu Sản Phẩm
 * ==============================================================================
 */

import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
    String? category,
    bool forceRefresh = false,
  });

  Future<Either<Failure, ProductEntity>> getProductDetail(
    int id, {
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query, {
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<String>>> getCategories({
    bool forceRefresh = false,
  });
}
