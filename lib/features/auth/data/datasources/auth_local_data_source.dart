import '../../../../app/constants/app_constants.dart';
import '../../../../core/network/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(
      {required String accessToken, required String refreshToken});
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<String?> getAccessToken();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final ISecureStorage _secureStorage;
  final ILocalStorage _localStorage;

  AuthLocalDataSourceImpl({
    required ISecureStorage secureStorage,
    required ILocalStorage localStorage,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _secureStorage.saveAccessToken(accessToken);
      await _secureStorage.saveRefreshToken(refreshToken);
    } catch (e) {
      throw CacheException('Không thể lưu token bảo mật: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _localStorage.setObject(AppConstants.keyUserData, user.toJson());
    } catch (e) {
      throw CacheException('Không thể lưu thông tin người dùng: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final json = _localStorage.getObject(AppConstants.keyUserData);
      if (json == null) return null;
      return UserModel.fromJson(json);
    } catch (e) {
      throw CacheException('Không thể đọc dữ liệu người dùng: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await _secureStorage.clearAll();
      await _localStorage.remove(AppConstants.keyUserData);
    } catch (e) {
      throw CacheException('Không thể xóa dữ liệu phiên làm việc: $e');
    }
  }
}
