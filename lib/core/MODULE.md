# Module: Core (`core`)

- **Responsibility:** Nền tảng hạ tầng kỹ thuật dùng chung cho toàn bộ dự án, bao gồm cấu hình ứng dụng (`config`), mạng HTTP & Interceptors (`network`), lưu trữ và bộ nhớ đệm (`storage`), Dependency Injection (`di`), các dịch vụ nền tảng native (`services`), và các tiện ích dùng chung (`utils`).
- **Public API:**
  - `AppConfig`, `Environment`
  - `DioClient`, `AuthInterceptor`, `ApiEndpoints`, `Failure`, `ServerFailure`, `NetworkFailure`
  - `ISecureStorage`, `ILocalStorage`, `IHiveStorage`, `BaseCachePolicy`
  - `sl` (Service Locator GetIt), `initDependencies()`
  - `INotificationService`, `IAnalyticsService`, `IRemoteConfigService`, `IPermissionService`
  - `AppLogger`, `CurrencyFormatter`, `DateFormatter`, `AppValidators`, `Debouncer`, `Throttler`
- **Internals:**
  - Implementations của Storage (`SecureStorageImpl`, `LocalStorageImpl`, `HiveStorageImpl`).
  - Implementations của Services (`NotificationServiceImpl`, `AnalyticsServiceImpl`, `RemoteConfigServiceImpl`).
- **Boundaries:**
  - `core` là tầng hạ tầng thấp nhất; **tuyệt đối không phụ thuộc vào bất kỳ feature nào** trong `lib/features/`.
