/*
 * ==============================================================================
 * [ShopBlocTest] - Unit Test Cho ShopBloc
 * ==============================================================================
 */

import 'package:base_project/core/network/errors/failures.dart';
import 'package:base_project/features/shop/domain/entities/product_entity.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_event.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_helper.dart';

void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetProductDetailUseCase mockGetProductDetailUseCase;
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late ShopBloc shopBloc;

  const tProduct = ProductEntity(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'The Essence Mascara Lash Princess is a popular mascara.',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    brand: 'Essence',
    thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/thumbnail.png',
    images: ['https://cdn.dummyjson.com/products/images/beauty/1.png'],
  );

  const tProduct2 = ProductEntity(
    id: 2,
    title: 'Eyeshadow Palette',
    description: 'Glamour eyeshadow palette.',
    category: 'beauty',
    price: 19.99,
    discountPercentage: 10,
    rating: 4.5,
    stock: 15,
    brand: 'Glam',
    thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/thumbnail2.png',
    images: ['https://cdn.dummyjson.com/products/images/beauty/2.png'],
  );

  final tProducts = [tProduct];
  final tCategories = ['beauty', 'fragrances'];

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetProductDetailUseCase = MockGetProductDetailUseCase();
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();

    shopBloc = ShopBloc(
      getProductsUseCase: mockGetProductsUseCase,
      getProductDetailUseCase: mockGetProductDetailUseCase,
      searchProductsUseCase: mockSearchProductsUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  tearDown(() {
    shopBloc.close();
  });

  group('ShopBloc Test Suite', () {
    test('Trạng thái khởi tạo ban đầu của ShopBloc là ShopStatus.initial', () {
      expect(shopBloc.state.status, equals(ShopStatus.initial));
      expect(shopBloc.state.products, isEmpty);
      expect(shopBloc.state.hasReachedMax, isFalse);
      expect(shopBloc.state.isLoadingMore, isFalse);
    });

    blocTest<ShopBloc, ShopState>(
      'Phát ra [loading, success] khi ShopFetchProductsRequested thành công',
      build: () {
        when(() => mockGetCategoriesUseCase(forceRefresh: any(named: 'forceRefresh')))
            .thenAnswer((_) async => Right(tCategories));
        when(() => mockGetProductsUseCase(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              category: any(named: 'category'),
              forceRefresh: any(named: 'forceRefresh'),
            )).thenAnswer((_) async => Right(tProducts));
        return shopBloc;
      },
      act: (bloc) => bloc.add(const ShopFetchProductsRequested()),
      expect: () => [
        const ShopState(status: ShopStatus.loading),
        ShopState(
          status: ShopStatus.success,
          products: tProducts,
          hasReachedMax: true, // Vì 1 < 20
          categories: const ['All', 'beauty', 'fragrances', 'furniture', 'groceries'],
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'Phát ra [loading, failure] khi ShopFetchProductsRequested thất bại',
      build: () {
        when(() => mockGetCategoriesUseCase(forceRefresh: any(named: 'forceRefresh')))
            .thenAnswer((_) async => const Right([]));
        when(() => mockGetProductsUseCase(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              category: any(named: 'category'),
              forceRefresh: any(named: 'forceRefresh'),
            )).thenAnswer((_) async => const Left(ServerFailure(message: 'Lỗi tải sản phẩm')));
        return shopBloc;
      },
      act: (bloc) => bloc.add(const ShopFetchProductsRequested()),
      expect: () => [
        const ShopState(status: ShopStatus.loading),
        const ShopState(
          status: ShopStatus.failure,
          errorMessage: 'Lỗi tải sản phẩm',
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'Tải thêm sản phẩm thành công với ShopLoadMoreProductsRequested',
      build: () {
        when(() => mockGetProductsUseCase(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              category: any(named: 'category'),
            )).thenAnswer((_) async => const Right([tProduct2]));
        return shopBloc;
      },
      seed: () => ShopState(
        status: ShopStatus.success,
        products: [tProduct],
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(ShopLoadMoreProductsRequested()),
      expect: () => [
        ShopState(
          status: ShopStatus.success,
          products: [tProduct],
          isLoadingMore: true,
          hasReachedMax: false,
        ),
        ShopState(
          status: ShopStatus.success,
          products: [tProduct, tProduct2],
          isLoadingMore: false,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'Phát ra [loading, success] khi tìm kiếm sản phẩm với ShopSearchQueryChanged',
      build: () {
        when(() => mockSearchProductsUseCase('mascara'))
            .thenAnswer((_) async => Right(tProducts));
        return shopBloc;
      },
      act: (bloc) => bloc.add(const ShopSearchQueryChanged('mascara')),
      expect: () => [
        const ShopState(searchQuery: 'mascara'),
        const ShopState(status: ShopStatus.loading, searchQuery: 'mascara'),
        ShopState(
          status: ShopStatus.success,
          products: tProducts,
          searchQuery: 'mascara',
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'Phát ra [loading, success] khi lấy chi tiết sản phẩm ShopProductDetailRequested',
      build: () {
        when(() => mockGetProductDetailUseCase(1))
            .thenAnswer((_) async => const Right(tProduct));
        return shopBloc;
      },
      act: (bloc) => bloc.add(const ShopProductDetailRequested(1)),
      expect: () => [
        const ShopState(status: ShopStatus.loading),
        const ShopState(
          status: ShopStatus.success,
          selectedProduct: tProduct,
        ),
      ],
    );
  });
}
