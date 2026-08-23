/*
 * ==============================================================================
 * [CartState] - Trạng Thái Giỏ Hàng
 * ==============================================================================
 */

import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotalVND => items.fold(0.0, (sum, item) => sum + item.totalPriceInVND);

  double get shippingFeeVND => items.isEmpty ? 0.0 : 30000.0;

  double get totalVND => subtotalVND + shippingFeeVND;

  CartState copyWith({List<CartItemEntity>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
