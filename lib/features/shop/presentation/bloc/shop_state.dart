/*
 * ==============================================================================
 * [ShopState] - Trạng Thái Của ShopBloc
 * ==============================================================================
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

enum ShopStatus { initial, loading, success, failure }

class ShopState extends Equatable {
  final ShopStatus status;
  final List<ProductEntity> products;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final ProductEntity? selectedProduct;
  final String? errorMessage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ShopState({
    this.status = ShopStatus.initial,
    this.products = const [],
    this.categories = const [
      'All',
      'beauty',
      'fragrances',
      'furniture',
      'groceries'
    ],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.selectedProduct,
    this.errorMessage,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ShopState copyWith({
    ShopStatus? status,
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    ProductEntity? selectedProduct,
    String? errorMessage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ShopState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        categories,
        selectedCategory,
        searchQuery,
        selectedProduct,
        errorMessage,
        hasReachedMax,
        isLoadingMore,
      ];
}
