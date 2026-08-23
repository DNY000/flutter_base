# 💻 Bảng Câu Lệnh CLI & Cấu Hình Đa Môi Trường (Commands & Flavors)

Tài liệu này tổng hợp toàn bộ các câu lệnh dòng lệnh (CLI) thiết yếu nhất để phát triển, kiểm thử, và chạy dự án `base_project` trên các môi trường khác nhau.

---

## 📑 Mục Lục
1. [Cấu Hình Đa Môi Trường (Flavors / Environments)](#1-cấu-hình-đa-môi-trường-flavors--environments)
2. [Lệnh Chạy Ứng Dụng (Run Commands)](#2-lệnh-chạy-ứng-dụng-run-commands)
3. [Lệnh Kiểm Thử & Đo Độ Phủ Code (Testing & Coverage)](#3-lệnh-kiểm-thử--đo-độ-phủ-code-testing--coverage)
4. [Lệnh Quản Lý Dependencies & Assets](#4-lệnh-quản-lý-dependencies--assets)
5. [Lệnh Phân Tích & Định Dạng Code (Analysis & Linting)](#5-lệnh-phân-tích--định-dạng-code-analysis--linting)
6. [Lệnh Dọn Dẹp & Xử Lý Sự Cố (Clean & Troubleshooting)](#6-lệnh-dọn-dẹp--xử-lý-sự-cố-clean--troubleshooting)

---

## 1. Cấu Hình Đa Môi Trường (Flavors / Environments)

Dự án hỗ trợ 3 môi trường chạy độc lập được quản lý bởi [AppConfig](file:///d:/base_project/lib/core/config/app_config.dart):

| Môi trường | Cờ truyền vào (`--dart-define`) | API Base URL Mặc Định | Bật Logger / Debug |
| :--- | :--- | :--- | :--- |
| **DEV** | `ENVIRONMENT=DEV` | `https://api-dev.example.com/v1` | ✅ Bật |
| **STAGING** | `ENVIRONMENT=STAGING` | `https://api-staging.example.com/v1` | ✅ Bật |
| **PROD** | `ENVIRONMENT=PROD` | `https://api.example.com/v1` | ❌ Tắt |

### Các biến cấu hình bổ sung có thể truyền qua CLI:
* `API_BASE_URL`: Ghi đè Base URL của API (Ví dụ: `https://my-custom-api.com/v1`).
* `ENABLE_MOCK_DATA`: Bật/tắt dữ liệu giả định cục bộ (`true` hoặc `false`).
* `APP_NAME`: Tên ứng dụng hiển thị tùy chỉnh.

---

## 2. Lệnh Chạy Ứng Dụng (Run Commands)

### 2.1. Chạy trên môi trường Phát triển (DEV)
```bash
flutter run --dart-define=ENVIRONMENT=DEV
```

### 2.2. Chạy trên môi trường Thử nghiệm (STAGING)
```bash
flutter run --dart-define=ENVIRONMENT=STAGING
```

### 2.3. Chạy trên môi trường Thực tế (PROD) ở chế độ Release
```bash
flutter run --release --dart-define=ENVIRONMENT=PROD
```

### 2.4. Chạy kèm ghi đè biến URL cụ thể
```bash
flutter run --dart-define=ENVIRONMENT=DEV --dart-define=API_BASE_URL=https://192.168.1.100:8080/api
```

### 2.5. Chỉ định thiết bị cụ thể
```bash
# Xem danh sách thiết bị
flutter devices

# Chạy trên thiết bị cụ thể qua Device ID
flutter run -d <DEVICE_ID> --dart-define=ENVIRONMENT=DEV
```

---

## 3. Lệnh Kiểm Thử & Đo Độ Phủ Code (Testing & Coverage)

### 3.1. Chạy toàn bộ Test Suite (Unit, Integration, Widget Tests)
```bash
flutter test
```

### 3.2. Chạy một thư mục hoặc một file test cụ thể
```bash
# Chạy toàn bộ Unit test của Core
flutter test test/unit/core/

# Chạy test luồng Auth Flow
flutter test test/integration/auth_flow_test.dart

# Chạy test Widget Button
flutter test test/widget/shared/app_button_test.dart
```

### 3.3. Xuất báo cáo độ phủ Code (Code Coverage)
```bash
# Chạy test và tạo thư mục coverage/lcov.info
flutter test --coverage

# Xem chi tiết dòng code được phủ bằng công cụ genhtml (nếu đã cài lcov)
genhtml coverage/lcov.info -o coverage/html
```

---

## 4. Lệnh Quản Lý Dependencies & Assets

### 4.1. Tải và cài đặt thư viện mới
```bash
# Tải lại toàn bộ dependencies trong pubspec.yaml
flutter pub get

# Thêm một package mới vào dự án
flutter pub add <tên_package>

# Kiểm tra các package có bản cập nhật mới
flutter pub outdated
```

### 4.2. Khởi tạo & Cập nhật đa ngôn ngữ (EasyLocalization)
Nếu bạn thêm mới các key trong `assets/translations/vi.json` hoặc `en.json`, ứng dụng sẽ tự động tải lại mà không cần build runner.

---

## 5. Lệnh Phân Tích & Định Dạng Code (Analysis & Linting)

Dự án áp dụng bộ quy chuẩn linter nghiêm ngặt `flutter_lints`:

```bash
# 1. Phân tích tĩnh toàn bộ mã nguồn (Static Analysis)
flutter analyze

# 2. Tự động định dạng lại toàn bộ file dart theo chuẩn của Google (Dart Format)
dart format lib test

# 3. Tự động sửa các lỗi linter có thể fix tự động
dart fix --apply
```

---

## 6. Lệnh Dọn Dẹp & Xử Lý Sự Cố (Clean & Troubleshooting)

Khi gặp lỗi build Android/iOS không rõ nguyên nhân, cache cũ hoặc xung đột Pods:

```bash
# 1. Xóa toàn bộ build artifacts và cache Flutter
flutter clean

# 2. Tải lại dependencies
flutter pub get

# 3. Dọn dẹp và cài đặt lại CocoaPods cho iOS (Trên macOS)
cd ios
rm -rf Pods Podfile.lock .symlinks
pod cache clean --all
pod install --repo-update
cd ..

# 4. Kiểm tra sức khỏe toàn bộ môi trường lập trình
flutter doctor -v
```
