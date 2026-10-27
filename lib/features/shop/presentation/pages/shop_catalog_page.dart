/*
 * ==============================================================================
 * [ShopCatalogPage] - Trang Mua Sắm & Danh Mục Sản Phẩm E-Commerce
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../bloc/shop_bloc.dart';
import '../bloc/shop_event.dart';
import '../bloc/shop_state.dart';

class ShopCatalogPage extends StatefulWidget {
  const ShopCatalogPage({super.key});

  @override
  State<ShopCatalogPage> createState() => _ShopCatalogPageState();
}

class _ShopCatalogPageState extends State<ShopCatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu ban đầu nếu chưa có
    final shopBloc = context.read<ShopBloc>();
    if (shopBloc.state.status == ShopStatus.initial) {
      shopBloc.add(const ShopFetchProductsRequested());
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      context.read<ShopBloc>().add(const ShopLoadMoreProductsRequested());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return AppRefreshWrapper(
            onRefresh: () async {
              final completer = Completer<void>();
              context.read<ShopBloc>().add(
                    ShopFetchProductsRequested(
                      category: state.selectedCategory,
                      forceRefresh: true,
                      completer: completer,
                    ),
                  );
              await completer.future;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // 1. Ô Tìm Kiếm
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    child: AppTextField(
                      controller: _searchController,
                      hintText: 'Tìm kiếm hàng triệu sản phẩm...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondaryLight),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<ShopBloc>()
                                    .add(const ShopSearchQueryChanged(''));
                              },
                            )
                          : null,
                      onChanged: (val) {
                        _debouncer.run(() {
                          context
                              .read<ShopBloc>()
                              .add(ShopSearchQueryChanged(val));
                        });
                      },
                    ),
                  ),
                ),

                // 2. Banner Khuyến Mãi Carousel (Ẩn khi đang tìm kiếm)
                if (state.searchQuery.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: AppCarouselSlider(
                        height: 140.h,
                        autoPlay: true,
                        items: [
                          _buildPromoBanner(
                            title: '⚡ SIÊU SALE HÈ 50%',
                            subtitle: 'Hàng ngàn deal công nghệ & thời trang',
                            gradient: const [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6)
                            ],
                          ),
                          _buildPromoBanner(
                            title: '🎁 FREESHIP TOÀN QUỐC',
                            subtitle: 'Đơn hàng từ 150K nhận mã giảm 30K',
                            gradient: const [
                              Color(0xFFEC4899),
                              Color(0xFFF43F5E)
                            ],
                          ),
                          _buildPromoBanner(
                            title: '🌟 XẢ KHO GIÁ SỐC',
                            subtitle: 'Mỹ phẩm & nước hoa chính hãng',
                            gradient: const [
                              Color(0xFF0EA5E9),
                              Color(0xFF10B981)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Thanh Chọn Danh Mục (Category Pills)
                  SliverToBoxAdapter(
                    child: _buildCategoryList(context, state),
                  ),
                ],

                // Tiêu đề danh sách
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.searchQuery.isNotEmpty
                              ? 'Kết quả tìm kiếm: "${state.searchQuery}"'
                              : (state.selectedCategory == 'All'
                                  ? 'Tất Cả Sản Phẩm Hot 🔥'
                                  : 'Danh Mục: ${state.selectedCategory.toUpperCase()}'),
                          style: AppTypography.heading3,
                        ),
                        if (state.products.isNotEmpty)
                          Text(
                            '${state.products.length} sản phẩm',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 4. Lưới Sản Phẩm hoặc Trạng thái Loading / Empty
                _buildProductContent(context, state),

                // 5. Loading More Indicator & Reached Max Footer
                if (state.isLoadingMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (state.hasReachedMax && state.products.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text(
                          '🎉 Bạn đã xem hết ${state.products.length} sản phẩm!',
                          style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),

                // Khoảng đệm đáy
                SliverToBoxAdapter(
                  child: Gap(32.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('🛒 E-Commerce Mall', style: AppTypography.heading2),
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: false,
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined,
                      size: 26, color: AppColors.textPrimaryLight),
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
                      constraints:
                          BoxConstraints(minWidth: 18.w, minHeight: 18.w),
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
    );
  }

  Widget _buildPromoBanner({
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radius16.r),
        gradient: LinearGradient(colors: gradient),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.heading2.copyWith(color: Colors.white),
          ),
          Gap(4.h),
          Text(
            subtitle,
            style: AppTypography.bodySmall
                .copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          Gap(10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle.r),
            ),
            child: const Text(
              'Mua Ngay →',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, ShopState state) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(top: 4.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: state.categories.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (context, index) {
          final cat = state.categories[index];
          final isSelected = cat == state.selectedCategory;
          return GestureDetector(
            onTap: () {
              context.read<ShopBloc>().add(ShopCategorySelected(cat));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusCircle.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  cat == 'All'
                      ? 'Tất cả'
                      : cat[0].toUpperCase() + cat.substring(1),
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, ShopState state) {
    if (state.status == ShopStatus.loading && state.products.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.65,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                const AppShimmer.rectangular(height: 240, borderRadius: 12),
            childCount: 6,
          ),
        ),
      );
    }

    if (state.status == ShopStatus.failure && state.products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
          child: Column(
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 64, color: AppColors.textSecondaryLight),
              Gap(12.h),
              Text(
                state.errorMessage ?? 'Không thể tải danh sách sản phẩm.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Gap(16.h),
              AppButton(
                text: 'Thử lại',
                iconPrefix: const Icon(Icons.refresh_rounded,
                    color: Colors.white, size: 18),
                onPressed: () {
                  context.read<ShopBloc>().add(
                        ShopFetchProductsRequested(
                          category: state.selectedCategory,
                          forceRefresh: true,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.h),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded,
                    size: 56, color: AppColors.textSecondaryLight),
                Gap(8.h),
                Text('Không tìm thấy sản phẩm phù hợp',
                    style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = state.products[index];
            return _buildProductCard(context, product);
          },
          childCount: state.products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () {
        context.push('/shop/product/${product.id}', extra: product);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radius12.r),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh sản phẩm + Badge Giảm giá (Flex 5)
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.radius12.r)),
                    child: ColoredBox(
                      color: Colors.grey.shade50,
                      child: AppCachedImage(
                        imageUrl: product.thumbnail,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 2. Thông tin sản phẩm (Flex 6)
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand & Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brand.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(2.h),
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Giá tiền & Nút Add to Cart
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 13),
                            Gap(2.w),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: 10.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Gap(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CurrencyFormatter.formatVND(
                                        product.discountedPriceInVND),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (product.discountPercentage > 0)
                                    Text(
                                      CurrencyFormatter.formatVND(
                                          product.priceInVND),
                                      style: TextStyle(
                                        color: AppColors.textSecondaryLight,
                                        fontSize: 9.sp,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<CartBloc>()
                                    .add(CartItemAdded(product));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Đã thêm "${product.title}" vào giỏ!'),
                                    duration: const Duration(milliseconds: 900),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(6.r),
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: AppColors.primary,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
