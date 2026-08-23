/*
 * ==============================================================================
 * [AuthBloc Test] - Kiểm Thử Luồng Sự Kiện & Trạng Thái State Management
 * ==============================================================================
 */

import 'package:base_project/core/network/errors/failures.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() async {
    await authBloc.close();
  });

  group('AuthBloc', () {
    test('trạng thái khởi tạo ban đầu phải là AuthStatus.initial', () {
      expect(authBloc.state.status, AuthStatus.initial);
      expect(authBloc.state.user, isNull);
    });

    blocTest<AuthBloc, AuthState>(
      'phát ra [loading, authenticated] khi AuthLoginSubmitted thành công',
      setUp: () {
        when(() => mockLoginUseCase(TestFixtures.testLoginParams))
            .thenAnswer((_) async => const Right(TestFixtures.testUserEntity));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
        const AuthLoginSubmitted(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.authenticated,
          user: TestFixtures.testUserEntity,
        ),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(TestFixtures.testLoginParams)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'phát ra [loading, failure] khi AuthLoginSubmitted thất bại',
      setUp: () {
        when(() => mockLoginUseCase(TestFixtures.testLoginParams)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Sai mật khẩu')),
        );
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
        const AuthLoginSubmitted(
          email: TestFixtures.testEmail,
          password: TestFixtures.testPassword,
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Sai mật khẩu',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'phát ra [loading, unauthenticated] khi AuthLogoutRequested được gọi',
      setUp: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.unauthenticated, user: null),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.logout()).called(1);
      },
    );
  });
}
