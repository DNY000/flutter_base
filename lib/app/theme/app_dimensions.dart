/*
 * ==============================================================================
 * [AppDimensions] - Quy chuẩn Khoảng cách, Bo góc & Kích thước
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Chuẩn hóa hệ số Spacing (khoảng cách), Border Radius (bo góc) và kích thước các widget.
 * - Quy tắc thiết kế (8-point grid): Hầu hết khoảng cách là bội số của 4 hoặc 8 (4, 8, 12, 16, 24, 32...).
 * - Cách dùng kết hợp ScreenUtil: `AppDimensions.space16.w`, `AppDimensions.radius12.r`.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Standardizes spacing, border radius, and component sizes across UI.
 * - Rule: Based on an 8-point grid system (4, 8, 12, 16, 24, 32...).
 * ==============================================================================
 */

class AppDimensions {
  AppDimensions._();

  // Spacings & Margins / Paddings
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;

  // Border Radius Tokens
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius24 = 24.0;
  static const double radiusCircle = 999.0;

  // Heights / Sizes
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
