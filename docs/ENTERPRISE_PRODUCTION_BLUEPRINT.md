# 🏛️ FLUTTER ENTERPRISE PRODUCTION BLUEPRINT (100K+ ACTIVE USERS)
> **Tài liệu đặc tả kiến trúc, tiêu chuẩn kỹ thuật & kế hoạch triển khai toàn diện cho dự án Flutter quy mô lớn.**

---

## 🎯 1. TỔNG QUAN HỆ THỐNG & MỤC TIÊU DỰ ÁN

Khi xây dựng một ứng dụng Flutter phục vụ **100.000+ người dùng (MAU/DAU)**, ứng dụng không chỉ đơn thuần là hiển thị giao diện đẹp, mà phải giải quyết 5 bài toán cốt tử:
1. **Độ ổn định (Crash-free rate > 99.8%)**: Xử lý triệt để ngoại lệ, không crash app khi backend lỗi hoặc mạng chập chờn.
2. **Hiệu năng cao (60-120 FPS)**: Thời gian mở app (Cold Start) < 1.5s, không giật lag (jank free), kiểm soát rò rỉ bộ nhớ (Memory Leaks).
3. **Bảo mật đa tầng (Enterprise Grade Security)**: Chống dịch ngược (Decompile), chống tấn công nghe lén (Man-in-the-Middle), bảo vệ dữ liệu nhạy cảm.
4. **Nghiên cứu hành vi & Trải nghiệm (Analytics & User Tracking)**: Đo lường phễu chuyển đổi (Funnel), Heatmap, ghi lại phiên sử dụng khi phát sinh lỗi (Session Replay).
5. **Vận hành & CI/CD tự động**: Triển khai đa môi trường (Dev/Staging/Prod), phát hành tự động lên App Store & Google Play.

---

## 📊 2. SƠ ĐỒ KIẾN TRÚC TỔNG THỂ (CLEAN ARCHITECTURE + MODULAR)

```mermaid
graph TD
    subgraph Client Layer [Flutter App Client]
        UI[Presentation Layer: BLoC / Pages / Shared Widgets]
        Domain[Domain Layer: Entities / UseCases / Business Rules]
        Data[Data Layer: Repositories / DataSources / DTOs]
    end

    subgraph Core Infrastructure [Core & Security Services]
        Network[Network: Dio + SSL Pinning + Token Refresh Queue]
        Storage[Storage: SecureStorage Keychain/KeyStore + Hive Cache]
        Security[Security: Root/Jailbreak Check + Blur Switcher + Obfuscation]
        Telemetry[Telemetry: Crashlytics + Sentry + Firebase Analytics + Heatmap]
        Sync[Offline Sync: Action Queue + Conflict Resolver]
    end

    subgraph Backend & Cloud [Backend & 3rd Party Cloud]
        API[API Gateway / Microservices]
        FCM[Firebase Cloud Messaging / Push Notifications]
        RemoteConfig[Firebase Remote Config / Feature Flags]
    end

    UI --> Domain
    Domain --> Data
    Data --> Network
    Data --> Storage
    Network --> API
    Telemetry --> Client Layer
    Security --> Client Layer
    FCM --> UI
    RemoteConfig --> Client Layer
```

---

## 🧱 3. CHI TIẾT TỪNG MODULE CHUYÊN BIỆT (FOLDER-BY-FOLDER WORK BREAKDOWN)

---

### 📂 PHẦN 1: UI/UX & DESIGN SYSTEM (`lib/app/theme/` & `lib/shared/widgets/`)
*Mục tiêu: Đạt chuẩn trải nghiệm người dùng cao cấp, phản hồi tức thì, mượt mà trên mọi thiết bị.*

#### Các hạng mục công việc chi tiết:
- [x] **Design Tokens & Theme Switcher**:
  - Hỗ trợ **Light Mode & Dark Mode** tự động theo hệ thống hoặc toggle người dùng.
  - Phân loại màu chuẩn Semantic: `Primary`, `Secondary`, `Success`, `Warning`, `Error`, `Neutral`.
  - Chuẩn hóa hệ số khoảng cách **8-point grid** (`4, 8, 12, 16, 24, 32...`) và bo góc `AppDimensions`.
- [x] **Responsive Screen Utility (`flutter_screenutil`)**:
  - Khởi tạo base resolution chuẩn Figma (`375x812`).
  - Sử dụng `.w`, `.h`, `.sp`, `.r` để scale tỉ lệ hoàn hảo trên mọi kích thước màn hình Phone & Tablet.
- [x] **Bộ UI Kit 25+ Shared Components**:
  - `buttons/`: Primary, Secondary, Outline, Text, IconButton kèm badge & loading state.
  - `inputs/`: TextField (toggle password, clear text), OtpField (4-6 số), DropdownField (BottomSheet picker), DatePicker, Switch, Checkbox, RadioGroup.
  - `typography/`: AppText (H1, H2, H3, Body, Caption), AppRichText (Clickable spans).
  - `cards/`: Card (Bo góc, Shadow, Viền, Gradient, Tap ripple).
  - `lists/ & grids/`: Smart ListView & GridView tự động handle Loading, Error Retry, Empty & Pull-to-Refresh.
  - `interactive/`: Accordion (FAQ), RatingBar (5 sao), ProgressBar (tiến độ %).
  - `sliders/`: CarouselSlider tự động lướt banner kèm dot indicators.
  - `feedback/`: Dialog confirm/loading, BottomSheet, Floating SnackBar.
  - `states/`: Shimmer skeleton loading thay cho spinner đơn điệu.
- [ ] **Micro-Interactions & Haptic Feedback**:
  - Tích hợp rung phản hồi xúc giác nhẹ (`HapticFeedback.lightImpact()`) khi nhấn nút, switch toggle, hoặc pull-to-refresh.
  - Đảm bảo animation đạt **60 FPS / 120 FPS** (ProMotion Display), bọc `RepaintBoundary` cho các animation phức tạp.

---

### 📂 PHẦN 2: BẢO MẬT CẤP DOANH NGHIỆP (`lib/core/security/`)
*Mục tiêu: Đạt tiêu chuẩn bảo mật cho ứng dụng tài chính/doanh nghiệp 100k+ người dùng.*

#### Các hạng mục công việc chi tiết:
- [ ] **SSL / TLS Certificate Pinning**:
  - Cấu hình Pinning SHA-256 Fingerprint hoặc Certificate công khai vào `DioClient` để ngăn chặn hoàn toàn tấn công nghe lén Man-in-the-Middle (MitM) qua Proxy/Charles/Fiddler.
- [ ] **Phát hiện Thiết bị Rooted / Jailbroken**:
  - Tích hợp `flutter_jailbreak_detection` / `free_root`: Kiểm tra trạng thái máy đã bị bẻ khóa, cảnh báo hoặc từ chối thực thi các giao dịch nhạy cảm.
- [ ] **Bảo vệ Bộ nhớ Đệm & Tokens (`lib/core/storage/`)**:
  - Sử dụng `flutter_secure_storage` với **Hardware-backed Keystore (Android)** và **Keychain (iOS)** cho JWT Access Token, Refresh Token, Biometric Auth Secret.
  - Tự động xóa sạch toàn bộ storage khi phát hiện token bị giả mạo hoặc user logout.
- [ ] **Chống Chụp Màn Hình & Che Mờ Task Switcher**:
  - Kích hoạt cờ `FLAG_SECURE` (Android) và bảo vệ Snapshot (iOS) để tự động làm mờ màn hình app khi người dùng chuyển sang cửa sổ đa nhiệm (App Switcher), chống lộ dữ liệu riêng tư.
- [ ] **Xác thực Sinh Trắc Học (Biometric Auth - FaceID / Fingerprint)**:
  - Tích hợp `local_auth` để đăng nhập nhanh hoặc xác thực giao dịch, tự động khóa ứng dụng sau `X` phút không hoạt động (Inactivity Auto-Lock).
- [ ] **Code Obfuscation & ProGuard / R8**:
  - Cấu hình Obfuscate mã nguồn trong lệnh build: `--obfuscate --split-debug-info=/<symbols-path>`.
  - Cấu hình ProGuard Rules cho Android để xóa sạch debug symbols và rút gọn binary size.

---

### 📂 PHẦN 3: NETWORK LAYER, TOKEN REFRESH & CACHE (`lib/core/network/`)
*Mục tiêu: Xử lý hàng nghìn request/giây với độ bền vững cao, tự động phục hồi khi có sự cố.*

#### Các hạng mục công việc chi tiết:
- [x] **Base Dio Client & Interceptors**:
  - Cấu hình timeout kết nối, đọc, gửi (`connectTimeout`, `receiveTimeout`, `sendTimeout: 30s`).
  - Gắn header chuẩn hóa: `Accept`, `Content-Type`, `Device-Id`, `App-Version`, `Language-Code`.
- [x] **Cơ Chế Token Refresh Tự Động (Queued Interceptor)**:
  - Khi gặp mã lỗi `401 Unauthorized`:
    1. Khóa hàng đợi request (Lock queue).
    2. Gọi API `POST /auth/refresh-token` bằng RefreshToken.
    3. Cập nhật Token mới vào SecureStorage.
    4. Mở khóa và tự động retry lại các request ban đầu mà người dùng không bị văng khỏi app.
    5. Nếu refresh thất bại: Xóa sạch phiên và chuyển trạng thái về `Unauthenticated`.
- [ ] **Chiến Lược Caching Đa Tầng (Multi-Tier Caching)**:
  - **L1 (Memory Cache)**: Cache dữ liệu tạm thời trên RAM cho các thao tác nhanh.
  - **L2 (Disk Cache - Hive/SQLite)**: Lưu trữ dữ liệu offline kèm thời gian hết hạn (Time-To-Live - TTL 15 phút, 1 giờ, 1 ngày).
  - **Chiến lược truy xuất**:
    - `CacheFirst`: Lấy cache trước -> Nếu hết hạn mới gọi mạng (áp dụng cho danh mục, tin tức).
    - `NetworkFirst`: Gọi mạng trước -> Nếu mất mạng thì fallback về cache.
    - `CacheThenNetwork`: Hiển thị cache ngay lập tức -> Gọi mạng cập nhật nền và render lại UI.
- [ ] **Exponential Backoff Retry & Network Resilience**:
  - Tự động thử lại request thất bại do mất mạng đột ngột (Retry 3 lần với khoảng cách thời gian tăng dần: 1s -> 2s -> 4s).

---

### 📂 PHẦN 4: NGHIÊN CỨU HÀNH VI & ĐO LƯỜNG NGƯỜI DÙNG (`lib/core/analytics/`)
*Mục tiêu: Thấu hiểu hành vi 100k người dùng để tối ưu hóa sản phẩm và gia tăng tỉ lệ chuyển đổi.*

#### Các hạng mục công việc chi tiết:
- [ ] **Event Tracking & Analytics (Firebase Analytics / Mixpanel / Amplitude)**:
  - Định nghĩa chuẩn bảng sự kiện (Analytics Taxonomy):
    - `screen_view`: Tự động ghi lại khi chuyển màn hình qua `GoRouterObserver`.
    - `user_action`: `btn_click`, `form_submit`, `tab_change`.
    - `ecommerce / transaction`: `add_to_cart`, `checkout_success`, `payment_failed`.
  - Gắn thuộc tính người dùng (User Properties): `user_tier`, `preferred_language`, `theme_mode`, `app_version`.
- [ ] **Đo Lường Phễu Chuyển Đổi (Funnel Tracking)**:
  - Phễu Đăng ký / Đăng nhập: `open_app -> view_login -> enter_phone -> enter_otp -> login_success`.
  - Theo dõi chính xác tỉ lệ rơi rụng (Drop-off rate) ở từng bước để tối ưu UI/UX.
- [ ] **Session Replay & Heatmap (UXCam / Smartlook / Microsoft Clarity)**:
  - Ghi lại luồng thao tác của người dùng dưới dạng video ẩn thông tin nhạy cảm (Mask sensitive text/password) để phát hiện vị trí người dùng gặp khó khăn (Rage taps, Dead clicks).
- [ ] **A/B Testing & Feature Flags (Firebase Remote Config)**:
  - Bật/tắt tính năng mới linh hoạt cho 10% -> 50% -> 100% người dùng mà không cần phát hành bản cập nhật mới trên Store.
  - Bắt buộc cập nhật phiên bản (Force Update / Soft Update dialog).

---

### 📂 PHẦN 5: THÔNG BÁO & DEEP LINKING (`lib/core/services/`)
*Mục tiêu: Đảm bảo 100% thông báo đến người dùng và điều hướng chính xác đến trang đích.*

#### Các hạng mục công việc chi tiết:
- [x] **Xử lý toàn diện 3 trạng thái thông báo**:
  - **Foreground (In-App)**: Hiển thị Heads-Up Banner với âm thanh, rung (`high_importance_channel`).
  - **Background**: OS render trên Notification tray, tap vào đưa app lên foreground và điều hướng.
  - **Killed App / Terminated**: Bắt `getNotificationAppLaunchDetails()`, lưu `_pendingPayload`, sau khi khởi tạo Router thì tự động điều hướng (Cold Start deep link).
- [x] **Phân tích Payload JSON**: Bóc tách `route`, `id`, `type` và gọi `AppRouter.router.push()`.
- [ ] **Push Notification Topic & Segment**:
  - Phân luồng đăng ký topic: `all_users`, `news_promotion`, `order_updates_<userId>`.

---

### 📂 PHẦN 6: QUẢN LÝ TRẠNG THÁI & KIẾN TRÚC LOGIC (`lib/features/`)
*Mục tiêu: Tách biệt độc lập từng Feature, dễ dàng mở rộng và bảo trì khi team có 10-20 lập trình viên.*

#### Các hạng mục công việc chi tiết:
- [x] **Clean Architecture 3 Lớp (Feature-First)**:
  - **Domain Layer**: `Entities`, `Repositories (Interface)`, `UseCases`. Thuần Dart, 0 phụ thuộc UI/Framework.
  - **Data Layer**: `Models (JSON serialization)`, `DataSources (Remote/Local)`, `RepositoryImpl`.
  - **Presentation Layer**: `BLoC (Event/State)`, `Pages`, `Feature Widgets`.
- [x] **Functional Programming với `Either<Failure, T>`**:
  - Xử lý lỗi tường minh, bắt buộc UI phải xử lý cả 2 trường hợp Thất bại (Left) và Thành công (Right).
- [x] **Dependency Injection với `GetIt`**:
  - Service Locator tập trung, hỗ trợ đăng ký `LazySingleton` cho Core/Repository và `Factory` cho BLoCs.

---

### 📂 PHẦN 7: GIÁM SÁT SỰ CỐ & CRASH MONITORING (`lib/core/monitoring/`)
*Mục tiêu: Phát hiện và xử lý lỗi trước khi người dùng kịp phàn nàn trên Store.*

#### Các hạng mục công việc chi tiết:
- [ ] **Firebase Crashlytics & Sentry Integration**:
  - Bắt toàn bộ lỗi Flutter framework: `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError`.
  - Bắt toàn bộ lỗi Asynchronous/Platform: `PlatformDispatcher.instance.onError`.
- [ ] **Breadcrumbs Logging**:
  - Tự động ghi lại nhật ký 15 thao tác gần nhất của người dùng trước khi xảy ra crash (đã bấm nút nào, đã chuyển qua màn hình nào, mã lỗi API gần nhất) giúp tái hiện bug nhanh chóng.
- [ ] **Application Performance Monitoring (APM)**:
  - Đo lường độ trễ mạng (Network Latency) của từng API.
  - Đo lường thời gian render khung hình (Frame Render Time).

---

### 📂 PHẦN 8: KIỂM THỬ TỰ ĐỘNG & CHẤT LƯỢNG MÃ NGUỒN (`test/`)
*Mục tiêu: Đạt độ bao phủ kiểm thử (Test Coverage > 75%), ngăn chặn triệt để lỗi hồi quy (Regression bugs).*

#### Các hạng mục công việc chi tiết:
- [x] **Unit Testing Harness (`test/unit/`)**:
  - Test toàn bộ UseCases, Repositories, Helpers, Validators.
  - Test State Management với `bloc_test` và `mocktail`.
- [x] **Widget Testing Harness (`test/widget/`)**:
  - `tester.pumpApp(widget)`: Tự động giả lập môi trường `ScreenUtilInit`, `MaterialApp`, `Theme`, `BlocProvider`.
- [x] **Integration Testing (`test/integration/`)**:
  - Test luồng tích hợp liên tầng khép kín: Remote DataSource -> Local Storage -> UseCase -> BLoC State.
- [ ] **Golden Toolkit (Snapshot / Visual Regression Testing)**:
  - Tự động chụp ảnh pixel màn hình và so khớp để phát hiện giao diện bị lệch hoặc vỡ layout sau các commit code.

---

### 📂 PHẦN 9: CI/CD, AUTOMATION & RELEASE ENGINEERING (`.github/workflows/` / `fastlane/`)
*Mục tiêu: Tự động hóa 100% quy trình từ khi tạo Pull Request đến khi lên App Store & Google Play.*

#### Các hạng mục công việc chi tiết:
- [ ] **Quản lý Đa Môi Trường (Environment Flavors)**:
  - `dev`: API Development, logging đầy đủ, package name `com.example.app.dev`.
  - `staging`: API Staging tương đương production, test nghiệp vụ nội bộ.
  - `prod`: API Live Production, tắt toàn bộ debug log, bảo mật tối đa.
- [ ] **CI Pipeline (Pull Request Gatekeeper)**:
  - Chạy tự động mỗi khi tạo PR: `flutter analyze` + `flutter test` + format checking.
  - Chặn merge PR nếu có warning hoặc test failed.
- [ ] **CD Pipeline (Fastlane & GitHub Actions / Codemagic)**:
  - Tự động tăng build number (`version: 1.0.0+X`).
  - Tự động ký số (Signing KeyStore / Apple Distribution Certificate).
  - Tự động build **Android App Bundle (.aab)** và đẩy lên Google Play Console (Internal Testing Track).
  - Tự động build **iOS Archive (.ipa)** và đẩy lên TestFlight.
- [ ] **Tuân thủ Store Guidelines (Compliance Checklist)**:
  - Android: Target SDK 34+ (Android 14/15), 64-bit architecture, Privacy Policy link.
  - iOS: Apple Privacy Manifests (`PrivacyInfo.xcprivacy`), Account Deletion flow, In-App Purchase compliance.

---

## 📋 4. BẢNG CHECKLIST TỔNG HỢP TIẾN ĐỘ BASE PROJECT

| STT | Module & Hạng mục | Trạng thái hiện tại | Vị trí File / Thư mục |
| :---: | :--- | :---: | :--- |
| **1** | **Cấu trúc Clean Architecture + BLoC** | ✅ Đã hoàn thành | `lib/features/`, `lib/core/` |
| **2** | **Design System, Theme, Typography & ScreenUtil** | ✅ Đã hoàn thành | `lib/app/theme/` |
| **3** | **Router + Auth Guard + Dynamic Redirects** | ✅ Đã hoàn thành | `lib/app/router/app_router.dart` |
| **4** | **Bộ Shared Widgets Kit 25+ Components** | ✅ Đã hoàn thành | `lib/shared/widgets/` |
| **5** | **Network Dio + Refresh Token Queue + Failures** | ✅ Đã hoàn thành | `lib/core/network/` |
| **6** | **SecureStorage & LocalStorage Caching** | ✅ Đã hoàn thành | `lib/core/storage/` |
| **7** | **Đa ngôn ngữ JSON Localization (i18n)** | ✅ Đã hoàn thành | `assets/translations/`, `lib/app/` |
| **8** | **Notification 3 States (In-App, Background, Kill App)** | ✅ Đã hoàn thành | `lib/core/services/notification_service.dart` |
| **9** | **Testing Base (Unit, Widget, Integration, Mocks)** | ✅ Đã hoàn thành | `test/helpers/`, `test/unit/`, `test/widget/` |
| **10** | **SSL Pinning, Root/Jailbreak & Privacy Curtain** | ✅ Đã hoàn thành | `lib/core/security/`, `lib/core/security/security_service.dart` |
| **11** | **Crashlytics Monitoring & Analytics Tracking** | ✅ Đã hoàn thành | `lib/core/analytics/`, `lib/core/monitoring/` |
| **12** | **CI/CD Pipeline (Fastlane & GitHub Actions)** | ✅ Đã hoàn thành | `.github/workflows/`, `fastlane/` |

---

> 💡 **Khuyến nghị sử dụng**: Bản Blueprint này là kim chỉ nam tiêu chuẩn cho toàn bộ đội ngũ phát triển. Mỗi tính năng mới (New Feature) đều phải tuân thủ nghiêm ngặt theo các quy chuẩn trong tài liệu này.
