# 🔥 Hướng Dẫn Thiết Lập Firebase Toàn Diện (Firebase Setup Guide)

Tài liệu này hướng dẫn chi tiết từng bước tích hợp bộ công cụ **Firebase Suite** (Firebase Core, Crashlytics, Remote Config, Analytics, Cloud Messaging FCM) vào dự án Flutter `base_project`.

---

## 📑 Mục Lục
1. [Chuẩn Bị & Tạo Dự Án Firebase](#1-chuẩn-bị--tạo-dự-án-firebase)
2. [Thiết Lập Tự Động Bằng FlutterFire CLI (Khuyên Dùng)](#2-thiết-lập-tự-động-bằng-flutterfire-cli-khuyên-dùng)
3. [Thiết Lập Thủ Công Nền Tảng Android](#3-thiết-lập-thủ-công-nền-tảng-android)
4. [Thiết Lập Thủ Công Nền Tảng iOS](#4-thiết-lập-thủ-công-nền-tảng-ios)
5. [Cấu Hình Firebase Remote Config](#5-cấu-hình-firebase-remote-config)
6. [Cấu Hình Firebase Crashlytics & Giám Sát Crash](#6-cấu-hình-firebase-crashlytics--giám-sát-crash)
7. [Cấu Hình Firebase Cloud Messaging (FCM) & Push Notifications](#7-cấu-hình-firebase-cloud-messaging-fcm--push-notifications)

---

## 1. Chuẩn Bị & Tạo Dự Án Firebase

1. Truy cập vào [Firebase Console](https://console.firebase.google.com/).
2. Bấm **Add Project** (Thêm dự án), đặt tên dự án (ví dụ: `base-project-production`).
3. Bật tính năng **Google Analytics** cho dự án $\rightarrow$ Chọn tài khoản Analytics $\rightarrow$ Bấm **Create Project**.

---

## 2. Thiết Lập Tự Động Bằng FlutterFire CLI (Khuyên Dùng)

Phương pháp nhanh nhất và chuẩn xác nhất cho Flutter là sử dụng **FlutterFire CLI**:

### Bước 2.1: Cài đặt Firebase CLI & FlutterFire CLI
```bash
# 1. Cài đặt Firebase CLI (nếu chưa có Node.js / npm)
npm install -g firebase-tools

# 2. Đăng nhập vào tài khoản Google Firebase
firebase login

# 3. Kích hoạt FlutterFire CLI toàn cục
dart pub global activate flutterfire_cli
```

### Bước 2.2: Tự động cấu hình dự án
Chạy lệnh sau tại thư mục gốc của dự án:
```bash
flutterfire configure
```
* Chọn dự án Firebase bạn vừa tạo trên console.
* Chọn các nền tảng: `android`, `ios`, `web` (nếu có).
* Công cụ sẽ tự động tải về và tạo file cấu hình:
  * `android/app/google-services.json`
  * `ios/Runner/GoogleService-Info.plist`
  * `lib/firebase_options.dart`

---

## 3. Thiết Lập Thủ Công Nền Tảng Android

Nếu bạn cần kiểm tra hoặc cấu hình thủ công cho Android:

### Bước 3.1: Đặt file `google-services.json`
Copy file `google-services.json` tải từ Firebase Console vào đường dẫn:
```
android/app/google-services.json
```

### Bước 3.2: Cấu hình `android/build.gradle` (Project-level)
Mở file `android/build.gradle` và đảm bảo có các classpath sau trong block `dependencies`:
```groovy
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Plugin Google Services (Bắt buộc cho Firebase)
        classpath 'com.google.gms:google-services:4.4.2'
        // Plugin Firebase Crashlytics
        classpath 'com.google.firebase:firebase-crashlytics-gradle:3.0.2'
    }
}
```

### Bước 3.3: Cấu hình `android/app/build.gradle` (App-level)
Mở file `android/app/build.gradle` và thêm các plugin ở đầu hoặc cuối file:
```groovy
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'           // Google Services Plugin
apply plugin: 'com.google.firebase.crashlytics'          // Crashlytics Plugin

android {
    defaultConfig {
        applicationId "com.example.base_project"
        minSdkVersion 21                                  // Firebase yêu cầu tối thiểu Android SDK 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}
```

---

## 4. Thiết Lập Thủ Công Nền Tảng iOS

### Bước 4.1: Thêm `GoogleService-Info.plist` vào Xcode
1. Mở thư mục `ios` bằng phần mềm **Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Kéo thả file `GoogleService-Info.plist` vào cây thư mục `Runner` trong Xcode.
3. **Lưu ý quan trọng**: Tích chọn `Copy items if needed` và chọn Target là `Runner`.

### Bước 4.2: Cấu hình Capabilities trong Xcode (Cho Push Notification)
1. Trong Xcode, chọn project `Runner` $\rightarrow$ Chọn tab **Signing & Capabilities**.
2. Bấm nút **+ Capability**:
   * Thêm **Push Notifications**.
   * Thêm **Background Modes** $\rightarrow$ Tích chọn **Background fetch** và **Remote notifications**.

### Bước 4.3: Cập nhật `ios/Podfile`
Mở `ios/Podfile` và đảm bảo phiên bản iOS tối thiểu là 13.0:
```ruby
platform :ios, '13.0'
```
Sau đó chạy lệnh:
```bash
cd ios
pod install --repo-update
cd ..
```

---

## 5. Cấu Hình Firebase Remote Config

Dự án đã tích hợp sẵn cơ chế **Remote Config tự động đổ dữ liệu vào `AppConfig`**:

### Danh sách các Key mặc định trên Firebase Remote Config Console:

| Key trên Console | Kiểu dữ liệu | Giá trị mẫu | Mô tả |
| :--- | :--- | :--- | :--- |
| `api_base_url` | String | `https://api.production.com/v1` | Base URL của hệ thống Backend API |
| `app_min_version` | String | `1.0.0` | Phiên bản app tối thiểu (ép buộc cập nhật) |
| `enable_maintenance_mode` | Boolean | `false` | Bật/tắt chế độ bảo trì toàn hệ thống |
| `maintenance_message` | String | `Hệ thống đang bảo trì nâng cấp` | Thông báo bảo trì hiển thị cho người dùng |
| `enable_mock_data` | Boolean | `false` | Bật mock data cục bộ cho Tester |
| `socket_url` | String | `wss://ws.production.com` | Đường dẫn kết nối WebSocket |

> **Cách hoạt động:** Khi ứng dụng khởi động tại [main.dart](file:///d:/base_project/lib/main.dart), `RemoteConfigService` sẽ gọi `fetchAndActivate()` và tự động cập nhật vào `AppConfig.instance`. Bạn có thể đọc trực tiếp ở bất kỳ đâu qua `AppConfig.instance.apiBaseUrl`.

---

## 6. Cấu Hình Firebase Crashlytics & Giám Sát Crash

Dự án đã cấu hình bộ bắt lỗi toàn cục 2 lớp tại [CrashMonitoringServiceImpl](file:///d:/base_project/lib/core/services/crash_monitoring_service.dart):

1. **Lớp 1 (Flutter Framework Errors)**: Tự động bắt toàn bộ lỗi render UI thông qua `FlutterError.onError`.
2. **Lớp 2 (Platform & Async Errors)**: Tự động bắt các Exception bất đồng bộ thông qua `PlatformDispatcher.instance.onError`.

### Cách gửi lỗi tùy chỉnh & Breadcrumb trong code:
```dart
final crashService = sl<ICrashMonitoringService>();

// Ghi nhật ký hành động người dùng trước khi xảy ra lỗi (Breadcrumb)
await crashService.logBreadcrumb('Người dùng bấm nút Thanh toán đơn hàng #123');

// Ghi nhận lỗi có kiểm soát (Non-fatal error)
try {
  // logic...
} catch (e, stackTrace) {
  await crashService.recordError(e, stackTrace, reason: 'Lỗi parse dữ liệu giỏ hàng');
}

// Gắn User ID khi người dùng đăng nhập thành công
await crashService.setUserIdentifier(user.id);
```

---

## 7. Cấu Hình Firebase Cloud Messaging (FCM) & Push Notifications

Dự án sử dụng [NotificationService](file:///d:/base_project/lib/core/services/notification_service.dart) để xử lý toàn bộ 3 trạng thái của thông báo:

1. **Foreground**: Tự động hiển thị Heads-up Banner cục bộ có âm thanh và độ ưu tiên cao (`high_importance_channel`).
2. **Background**: Lắng nghe khi người dùng bấm vào thông báo từ thanh Notification Bar $\rightarrow$ Tự động bóc tách payload và chuyển hướng qua `GoRouter`.
3. **Terminated / Killed App (Cold Start)**: Khi ứng dụng bị tắt hoàn toàn, việc bấm vào thông báo sẽ mở app $\rightarrow$ lưu `pendingPayload` $\rightarrow$ thực thi điều hướng ngay sau khi khung hình đầu tiên render xong.

### Payload Mẫu gửi từ Firebase Console / Server Backend:
```json
{
  "notification": {
    "title": "Đơn hàng của bạn đã sẵn sàng!",
    "body": "Bấm vào để xem chi tiết lộ trình vận chuyển"
  },
  "data": {
    "route": "/home",
    "type": "ORDER_DETAIL",
    "id": "ord_998811"
  }
}
```
