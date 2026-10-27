# Module: Authentication (`auth`)

- **Responsibility:** Quản lý toàn bộ vòng đời xác thực người dùng bao gồm đăng nhập, đăng xuất, lưu trữ phiên làm việc an toàn (Access Token, Refresh Token), và phát ra các trạng thái xác thực (`AuthState`) cho toàn ứng dụng.
- **Public API:**
  - `AuthBloc`, `AuthEvent`, `AuthState`, `AuthStatus`
  - `LoginUseCase`
  - `AuthRepository`
  - `UserEntity`
  - `LoginPage`
- **Internals:**
  - `AuthRemoteDataSource`, `AuthRemoteDataSourceImpl`
  - `AuthLocalDataSource`, `AuthLocalDataSourceImpl`
  - `AuthRepositoryImpl`
  - `UserModel`
- **Boundaries:**
  - Phụ thuộc: `core/network` (DioClient, ApiEndpoints, Exceptions, Failures), `core/storage` (SecureStorage, LocalStorage), `core/utils` (Logger, Validators).
  - Không có quan hệ phụ thuộc vòng (circular dependency) với các tính năng khác (`shop`, `home`).
