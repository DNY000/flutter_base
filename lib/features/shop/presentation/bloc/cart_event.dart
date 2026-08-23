/*
 * ==============================================================================
 * [CartEvent] - Sự Kiện Của Giỏ Hàng CartBloc
 * ==============================================================================
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final ProductEntity product;
  final int quantity;

  const CartItemAdded(this.product, {this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

class CartItemRemoved extends CartEvent {
  final int productId;

  const CartItemRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemQuantityUpdated extends CartEvent {
  final int productId;
  final int delta; // +1 hoặc -1

  const CartItemQuantityUpdated(this.productId, this.delta);

  @override
  List<Object?> get props => [productId, delta];
}

class CartCleared extends CartEvent {}
