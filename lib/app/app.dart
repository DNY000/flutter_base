/*
 * ==============================================================================
 * [MyApp] - Root Application Widget
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget gốc của toàn bộ ứng dụng Flutter.
 * - Cấu hình tích hợp:
 *   1. **ScreenUtilInit**: Khởi tạo hệ thống co giãn responsive theo tỉ lệ thiết kế (Figma: 375x812).
 *   2. **MultiBlocProvider**: Đăng ký các BLoC toàn cục (Global BLoCs như `AuthBloc`).
 *   3. **MaterialApp.router**: Tích hợp `GoRouter` với cơ chế Auth Guard và Dynamic Redirects.
 *   4. **EasyLocalization**: Thiết lập bộ dịch đa ngôn ngữ (Localization delegates & supported locales).
 *   5. **ThemeData**: Hỗ trợ tự động chuyển đổi Light Theme và Dark Theme.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Root widget initializing the application.
 * - Integrated Configurations:
 *   1. **ScreenUtilInit**: Responsive scaling based on design dimensions (375x812).
 *   2. **MultiBlocProvider**: Registers global BLoCs.
 *   3. **MaterialApp.router**: Integrates GoRouter with auth-state-aware routing.
 *   4. **EasyLocalization**: Sets up localization delegates and locales.
 *   5. **ThemeData**: Light and Dark theme support.
 * ==============================================================================
 */

import 'dart:async';
import 'package:base_project/features/shop/presentation/bloc/cart_bloc.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_constants.dart';
import '../core/di/injection_container.dart';
import '../core/services/notification_service.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Khởi tạo AuthBloc và kiểm tra phiên đăng nhập đã lưu
    _authBloc = sl<AuthBloc>();
    _authBloc.add(AuthCheckRequested());
    // Khởi tạo Router gắn liền với AuthBloc để kích hoạt Auth Guard
    _router = AppRouter.createRouter(_authBloc);

    // Kích hoạt xử lý thông báo còn tồn đọng khi mở app từ trạng thái Kill App (Cold Start)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<INotificationService>().handlePendingNotificationAfterLaunch();
    });
  }

  @override
  void dispose() {
    unawaited(_authBloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _authBloc),
            BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
            BlocProvider<ShopBloc>(create: (_) => sl<ShopBloc>()),
          ],
          child: MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            // Cấu hình đa ngôn ngữ (Localization)
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // Cấu hình Theme (Light & Dark mode)
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            // Cấu hình Router (GoRouter with Auth Guard)
            routerConfig: _router,
          ),
        );
      },
    );
  }
}
