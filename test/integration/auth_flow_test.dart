/*
 * ==============================================================================
 * [Auth Flow Integration Test] - Kiểm Thử Tích Hợp Luồng Xác Thực (Data -> Domain -> BLoC)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Kiểm thử tích hợp toàn bộ chuỗi mắt xích từ DataSource -> Repository -> UseCase -> BLoC.
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Integration test verifying end-to-end flow from data sources to bloc states.
 * ==============================================================================
 */

import 'package:base_project/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:base_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:base_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockDioClient mockDioClient;
  late MockSecureStorage mockSecureStorage;
  late MockLocalStorage mockLocalStorage;
  late MockNetworkInfo mockNetworkInfo;

  late AuthRemoteDataSource remoteDataSource;
  late AuthLocalDataSourceImpl localDataSource;
  late AuthRepositoryImpl authRepository;
  late LoginUseCase loginUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockDioClient = MockDioClient();
    mockSecureStorage = MockSecureStorage();
    mockLocalStorage = MockLocalStorage();
    mockNetworkInfo = MockNetworkInfo();

    remoteDataSource = AuthRemoteDataSourceImpl(mockDioClient);
    localDataSource = AuthLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
      localStorage: mockLocalStorage,
    );
    authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: mockNetworkInfo,
    );
    loginUseCase = LoginUseCase(authRepository);
    authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      authRepository: authRepository,
    );
  });

  tearDown(() async {
    await authBloc.close();
  });

  group('Auth Flow Integration Test', () {
    blocTest<AuthBloc, AuthState>(
      'toàn bộ chuỗi xác thực hoạt động trơn tru từ Remote -> Local Storage -> BLoC State',
      setUp: () {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSecureStorage.saveAccessToken(any())).thenAnswer((_) async {});
        when(() => mockSecureStorage.saveRefreshToken(any())).thenAnswer((_) async {});
        when(() => mockLocalStorage.setObject(any(), any())).thenAnswer((_) async => true);
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
        const AuthLoginSubmitted(
          email: 'integration@test.com',
          password: 'password123',
        ),
      ),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.authenticated)
            .having((s) => s.user?.email, 'user email', 'integration@test.com'),
      ],
      verify: (_) {
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockSecureStorage.saveAccessToken(any())).called(1);
        verify(() => mockSecureStorage.saveRefreshToken(any())).called(1);
        verify(() => mockLocalStorage.setObject(any(), any())).called(1);
      },
    );
  });
}
