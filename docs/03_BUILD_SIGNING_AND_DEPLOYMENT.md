# 📦 Hướng Dẫn Ký Số, Đóng Gói Ứng Dụng & Thiết Lập CI/CD (Build, Signing & Deployment)

Tài liệu này hướng dẫn chi tiết quy trình ký số bảo mật (App Signing), đóng gói bộ cài đặt (APK, AAB, IPA) sẵn sàng cho **Google Play Store**, **Apple App Store**, và thiết lập đường ống tích hợp liên tục **CI/CD Pipeline**.

---

## 📑 Mục Lục
1. [Ký Số Ứng Dụng Android (Android App Signing)](#1-ký-số-ứng-dụng-android-android-app-signing)
2. [Ký Số & Cấu Hình iOS (iOS Signing & Provisioning)](#2-ký-số--cấu-hình-ios-ios-signing--provisioning)
3. [Lệnh Đóng Gói Bản Release (Build Commands)](#3-lệnh-đóng-gói-bản-release-build-commands)
4. [Tối Ưu Dung Lượng Bản Build (App Size Optimization)](#4-tối-ưu-dung-lượng-bản-build-app-size-optimization)
5. [Tự Động Hóa CI/CD Bằng GitHub Actions](#5-tự-động-hóa-cicd-bằng-github-actions)

---

## 1. Ký Số Ứng Dụng Android (Android App Signing)

Để phát hành ứng dụng lên Google Play Store hoặc cài đặt production, ứng dụng Android bắt buộc phải được ký bằng một **Keystore** bí mật.

### Bước 1.1: Tạo Keystore mới
Chạy lệnh `keytool` sau trên terminal:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
* Nhập mật khẩu Keystore (lưu lại cẩn thận, không được làm mất).
* Điền thông tin họ tên, tổ chức theo hướng dẫn.

### Bước 1.2: Tạo file `android/key.properties`
Tạo file `android/key.properties` (File này phải được thêm vào `.gitignore` để không bị lộ lên Git):
```properties
storePassword=mat_khau_keystore_cua_ban
keyPassword=mat_khau_key_cua_ban
keyAlias=upload
storeFile=upload-keystore.jks
```

### Bước 1.3: Cấu hình `android/app/build.gradle`
Mở `android/app/build.gradle` và cấu hình `signingConfigs`:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## 2. Ký Số & Cấu Hình iOS (iOS Signing & Provisioning)

### Bước 2.1: Đăng ký Apple Developer Account
1. Đăng ký tài khoản tại [Apple Developer Portal](https://developer.apple.com/).
2. Tạo **Bundle Identifier** trùng với `ios/Runner.xcodeproj` (ví dụ: `com.company.baseproject`).

### Bước 2.2: Cấu hình Signing trong Xcode
1. Mở workspace: `open ios/Runner.xcworkspace`.
2. Chọn project **Runner** $\rightarrow$ Tab **Signing & Capabilities**.
3. Tại phần **Team**, chọn Apple Team của bạn.
4. Tích chọn **Automatically manage signing** (Xcode sẽ tự động tạo Certificates và Provisioning Profiles).

---

## 3. Lệnh Đóng Gói Bản Release (Build Commands)

### 3.1. Build Android App Bundle (AAB - Chuẩn bắt buộc để nộp Google Play)
```bash
flutter build appbundle --release --dart-define=ENVIRONMENT=PROD
```
> 📁 File xuất ra tại: `build/app/outputs/bundle/release/app-release.aab`

### 3.2. Build Android Universal APK (Cài trực tiếp hoặc gửi Tester)
```bash
flutter build apk --release --dart-define=ENVIRONMENT=PROD
```
> 📁 File xuất ra tại: `build/app/outputs/flutter-apk/app-release.apk`

### 3.3. Build APK chia nhỏ theo kiến trúc chip (Split ABI - Tối ưu dung lượng tải nhanh)
```bash
flutter build apk --release --split-per-abi --dart-define=ENVIRONMENT=PROD
```
> Sẽ tạo ra 3 file APK riêng biệt: `app-arm64-v8a-release.apk`, `app-armeabi-v7a-release.apk`, `app-x86_64-release.apk`.

### 3.4. Build iOS Archive & IPA (Nộp lên App Store / TestFlight)
```bash
flutter build ipa --release --dart-define=ENVIRONMENT=PROD
```
> 📁 File xuất ra tại: `build/ios/archive/Runner.xcarchive` và `build/ios/ipa/base_project.ipa`.

---

## 4. Tối Ưu Dung Lượng Bản Build (App Size Optimization)

Để phân tích chi tiết kích thước từng package và tài nguyên trong app:
```bash
# Phân tích kích thước file AAB
flutter build appbundle --analyze-size --dart-define=ENVIRONMENT=PROD

# Phân tích kích thước file APK
flutter build apk --analyze-size --dart-define=ENVIRONMENT=PROD
```
Công cụ sẽ xuất ra một file JSON phân tích chi tiết cây tài nguyên để bạn tinh giản các font chữ hoặc hình ảnh không cần thiết.

---

## 5. Tự Động Hóa CI/CD Bằng GitHub Actions

Dưới đây là file cấu hình workflow hoàn chỉnh cho GitHub Actions `.github/workflows/flutter_ci_cd.yml` giúp tự động chạy Test, Lint và Build APK khi có commit mới:

```yaml
name: Flutter CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test_and_lint:
    name: Run Tests & Static Analysis
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Verify Code Formatting
        run: dart format --output=none --set-exit-if-changed lib test

      - name: Static Analysis
        run: flutter analyze

      - name: Run Unit & Widget Tests
        run: flutter test --coverage

  build_android:
    name: Build Android Release
    needs: test_and_lint
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Build Android App Bundle (AAB)
        run: flutter build appbundle --release --dart-define=ENVIRONMENT=PROD

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release-bundle
          path: build/app/outputs/bundle/release/app-release.aab
```
