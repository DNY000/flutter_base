/*
 * ==============================================================================
 * [LoginUseCase Test] - Kiểm Thử Tầng Nghiệp Vụ Domain Layer
 * ==============================================================================
 */

import 'package:base_project/core/network/errors/failures.dart';
import 'package:base_project/features/auth/domain/entities/user_entity.dart';
import 'package:base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    test('nên trả về UserEntity khi đăng nhập thành công từ Repository', () async {
      // Arrange (Chuẩn bị)
      when(
        () => mockAuthRepository.login(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ).thenAnswer((_) async => const Right<Failure, UserEntity>(TestFixtures.testUserEntity));

      // Act (Thực thi)
      final result = await useCase(TestFixtures.testLoginParams);

      // Assert (Kiểm chứng)
      expect(result, const Right<Failure, UserEntity>(TestFixtures.testUserEntity));
      verify(
        () => mockAuthRepository.login(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('nên trả về ServerFailure khi đăng nhập thất bại từ Repository', () async {
      // Arrange
      const expectedFailure = ServerFailure(message: 'Tài khoản không tồn tại');
      when(
        () => mockAuthRepository.login(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ).thenAnswer((_) async => const Left<Failure, UserEntity>(expectedFailure));

      // Act
      final result = await useCase(TestFixtures.testLoginParams);

      // Assert
      expect(result, const Left<Failure, UserEntity>(expectedFailure));
      verify(
        () => mockAuthRepository.login(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ).called(1);
    });
  });
}
