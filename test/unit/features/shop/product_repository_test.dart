/*
 * ==============================================================================
 * [ProductRepository Test] - Kiểm Thử Repository Sản Phẩm (Online / Offline / Failures)
 * ==============================================================================
 */

import 'package:base_project/core/network/errors/exceptions.dart';
import 'package:base_project/core/network/errors/failures.dart';
import 'package:base_project/core/storage/base_cache_policy.dart';
import 'package:base_project/features/shop/data/models/product_model.dart';
import 'package:base_project/features/shop/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockShopRemoteDataSource mockRemoteDataSource;
  late MockHiveStorage mockHiveStorage;
  late MockNetworkInfo mockNetworkInfo;
  late BaseCachePolicy cachePolicy;
  late ProductRepositoryImpl repository;

  const tProductModel = ProductModel(
    id: 1,
    title: 'iPhone 15',
    description: 'Apple Flagship Smartphone',
    category: 'smartphones',
    price: 999.0,
    discountPercentage: 5.0,
    rating: 4.9,
    stock: 100,
    brand: 'Apple',
    thumbnail: 'https://example.com/thumb.jpg',
    images: ['https://example.com/1.jpg'],
  );

  setUp(() {
    mockRemoteDataSource = MockShopRemoteDataSource();
    mockHiveStorage = MockHiveStorage();
    mockNetworkInfo = MockNetworkInfo();

    cachePolicy = BaseCachePolicy(
      hiveStorage: mockHiveStorage,
      networkInfo: mockNetworkInfo,
    );

    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      cachePolicy: cachePolicy,
    );

    when(() => mockHiveStorage.put(
          any<String>(),
          any<dynamic>(),
          ttl: any(named: 'ttl'),
          boxName: any(named: 'boxName'),
        )).thenAnswer((_) async {});
  });

  group('ProductRepositoryImpl - getProducts', () {
    test(
        'trả về Right(List<ProductEntity>) khi kết nối mạng và fetch thành công',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.fetchProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
            category: any(named: 'category'),
          )).thenAnswer((_) async => [tProductModel]);

      final result = await repository.getProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (products) => expect(products.first.id, 1),
      );
    });

    test('trả về Left(ServerFailure) khi RemoteDataSource ném ServerException',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.fetchProducts(
                limit: any(named: 'limit'),
                skip: any(named: 'skip'),
                category: any(named: 'category'),
              ))
          .thenThrow(
              const ServerException(message: 'Server error', statusCode: 500));

      final result = await repository.getProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        },
        (_) => fail('Should fail with ServerFailure'),
      );
    });

    test('trả về Left(NetworkFailure) khi mất mạng và không có cache',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);

      final result = await repository.getProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should fail with NetworkFailure'),
      );
    });
  });

  group('ProductRepositoryImpl - getProductDetail', () {
    test('trả về Right(ProductEntity) khi lấy chi tiết sản phẩm thành công',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.fetchProductDetail(1))
          .thenAnswer((_) async => tProductModel);

      final result = await repository.getProductDetail(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (product) => expect(product.title, 'iPhone 15'),
      );
    });

    test('trả về Left(NetworkFailure) khi mất mạng và không có cache chi tiết',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);

      final result = await repository.getProductDetail(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should fail with NetworkFailure'),
      );
    });
  });

  group('ProductRepositoryImpl - getCategories', () {
    test('trả về danh sách categories mặc định dự phòng khi có ngoại lệ',
        () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHiveStorage.get(
            any(),
            boxName: any(named: 'boxName'),
            ignoreExpiration: any(named: 'ignoreExpiration'),
          )).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.fetchCategories())
          .thenThrow(const ServerException(message: 'Categories failed'));

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should fallback gracefully'),
        (categories) => expect(categories, contains('beauty')),
      );
    });
  });
}
