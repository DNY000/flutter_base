/*
 * ==============================================================================
 * [ProductEntity] - Thực Thể Sản Phẩm Thương Mại Điện Tử
 * ==============================================================================
 */

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
  });

  /// Tính toán giá sau khi đã giảm giá
  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    return price * (1 - (discountPercentage / 100));
  }

  /// Quy đổi giá USD từ DummyJSON sang VND ước tính (Tỉ giá 25,400)
  double get priceInVND => price * 25400;
  double get discountedPriceInVND => discountedPrice * 25400;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        discountPercentage,
        rating,
        stock,
        brand,
        thumbnail,
        images,
      ];
}

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.product,
    this.quantity = 1,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPriceInVND => product.discountedPriceInVND * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
