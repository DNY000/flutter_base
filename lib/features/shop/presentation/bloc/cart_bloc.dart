/*
 * ==============================================================================
 * [CartBloc] - Quản Lý Giỏ Hàng Mua Sắm
 * ==============================================================================
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartCleared>(_onCartCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      final updatedList = List<CartItemEntity>.from(state.items);
      final current = updatedList[existingIndex];
      updatedList[existingIndex] = current.copyWith(
        quantity: current.quantity + event.quantity,
      );
      emit(state.copyWith(items: updatedList));
    } else {
      final newItem = CartItemEntity(
        product: event.product,
        quantity: event.quantity,
      );
      emit(state.copyWith(items: [...state.items, newItem]));
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedList = state.items.where(
      (item) => item.product.id != event.productId,
    ).toList();
    emit(state.copyWith(items: updatedList));
  }

  void _onQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) {
    final updatedList = <CartItemEntity>[];
    for (final item in state.items) {
      if (item.product.id == event.productId) {
        final newQuantity = item.quantity + event.delta;
        if (newQuantity > 0) {
          updatedList.add(item.copyWith(quantity: newQuantity));
        }
      } else {
        updatedList.add(item);
      }
    }
    emit(state.copyWith(items: updatedList));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
