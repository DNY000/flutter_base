/*
 * ==============================================================================
 * [ProductRepositoryImpl] - Thực Thi Repository Sản Phẩm Kèm Cơ Chế Caching
 * ==============================================================================
 */

import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/exceptions.dart';
import '../../../../core/network/errors/failures.dart';
import '../../../../core/storage/base_cache_policy.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/shop_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ShopRemoteDataSource _remoteDataSource;
  final BaseCachePolicy _cachePolicy;

  ProductRepositoryImpl({
    required ShopRemoteDataSource remoteDataSource,
    required BaseCachePolicy cachePolicy,
  })  : _remoteDataSource = remoteDataSource,
        _cachePolicy = cachePolicy;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
    String? category,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'CACHE_PRODUCTS_${category ?? 'ALL'}_${limit}_$skip';
    try {
      final products = await _cachePolicy.fetchWithCache<List<ProductModel>>(
        cacheKey: cacheKey,
        ttl: const Duration(hours: 1),
        forceRefresh: forceRefresh,
        remoteCall: () => _remoteDataSource.fetchProducts(
          limit: limit,
          skip: skip,
          category: category,
        ),
        toJson: (list) => list.map((e) => e.toJson()).toList(),
        fromJson: (json) => (json as List)
            .map((e) =>
                ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetail(
    int id, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'CACHE_PRODUCT_DETAIL_$id';
    try {
      final product = await _cachePolicy.fetchWithCache<ProductModel>(
        cacheKey: cacheKey,
        ttl: const Duration(hours: 2),
        forceRefresh: forceRefresh,
        remoteCall: () => _remoteDataSource.fetchProductDetail(id),
        toJson: (data) => data.toJson(),
        fromJson: (json) =>
            ProductModel.fromJson(Map<String, dynamic>.from(json as Map)),
      );
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'CACHE_SEARCH_${query.trim().toLowerCase()}';
    try {
      final products = await _cachePolicy.fetchWithCache<List<ProductModel>>(
        cacheKey: cacheKey,
        ttl: const Duration(minutes: 30),
        forceRefresh: forceRefresh,
        remoteCall: () => _remoteDataSource.searchProducts(query),
        toJson: (list) => list.map((e) => e.toJson()).toList(),
        fromJson: (json) => (json as List)
            .map((e) =>
                ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'CACHE_CATEGORIES_LIST';
    try {
      final categories = await _cachePolicy.fetchWithCache<List<String>>(
        cacheKey: cacheKey,
        ttl: const Duration(days: 1),
        forceRefresh: forceRefresh,
        remoteCall: () => _remoteDataSource.fetchCategories(),
        toJson: (list) => list,
        fromJson: (json) => (json as List).map((e) => e.toString()).toList(),
      );
      return Right(categories);
    } catch (e) {
      AppLogger.w(
          'Failed to fetch categories, falling back to default categories: $e');
      return const Right(['beauty', 'fragrances', 'furniture', 'groceries']);
    }
  }
}
