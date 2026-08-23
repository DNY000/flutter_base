/*
 * ==============================================================================
 * [ShopEvent] - Sự Kiện Của ShopBloc
 * ==============================================================================
 */

import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class ShopFetchProductsRequested extends ShopEvent {
  final String? category;
  final bool forceRefresh;
  final Completer<void>? completer;

  const ShopFetchProductsRequested({
    this.category,
    this.forceRefresh = false,
    this.completer,
  });

  @override
  List<Object?> get props => [category, forceRefresh];
}

class ShopSearchQueryChanged extends ShopEvent {
  final String query;

  const ShopSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ShopCategorySelected extends ShopEvent {
  final String category;

  const ShopCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class ShopProductDetailRequested extends ShopEvent {
  final int productId;

  const ShopProductDetailRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ShopLoadMoreProductsRequested extends ShopEvent {}
