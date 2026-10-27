/*
 * ==============================================================================
 * [AppRouter]
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Quản trị luồng điều hướng của toàn bộ ứng dụng sử dụng [GoRouter].
 * - Tính năng đặc biệt:
 *   1. **Auth Guard & Reactive Redirect**: Lắng nghe trạng thái của `AuthBloc` thông qua
 *      `GoRouterRefreshStream`. Tự động chuyển hướng (redirect) khi người dùng Đăng nhập,
 *      Đăng xuất, hoặc phiên làm việc hết hạn.
 *   2. **Bảo vệ Route (Protected Routes)**: Chặn người dùng chưa đăng nhập truy cập vào 
 *      các màn hình nhạy cảm (`/home`, `/profile`, v.v.) và chuyển về `/login`.
 *   3. **Tránh lặp Auth**: Chuyển hướng người dùng đã đăng nhập từ `/login` thẳng vào `/home`.
 *   4. **Page Transitions**: Thiết lập hiệu ứng chuyển cảnh mượt mà giữa các trang.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Manages declarative routing and navigation with [GoRouter].
 * - Key Features:
 *   1. **Auth Guard & Reactive Redirect**: Listens to `AuthBloc` state changes via
 *      `GoRouterRefreshStream` to dynamically re-evaluate redirect rules.
 *   2. **Protected Routes**: Automatically redirects unauthenticated users to `/login`.
 *   3. **No-auth Redirection**: Redirects authenticated users from `/login` to `/home`.
 *   4. **Custom Page Transitions**: Smooth slide/fade transitions across pages.
 * ==============================================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/logger.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/shop/domain/entities/product_entity.dart';
import '../../features/shop/presentation/pages/cart_page.dart';
import '../../features/shop/presentation/pages/product_detail_page.dart';
import '../../features/shop/presentation/pages/shop_catalog_page.dart';
import 'route_names.dart';

/// Lớp chuyển đổi Stream của BLoC thành [Listenable] để GoRouter tự động kích hoạt redirect khi State thay đổi.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root_nav');

  /// Instance GoRouter được chia sẻ toàn cục để hỗ trợ điều hướng từ Service/Notification
  static late GoRouter router;

  /// Danh sách các route công khai (không bắt buộc đăng nhập)
  static final List<String> _publicRoutes = [
    RouteNames.login,
    RouteNames.register,
    RouteNames.forgotPassword,
  ];

  static GoRouter createRouter(AuthBloc authBloc) {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RouteNames.home,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      // =========================================================================
      // AUTH GUARD & REDIRECT LOGIC
      // =========================================================================
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final currentPath = state.matchedLocation;
        final isPublicRoute = _publicRoutes.contains(currentPath);

        AppLogger.d(
          'Router Guard check: path=$currentPath, authStatus=${authState.status}',
          tag: 'ROUTER',
        );

        // 1. Nếu đang trong trạng thái loading hoặc khởi tạo ban đầu, không can thiệp redirect
        if (authState.status == AuthStatus.initial ||
            authState.status == AuthStatus.loading) {
          return null;
        }

        final bool isAuthenticated =
            authState.status == AuthStatus.authenticated;

        // 2. Người dùng CHƯA ĐĂNG NHẬP nhưng truy cập trang yêu cầu đăng nhập (Protected Route)
        if (!isAuthenticated && !isPublicRoute) {
          AppLogger.w(
              'Unauthenticated access attempt to $currentPath -> Redirect to Login');
          return RouteNames.login;
        }

        // 3. Người dùng ĐÃ ĐĂNG NHẬP nhưng truy cập lại trang Login/Register
        if (isAuthenticated && isPublicRoute) {
          AppLogger.i('Authenticated user on public route -> Redirect to Home');
          return RouteNames.home;
        }

        // Không có chuyển hướng nào, cho phép điều hướng bình thường
        return null;
      },

      // =========================================================================
      // ROUTES DEFINITION
      // =========================================================================
      routes: [
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          pageBuilder: (context, state) => _buildPageWithFadeTransition(
            state: state,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          pageBuilder: (context, state) => _buildPageWithSlideTransition(
            state: state,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.shop,
          name: 'shop',
          pageBuilder: (context, state) => _buildPageWithSlideTransition(
            state: state,
            child: const ShopCatalogPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.productDetail,
          name: 'productDetail',
          pageBuilder: (context, state) {
            final product = state.extra as ProductEntity?;
            if (product != null) {
              return _buildPageWithSlideTransition(
                state: state,
                child: ProductDetailPage(product: product),
              );
            }
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
            return _buildPageWithSlideTransition(
              state: state,
              child: ProductDetailPage(
                product: ProductEntity(
                  id: id,
                  title: 'Sản phẩm #$id',
                  description: 'Đang cập nhật chi tiết sản phẩm...',
                  category: 'General',
                  price: 99.0,
                  discountPercentage: 10,
                  rating: 4.8,
                  stock: 50,
                  brand: 'Store',
                  thumbnail:
                      'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
                  images: const [
                    'https://cdn.dummyjson.com/product-images/1/1.jpg'
                  ],
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: RouteNames.cart,
          name: 'cart',
          pageBuilder: (context, state) => _buildPageWithSlideTransition(
            state: state,
            child: const CartPage(),
          ),
        ),
      ],

      // Trang hiển thị khi gặp lỗi không tìm thấy đường dẫn (404 Page)
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('404 - Không Tìm Thấy Trang')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Đường dẫn không tồn tại: ${state.uri}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text('Về Trang Chủ'),
              ),
            ],
          ),
        ),
      ),
    );
    return router;
  }

  /// Hiệu ứng Fade Transition mượt mà
  static CustomTransitionPage<void> _buildPageWithFadeTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Hiệu ứng Slide Transition từ phải sang trái
  static CustomTransitionPage<void> _buildPageWithSlideTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
