/*
 * ==============================================================================
 * [ShopUseCases] - Các Nghiệp Vụ Tương Tác Cửa Hàng & Sản Phẩm
 * ==============================================================================
 */

import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;
  GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int limit = 20,
    int skip = 0,
    String? category,
    bool forceRefresh = false,
  }) {
    return _repository.getProducts(
      limit: limit,
      skip: skip,
      category: category,
      forceRefresh: forceRefresh,
    );
  }
}

class GetProductDetailUseCase {
  final ProductRepository _repository;
  GetProductDetailUseCase(this._repository);

  Future<Either<Failure, ProductEntity>> call(int id,
      {bool forceRefresh = false}) {
    return _repository.getProductDetail(id, forceRefresh: forceRefresh);
  }
}

class SearchProductsUseCase {
  final ProductRepository _repository;
  SearchProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call(String query,
      {bool forceRefresh = false}) {
    return _repository.searchProducts(query, forceRefresh: forceRefresh);
  }
}

class GetCategoriesUseCase {
  final ProductRepository _repository;
  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<String>>> call({bool forceRefresh = false}) {
    return _repository.getCategories(forceRefresh: forceRefresh);
  }
}
