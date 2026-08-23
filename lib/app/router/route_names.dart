/// ==============================================================================
/// [RouteNames]
/// 
/// 🇻🇳 TIẾNG VIỆT:
/// - Chức năng: Lưu trữ danh sách tất cả các đường dẫn điều hướng (Route paths) trong ứng dụng.
/// - Cách sử dụng: Sử dụng `RouteNames.<route_name>` thay vì truyền chuỗi cứng ("hardcoded string") 
///   khi gọi `context.go()`, `context.push()`, hoặc khai báo trong `AppRouter`.
/// 
/// 🇬🇧 ENGLISH:
/// - Purpose: Centralizes all route path constants across the entire application.
/// - Usage: Use `RouteNames.<route_name>` instead of hardcoded strings with `context.go()` 
///   or `context.push()`.
/// ==============================================================================
class RouteNames {
  RouteNames._();

  /// Trang khởi động / Splash
  static const String initial = '/';

  /// Màn hình đăng nhập (Public)
  static const String login = '/login';

  /// Màn hình đăng ký tài khoản (Public)
  static const String register = '/register';

  /// Màn hình quên mật khẩu (Public)
  static const String forgotPassword = '/forgot-password';

  /// Màn hình chính / Dashboard (Protected - Cần đăng nhập)
  static const String home = '/home';

  /// Màn hình thông tin cá nhân (Protected - Cần đăng nhập)
  static const String profile = '/profile';

  /// Màn hình cài đặt ứng dụng (Protected - Cần đăng nhập)
  static const String settings = '/settings';

  /// Màn hình danh sách thông báo (Protected - Cần đăng nhập)
  static const String notifications = '/notifications';

  /// Màn hình Mua sắm & Danh mục E-Commerce (Protected - Cần đăng nhập)
  static const String shop = '/shop';

  /// Màn hình Chi tiết sản phẩm
  static const String productDetail = '/shop/product/:id';

  /// Màn hình Giỏ hàng & Thanh toán
  static const String cart = '/shop/cart';
}
