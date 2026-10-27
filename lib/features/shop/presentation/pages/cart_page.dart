/*
 * ==============================================================================
 * [CartPage] - Trang Giỏ Hàng & Thanh Toán E-Commerce
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
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();
  double _discountCoupon = 0.0;
  bool _isCheckingOut = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'SALE50') {
      setState(() => _discountCoupon = 50000.0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Áp dụng mã SALE50 thành công! Giảm 50.000₫'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã giảm giá không hợp lệ (Thử mã: SALE50)'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleCheckout(CartState state) async {
    setState(() => _isCheckingOut = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isCheckingOut = false);

    final shouldClear = await AppDialog.confirm(
      context,
      title: '🎉 Đặt Hàng Thành Công!',
      message:
          'Cảm ơn bạn đã mua sắm! Đơn hàng đang được đóng gói và chuẩn bị giao đi.',
      confirmText: 'Về Trang Mua Sắm',
      cancelText: 'Đóng',
    );

    if (!mounted) return;
    if (shouldClear == true) {
      context.read<CartBloc>().add(CartCleared());
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Giỏ Hàng Của Bạn', style: AppTypography.heading2),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error),
                onPressed: () async {
                  final confirmed = await AppDialog.confirm(
                    context,
                    title: 'Xóa Toàn Bộ Giỏ Hàng?',
                    message:
                        'Bạn có chắc chắn muốn dọn sạch tất cả sản phẩm trong giỏ?',
                    confirmText: 'Xác nhận xóa',
                    cancelText: 'Hủy',
                    isDestructive: true,
                  );
                  if (confirmed == true && context.mounted) {
                    context.read<CartBloc>().add(CartCleared());
                  }
                },
              );
            },
          ),
          Gap(8.w),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart_outlined,
                        size: 80, color: Colors.grey.shade400),
                    Gap(16.h),
                    Text('Giỏ hàng của bạn đang trống',
                        style: AppTypography.heading2),
                    Gap(8.h),
                    Text(
                      'Hãy khám phá hàng ngàn deal hấp dẫn và thêm vào giỏ ngay nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textSecondaryLight, fontSize: 12.sp),
                    ),
                    Gap(24.h),
                    AppButton.gradient(
                      text: 'Tiếp Tục Mua Sắm',
                      iconPrefix: const Icon(Icons.shopping_bag_outlined,
                          color: Colors.white, size: 18),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            );
          }

          final finalTotal =
              (state.totalVND - _discountCoupon).clamp(0.0, double.infinity);

          return Column(
            children: [
              // Danh sách sản phẩm trong giỏ (Có thể vuốt xoá)
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => Gap(10.h),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final product = item.product;

                    return AppSlidableTile(
                      key: ValueKey(product.id),
                      endActions: [
                        AppSlideAction.delete(
                          onPressed: (ctx) {
                            context
                                .read<CartBloc>()
                                .add(CartItemRemoved(product.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đã xóa "${product.title}" khỏi giỏ hàng.'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius12.r),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: SizedBox(
                                width: 56.w,
                                height: 56.w,
                                child: AppCachedImage(
                                  imageUrl: product.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gap(4.h),
                                  Text(
                                    '${CurrencyFormatter.formatVND(product.discountedPriceInVND)} x ${item.quantity} = ${CurrencyFormatter.formatVND(item.totalPriceInVND)}',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      size: 20, color: AppColors.primary),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          CartItemQuantityUpdated(
                                              product.id, -1),
                                        );
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      size: 20, color: AppColors.primary),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          CartItemQuantityUpdated(
                                              product.id, 1),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Phần Tổng Tiền & Thanh Toán Cố Định Dưới Đáy
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radius16.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nhập mã giảm giá
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 42.h,
                            child: TextField(
                              controller: _couponController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'Nhập mã coupon (VD: SALE50)',
                                hintStyle: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radius12.r),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderLight),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(8.w),
                        SizedBox(
                          height: 42.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                            ),
                            onPressed: _applyCoupon,
                            child: const Text('Áp Dụng'),
                          ),
                        ),
                      ],
                    ),

                    Gap(12.h),

                    // Tóm tắt giá tiền
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tạm tính (${state.totalItemCount} món):',
                            style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 12.sp)),
                        Text(CurrencyFormatter.formatVND(state.subtotalVND),
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Gap(4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phí giao hàng:',
                            style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 12.sp)),
                        Text(CurrencyFormatter.formatVND(state.shippingFeeVND),
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (_discountCoupon > 0) ...[
                      Gap(4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mã giảm giá (SALE50):',
                              style: TextStyle(
                                  color: AppColors.success, fontSize: 12.sp)),
                          Text(
                              '-${CurrencyFormatter.formatVND(_discountCoupon)}',
                              style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng Thanh Toán:', style: AppTypography.heading3),
                        Text(
                          CurrencyFormatter.formatVND(finalTotal),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(14.h),

                    // Nút Đặt Hàng
                    AppButton.gradient(
                      text:
                          'Tiến Hành Đặt Hàng (${CurrencyFormatter.formatVND(finalTotal)})',
                      iconPrefix: const Icon(Icons.lock_outline_rounded,
                          color: Colors.white, size: 18),
                      isLoading: _isCheckingOut,
                      onPressed: () => _handleCheckout(state),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
