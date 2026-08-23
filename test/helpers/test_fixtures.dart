/*
 * ==============================================================================
 * [TestFixtures] - Dữ Liệu Mẫu Cho Kiểm Thử (Test Dummy Data)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Cung cấp các thực thể, model và thông số mẫu để dùng trong Unit / Widget / Integration Test.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Pre-built dummy data and fixtures for test assertions.
 * ==============================================================================
 */

import 'package:base_project/features/auth/data/models/user_model.dart';
import 'package:base_project/features/auth/domain/entities/user_entity.dart';
import 'package:base_project/features/auth/domain/usecases/login_usecase.dart';

class TestFixtures {
  TestFixtures._();

  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testAccessToken = 'mock_access_token_12345';
  static const String testRefreshToken = 'mock_refresh_token_67890';

  static const UserEntity testUserEntity = UserEntity(
    id: 'usr_001',
    email: testEmail,
    name: 'TEST USER',
    avatarUrl: 'https://example.com/avatar.jpg',
    phoneNumber: '+84987654321',
  );

  static const UserModel testUserModel = UserModel(
    id: 'usr_001',
    email: testEmail,
    name: 'TEST USER',
    avatarUrl: 'https://example.com/avatar.jpg',
    phoneNumber: '+84987654321',
  );

  static const LoginParams testLoginParams = LoginParams(
    email: testEmail,
    password: testPassword,
  );
}
