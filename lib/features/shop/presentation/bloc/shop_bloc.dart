/*
 * ==============================================================================
 * [ShopBloc] - Quản Lý Luồng Dữ Liệu Cửa Hàng (BLoC 9)
 * ==============================================================================
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/shop_usecases.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailUseCase _getProductDetailUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  ShopBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetProductDetailUseCase getProductDetailUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getProductDetailUseCase = getProductDetailUseCase,
        _searchProductsUseCase = searchProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(const ShopState()) {
    on<ShopFetchProductsRequested>(_onFetchProducts);
    on<ShopCategorySelected>(_onCategorySelected);
    on<ShopSearchQueryChanged>(_onSearchQueryChanged);
    on<ShopProductDetailRequested>(_onProductDetailRequested);
    on<ShopLoadMoreProductsRequested>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
    ShopFetchProductsRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(
      status: ShopStatus.loading,
      hasReachedMax: false,
      isLoadingMore: false,
    ));

    // 1. Tải danh mục nếu danh sách chưa có
    if (state.categories.length <= 1) {
      final categoriesResult = await _getCategoriesUseCase(forceRefresh: event.forceRefresh);
      categoriesResult.fold(
        (_) => null,
        (cats) => emit(state.copyWith(categories: ['All', ...cats])),
      );
    }

    // 2. Tải sản phẩm theo Category hoặc toàn bộ
    final categoryFilter = (event.category != null && event.category != 'All')
        ? event.category
        : (state.selectedCategory != 'All' ? state.selectedCategory : null);

    final result = await _getProductsUseCase(
      limit: 20,
      skip: 0,
      category: categoryFilter,
      forceRefresh: event.forceRefresh,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ShopStatus.failure,
          errorMessage: failure.message,
        ));
        event.completer?.complete();
      },
      (products) {
        emit(state.copyWith(
          status: ShopStatus.success,
          products: products,
          hasReachedMax: products.length < 20,
          selectedCategory: event.category ?? state.selectedCategory,
        ));
        event.completer?.complete();
      },
    );
  }

  Future<void> _onLoadMoreProducts(
    ShopLoadMoreProductsRequested event,
    Emitter<ShopState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore || state.status == ShopStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final categoryFilter = state.selectedCategory != 'All' ? state.selectedCategory : null;
    final skip = state.products.length;
    const limit = 20;

    final result = await _getProductsUseCase(
      limit: limit,
      skip: skip,
      category: categoryFilter,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(state.copyWith(
            hasReachedMax: true,
            isLoadingMore: false,
          ));
        } else {
          emit(state.copyWith(
            products: [...state.products, ...newProducts],
            hasReachedMax: newProducts.length < limit,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> _onCategorySelected(
    ShopCategorySelected event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(selectedCategory: event.category, searchQuery: ''));
    add(ShopFetchProductsRequested(category: event.category));
  }

  Future<void> _onSearchQueryChanged(
    ShopSearchQueryChanged event,
    Emitter<ShopState> emit,
  ) async {
    final query = event.query.trim();
    emit(state.copyWith(searchQuery: query));

    if (query.isEmpty) {
      add(ShopFetchProductsRequested(category: state.selectedCategory));
      return;
    }

    emit(state.copyWith(status: ShopStatus.loading));
    final result = await _searchProductsUseCase(query);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ShopStatus.failure,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ShopStatus.success,
        products: products,
      )),
    );
  }

  Future<void> _onProductDetailRequested(
    ShopProductDetailRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(status: ShopStatus.loading));
    final result = await _getProductDetailUseCase(event.productId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ShopStatus.failure,
        errorMessage: failure.message,
      )),
      (product) => emit(state.copyWith(
        status: ShopStatus.success,
        selectedProduct: product,
      )),
    );
  }
}
