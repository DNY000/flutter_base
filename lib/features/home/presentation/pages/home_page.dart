/*
 * ==============================================================================
 * [HomePage] - Màn Hình Trình Diễn Toàn Bộ Hệ Thống Base & Shared Widgets
 * ==============================================================================
 */

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _counter = 0;
  bool _isLoadingButton = false;
  bool _switchValue = true;
  bool _checkboxValue = true;
  String _selectedRadio = 'A';
  String _selectedCity = 'HN';
  DateTime _selectedDate = DateTime.now();
  double _rating = 4.5;
  String _otpValue = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _triggerNotification() async {
    await sl<INotificationService>().showNotification(
      id: 101,
      title: '🎉 Base Project Notification',
      body: 'Thông báo cục bộ & điều hướng hoạt động hoàn hảo!',
      payloadData: const {
        'route': RouteNames.home,
        'type': 'HOME',
        'id': 'demo_123'
      },
    );
    if (mounted) {
      context.showSnackBar('Đã gửi thông báo thử nghiệm!');
    }
  }

  void _showLanguageBottomSheet() {
    unawaited(
      AppBottomSheet.show<void>(
        context: context,
        title: 'Chọn Ngôn Ngữ / Select Language',
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppListTile(
                leading: const Icon(Icons.language, color: AppColors.primary),
                title: 'Tiếng Việt',
                trailing: context.locale.languageCode == 'vi'
                    ? const Icon(Icons.check, color: AppColors.success)
                    : null,
                onTap: () async {
                  await context.setLocale(const Locale('vi'));
                  await sl<ILocalStorage>().setLanguageCode('vi');
                  if (mounted && context.mounted) Navigator.pop(context);
                },
              ),
              AppListTile(
                leading: const Icon(Icons.language, color: AppColors.primary),
                title: 'English',
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: AppColors.success)
                    : null,
                onTap: () async {
                  await context.setLocale(const Locale('en'));
                  await sl<ILocalStorage>().setLanguageCode('en');
                  if (mounted && context.mounted) Navigator.pop(context);
                },
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Design System & Widgets Gallery',
        automaticallyImplyLeading: false,
        actions: [
          AppIconButton(
            icon: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.primary),
            tooltip: 'Trải nghiệm E-Commerce Shop',
            onPressed: () => context.push('/shop'),
          ),
          AppIconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Gửi thông báo',
            onPressed: _triggerNotification,
          ),
          AppIconButton(
            icon: const Icon(Icons.translate),
            tooltip: 'Đổi ngôn ngữ',
            onPressed: _showLanguageBottomSheet,
          ),
          AppIconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go(RouteNames.login);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.touch_app), text: 'Buttons & Text'),
            Tab(icon: Icon(Icons.input), text: 'Inputs & Form'),
            Tab(
                icon: Icon(Icons.dashboard_customize),
                text: 'Interactive & Percent'),
            Tab(icon: Icon(Icons.view_agenda), text: 'Lists, Sliders & Media'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildButtonsAndTextTab(),
          _buildInputsTab(),
          _buildInteractiveTab(),
          _buildListsAndMediaTab(),
        ],
      ),
    );
  }

  // TAB 1: BUTTONS SUITE & TYPOGRAPHY
  Widget _buildButtonsAndTextTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner E-Commerce Mall
          Container(
            padding: EdgeInsets.all(AppDimensions.space16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radius16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded,
                    color: Colors.white, size: 36),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🛍️ Module E-Commerce Mall',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Gap(4.h),
                      const Text(
                          'API DummyJSON • Clean Arch • BLoC 9 • Hive Cache',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                AppButton.secondary(
                  text: 'Khám Phá',
                  size: AppButtonSize.small,
                  isFullWidth: false,
                  onPressed: () => context.push('/shop'),
                ),
              ],
            ),
          ),
          Gap(AppDimensions.space16.h),
          // Banner
          AppCard(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Row(
              children: [
                const AppAvatar(name: 'Admin', isOnline: true, size: 48),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText.h3('Enterprise Flutter UI Kit',
                          color: Colors.white),
                      Gap(4.h),
                      AppText.autoSize(
                        'Hệ thống Widget trực quan phong phú • Clean Architecture',
                        color: Colors.white.withValues(alpha: 0.9),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),

          // Typography
          const AppText.h3('1. Typography & AutoSizeText'),
          Gap(8.h),
          const AppText.h1('Heading 1 Title (H1)'),
          const AppText.h2('Heading 2 Subtitle (H2)'),
          const AppText.bodyMedium(
              'Body Medium chuẩn hóa với Clean Design Tokens.'),
          const AppText.caption('Caption Text nhỏ gọn cho ghi chú phụ.'),
          Gap(6.h),
          const AppText.autoSize(
            '🌟 AutoSizeText: Tự động co giãn theo chiều ngang màn hình không bị tràn viền (1.000.000.000 ₫)',
            maxLines: 1,
            color: AppColors.primary,
          ),
          Gap(24.h),

          // Buttons Suite
          const AppText.h3('2. Buttons Suite (7 Styles & 3 Sizes)'),
          Gap(12.h),
          AppButton(
            text: 'Primary Button (Clicks: $_counter)',
            iconPrefix:
                const Icon(Icons.touch_app, size: 20, color: Colors.white),
            onPressed: () => setState(() => _counter++),
          ),
          Gap(10.h),
          AppButton.gradient(
            text: 'Gradient Vibrant Button',
            iconSuffix:
                const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
            onPressed: () => context.showSnackBar('Clicked Gradient Button!'),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  text: 'Secondary',
                  onPressed: () => context.showSnackBar('Clicked Secondary!'),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: AppButton.tonal(
                  text: 'Tonal / Soft',
                  onPressed: () => context.showSnackBar('Clicked Tonal!'),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'Outline Button',
                  onPressed: () => context.showSnackBar('Clicked Outline!'),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: AppButton.danger(
                  text: 'Danger / Delete',
                  iconPrefix: const Icon(Icons.delete_outline,
                      size: 18, color: Colors.white),
                  onPressed: () => context.showSnackBar('Clicked Danger!'),
                ),
              ),
            ],
          ),
          Gap(10.h),
          AppButton.outline(
            text: 'Loading State Button',
            isLoading: _isLoadingButton,
            onPressed: () async {
              setState(() => _isLoadingButton = true);
              await Future<void>.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => _isLoadingButton = false);
            },
          ),
          Gap(10.h),
          Row(
            children: [
              AppButton(
                text: 'Small Pill',
                size: AppButtonSize.small,
                isFullWidth: false,
                isPill: true,
                onPressed: () {},
              ),
              Gap(10.w),
              AppButton.secondary(
                text: 'Medium Pill',
                size: AppButtonSize.medium,
                isFullWidth: false,
                isPill: true,
                onPressed: () {},
              ),
              Gap(10.w),
              AppButton.ghost(
                text: 'Ghost Text',
                isFullWidth: false,
                onPressed: () {},
              ),
            ],
          ),
          Gap(32.h),
        ],
      ),
    );
  }

  // TAB 2: INPUTS & FORM
  Widget _buildInputsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.h3('1. OTP & PIN Code Field (pin_code_fields)'),
          Gap(12.h),
          AppOtpField(
            length: 6,
            onChanged: (v) => setState(() => _otpValue = v),
            onCompleted: (code) =>
                context.showSnackBar('Đã nhập đủ mã OTP: $code'),
          ),
          if (_otpValue.isNotEmpty)
            AppText.caption('Mã đang nhập: $_otpValue',
                color: AppColors.primary),
          Gap(24.h),
          const AppText.h3('2. Standard Form Inputs'),
          Gap(12.h),
          const AppTextField(
            labelText: 'Họ và tên',
            hintText: 'Nhập họ và tên đầy đủ',
            prefixIcon: Icon(Icons.person_outline),
          ),
          Gap(12.h),
          const AppTextField(
            labelText: 'Mật khẩu bảo mật',
            hintText: 'Nhập mật khẩu',
            isPassword: true,
          ),
          Gap(12.h),
          AppDatePickerField(
            labelText: 'Ngày sinh',
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),
          Gap(12.h),
          AppDropdownField<String>(
            labelText: 'Tỉnh / Thành phố',
            value: _selectedCity,
            items: const [
              DropdownItem(value: 'HN', label: 'Hà Nội'),
              DropdownItem(value: 'HCM', label: 'TP. Hồ Chí Minh'),
              DropdownItem(value: 'DN', label: 'Đà Nẵng'),
            ],
            onChanged: (v) => setState(() => _selectedCity = v),
          ),
          Gap(20.h),
          const AppText.h3('3. Switch, Checkbox & Radio'),
          Gap(12.h),
          AppSwitch(
            value: _switchValue,
            label: 'Thông báo thời gian thực',
            subtitle: 'Nhận tin nhắn & cập nhật đơn hàng tức thì',
            onChanged: (v) => setState(() => _switchValue = v),
          ),
          Gap(8.h),
          AppCheckbox(
            value: _checkboxValue,
            label: 'Đồng ý với chính sách & điều khoản sử dụng',
            onChanged: (v) => setState(() => _checkboxValue = v ?? false),
          ),
          Gap(8.h),
          AppRadioGroup<String>(
            selectedValue: _selectedRadio,
            options: const [
              RadioOption(
                  value: 'A', title: 'Tùy chọn thanh toán qua Thẻ tín dụng'),
              RadioOption(
                  value: 'B', title: 'Tùy chọn thanh toán khi nhận hàng (COD)'),
            ],
            onChanged: (v) => setState(() => _selectedRadio = v),
          ),
          Gap(32.h),
        ],
      ),
    );
  }

  // TAB 3: INTERACTIVE, TOOLTIPS & PERCENT INDICATORS
  Widget _buildInteractiveTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.h3('1. SuperTooltip (Bong Bóng Chú Thích Mũi Tên)'),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppTooltip(
                message: 'Chạm nhẹ để xem hướng dẫn!',
                popupDirection: TooltipDirection.up,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 6),
                      Text('Tooltip Hướng Lên',
                          style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              AppTooltip(
                message: 'Đây là nội dung Tooltip hướng xuống',
                popupDirection: TooltipDirection.down,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.help_outline,
                          color: AppColors.secondary, size: 20),
                      SizedBox(width: 6),
                      Text('Tooltip Hướng Xuống',
                          style: TextStyle(color: AppColors.secondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(24.h),
          const AppText.h3('2. Percent Indicators (Tiến Độ % Animated)'),
          Gap(12.h),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppCircularPercent(
                percent: 0.75,
                progressColor: AppColors.primary,
                label: 'Hoàn thành mục tiêu',
              ),
              AppCircularPercent(
                percent: 0.90,
                progressColor: AppColors.success,
                label: 'Dung lượng đã dùng',
              ),
              AppCircularPercent(
                percent: 0.40,
                progressColor: AppColors.warning,
                label: 'Tải tài liệu',
              ),
            ],
          ),
          Gap(16.h),
          const AppLinearPercent(
            percent: 0.68,
            lineHeight: 14,
            progressColor: AppColors.primary,
          ),
          Gap(24.h),
          const AppText.h3('3. Rating Bar & Accordion'),
          Gap(12.h),
          AppRatingBar(
            rating: _rating,
            onRatingChanged: (r) => setState(() => _rating = r),
          ),
          Gap(12.h),
          const AppAccordion(
            title: 'Câu hỏi thường gặp: Dự án dùng kiến trúc gì?',
            content: Text(
              'Dự án áp dụng Clean Architecture kết hợp State Management BLoC 9, GoRouter có Auth Guard và GetIt Service Locator.',
            ),
          ),
          Gap(24.h),
          const AppText.h3('4. Feedback & Dialogs'),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'Confirm Dialog',
                  onPressed: () async {
                    final confirmed = await AppDialog.confirm(
                      context,
                      title: 'Xác nhận xóa',
                      message: 'Bạn có chắc chắn muốn thực hiện thao tác này?',
                      isDestructive: true,
                    );
                    if (!mounted) return;
                    if (confirmed == true) {
                      AppSnackBar.success(context, 'Đã xác nhận thành công!');
                    }
                  },
                ),
              ),
              Gap(10.w),
              Expanded(
                child: AppButton.tonal(
                  text: 'Show BottomSheet',
                  onPressed: _showLanguageBottomSheet,
                ),
              ),
            ],
          ),
          Gap(32.h),
        ],
      ),
    );
  }

  // TAB 4: LISTS, SLIDERS & MEDIA
  Widget _buildListsAndMediaTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.h3('1. Slidable List Tile (Vuốt Trái/Phải để Xóa/Sửa)'),
          Gap(8.h),
          AppCard.outlined(
            padding: EdgeInsets.zero,
            child: AppSlidableTile(
              endActions: [
                AppSlideAction.delete(
                  onPressed: (ctx) => context.showSnackBar('Đã xóa thông báo!'),
                ),
                AppSlideAction.edit(
                  onPressed: (ctx) =>
                      context.showSnackBar('Chỉnh sửa thông báo!'),
                ),
              ],
              child: const AppListTile(
                leading:
                    Icon(Icons.notifications_active, color: AppColors.primary),
                title: 'Đơn hàng #10293 đã được giao',
                subtitle: 'Vuốt sang trái để mở action Xóa / Sửa 👈',
              ),
            ),
          ),
          Gap(24.h),
          const AppText.h3('2. Carousel Slider & Media Picker'),
          Gap(12.h),
          AppCarouselSlider(
            height: 140,
            items: [
              _buildBannerCard('Khuyến Mãi Siêu Khủng 50%',
                  [const Color(0xFFEC4899), const Color(0xFF8B5CF6)]),
              _buildBannerCard('Miễn Phí Vận Chuyển Toàn Quốc',
                  [const Color(0xFF3B82F6), const Color(0xFF10B981)]),
              _buildBannerCard('Thành Viên VIP Ưu Đãi Đặc Biệt',
                  [const Color(0xFFF59E0B), const Color(0xFFEF4444)]),
            ],
          ),
          Gap(16.h),
          AppButton.outline(
            text: 'Mở Media Picker BottomSheet (Chọn Ảnh/Video)',
            iconPrefix: const Icon(Icons.camera_alt_outlined),
            onPressed: () async {
              final file = await MediaPickerSheet.show(context);
              if (file != null && mounted && context.mounted) {
                context.showSnackBar(
                    'Đã chọn tệp: ${file.path.split(RegExp(r'[/\\]')).last}');
              }
            },
          ),
          Gap(24.h),
          const AppText.h3('3. Cached Network Image & Shimmer'),
          Gap(12.h),
          const AppCachedImage(
            imageUrl:
                'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&w=800&q=80',
            height: 120,
            width: double.infinity,
          ),
          Gap(32.h),
        ],
      ),
    );
  }

  Widget _buildBannerCard(String text, List<Color> colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(colors: colors),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
