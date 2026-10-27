/*
 * ==============================================================================
 * [CartBlocTest] - Unit Test Cho CartBloc
 * ==============================================================================
 */

import 'package:base_project/features/shop/domain/entities/product_entity.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_bloc.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_event.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartBloc cartBloc;

  const tProduct1 = ProductEntity(
    id: 1,
    title: 'Product 1',
    description: 'Description 1',
    category: 'beauty',
    price: 10.0,
    discountPercentage: 0,
    rating: 4.5,
    stock: 20,
    brand: 'Brand 1',
    thumbnail: 'https://example.com/1.png',
    images: ['https://example.com/1.png'],
  );

  const tProduct2 = ProductEntity(
    id: 2,
    title: 'Product 2',
    description: 'Description 2',
    category: 'furniture',
    price: 50.0,
    discountPercentage: 0,
    rating: 4.8,
    stock: 10,
    brand: 'Brand 2',
    thumbnail: 'https://example.com/2.png',
    images: ['https://example.com/2.png'],
  );

  setUp(() {
    cartBloc = CartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc Test Suite', () {
    test('Khởi tạo ban đầu giỏ hàng rỗng', () {
      expect(cartBloc.state.items, isEmpty);
      expect(cartBloc.state.totalItemCount, equals(0));
      expect(cartBloc.state.subtotalVND, equals(0.0));
      expect(cartBloc.state.totalVND, equals(0.0));
    });

    blocTest<CartBloc, CartState>(
      'Thêm sản phẩm mới vào giỏ hàng với CartItemAdded',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const CartItemAdded(tProduct1, quantity: 2)),
      expect: () => [
        const CartState(
            items: [CartItemEntity(product: tProduct1, quantity: 2)]),
      ],
      verify: (bloc) {
        expect(bloc.state.totalItemCount, equals(2));
        expect(bloc.state.subtotalVND, equals(2 * 10.0 * 25400));
      },
    );

    blocTest<CartBloc, CartState>(
      'Cộng dồn số lượng khi thêm sản phẩm đã có trong giỏ hàng',
      build: () => cartBloc,
      seed: () => const CartState(
          items: [CartItemEntity(product: tProduct1, quantity: 1)]),
      act: (bloc) => bloc.add(const CartItemAdded(tProduct1, quantity: 3)),
      expect: () => [
        const CartState(
            items: [CartItemEntity(product: tProduct1, quantity: 4)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'Tăng/giảm số lượng sản phẩm với CartItemQuantityUpdated',
      build: () => cartBloc,
      seed: () => const CartState(
          items: [CartItemEntity(product: tProduct1, quantity: 2)]),
      act: (bloc) => bloc.add(const CartItemQuantityUpdated(1, 1)),
      expect: () => [
        const CartState(
            items: [CartItemEntity(product: tProduct1, quantity: 3)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'Xóa sản phẩm khỏi giỏ hàng với CartItemRemoved',
      build: () => cartBloc,
      seed: () => const CartState(items: [
        CartItemEntity(product: tProduct1, quantity: 2),
        CartItemEntity(product: tProduct2, quantity: 1),
      ]),
      act: (bloc) => bloc.add(const CartItemRemoved(1)),
      expect: () => [
        const CartState(
            items: [CartItemEntity(product: tProduct2, quantity: 1)]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'Dọn sạch giỏ hàng với CartCleared',
      build: () => cartBloc,
      seed: () => const CartState(
          items: [CartItemEntity(product: tProduct1, quantity: 5)]),
      act: (bloc) => bloc.add(CartCleared()),
      expect: () => [
        const CartState(items: []),
      ],
    );
  });
}
