/*
 * ==============================================================================
 * [ProductDetailPage] - Trang Chi Tiết Sản Phẩm E-Commerce
 * ==============================================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Chi Tiết Sản Phẩm', style: AppTypography.heading2),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimaryLight),
                    onPressed: () => context.push('/shop/cart'),
                  ),
                  if (cartState.totalItemCount > 0)
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                        child: Text(
                          '${cartState.totalItemCount > 99 ? '99+' : cartState.totalItemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Gap(8.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Slider Ảnh Sản Phẩm
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: AppCarouselSlider(
                height: 280.h,
                autoPlay: product.images.length > 1,
                items: product.images.map((imgUrl) {
                  return AppCachedImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.contain,
                  );
                }).toList(),
              ),
            ),

            Gap(8.h),

            // 2. Thông tin chính: Tiêu đề & Giá tiền
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          product.brand.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      Gap(8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),

                  // Tên sản phẩm
                  Text(
                    product.title,
                    style: AppTypography.heading2,
                  ),
                  Gap(8.h),

                  // Giá tiền
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Text(
                        CurrencyFormatter.formatVND(product.discountedPriceInVND),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        Text(
                          CurrencyFormatter.formatVND(product.priceInVND),
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 13.sp,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toInt()}%',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Gap(12.h),

                  // Đánh giá & Tồn kho
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      Gap(4.w),
                      Text(
                        '${product.rating} / 5.0',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                      Gap(16.w),
                      Text(
                        'Kho: ${product.stock} sản phẩm',
                        style: TextStyle(
                          color: product.stock > 0 ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Gap(8.h),

            // 3. Tiến độ Tồn kho & Mua sắm
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔥 Mức Độ Bán Chạy', style: AppTypography.heading3),
                  Gap(8.h),
                  AppLinearPercent(
                    percent: (100 - product.stock.clamp(0, 100)) / 100.0,
                    progressColor: AppColors.primary,
                    lineHeight: 8.h,
                  ),
                  Gap(6.h),
                  Text(
                    'Đã bán ${(100 - product.stock.clamp(0, 100))}% số lượng đợt phát hành này',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),

            Gap(8.h),

            // 4. Mô Tả Chi Tiết & Chính Sách (Accordion)
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  AppAccordion(
                    title: '📝 Mô tả sản phẩm',
                    initiallyExpanded: true,
                    content: Text(
                      product.description,
                      style: TextStyle(fontSize: 13.sp, height: 1.5, color: AppColors.textPrimaryLight),
                    ),
                  ),
                  AppAccordion(
                    title: '🛡️ Chính sách đổi trả & bảo hành',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Đổi mới 1-1 trong vòng 7 ngày nếu lỗi từ nhà sản xuất.', style: TextStyle(fontSize: 12.sp)),
                        Gap(4.h),
                        Text('• Miễn phí giao hàng cho đơn từ 150.000₫.', style: TextStyle(fontSize: 12.sp)),
                        Gap(4.h),
                        Text('• Cam kết 100% hàng chính hãng.', style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Gap(80.h), // Khoảng trống cho Bottom Bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context, product),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ProductEntity product) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bộ chọn số lượng
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(AppDimensions.radius12.r),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: _selectedQuantity > 1
                      ? () => setState(() => _selectedQuantity--)
                      : null,
                ),
                Text(
                  '$_selectedQuantity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () => setState(() => _selectedQuantity++),
                ),
              ],
            ),
          ),
          Gap(12.w),

          // Nút Thêm vào giỏ hàng
          Expanded(
            child: AppButton.gradient(
              text: 'Thêm Vào Giỏ Hàng',
              iconPrefix: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
              onPressed: () {
                context.read<CartBloc>().add(
                      CartItemAdded(product, quantity: _selectedQuantity),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã thêm $_selectedQuantity x "${product.title}" vào giỏ hàng!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
