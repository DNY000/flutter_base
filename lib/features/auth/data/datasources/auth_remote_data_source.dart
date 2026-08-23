import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    // Trong môi trường thực tế:
    // final response = await _dioClient.post<Map<String, dynamic>>(
    //   ApiEndpoints.login,
    //   data: {'email': email, 'password': password},
    // );
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (password == 'error123') {
      throw Exception('Tài khoản hoặc mật khẩu không chính xác');
    }

    final mockUser = UserModel(
      id: 'usr_001',
      email: email,
      name: email.split('@').first.toUpperCase(),
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      phoneNumber: '+84987654321',
    );

    return (
      user: mockUser,
      accessToken: 'mock_jwt_access_token_xyz',
      refreshToken: 'mock_jwt_refresh_token_abc',
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post<dynamic>(ApiEndpoints.logout);
    } catch (_) {
      // Bỏ qua lỗi remote khi logout để luôn dọn sạch local
    }
  }
}
