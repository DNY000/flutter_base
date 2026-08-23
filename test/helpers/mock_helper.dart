/*
 * ==============================================================================
 * [MockHelper] - Tập Hợp Khai Báo Mock Chuẩn (Mocktail)
 * ==============================================================================
 */

import 'package:base_project/core/network/dio_client.dart';
import 'package:base_project/core/network/network_info.dart';
import 'package:base_project/core/services/analytics_service.dart';
import 'package:base_project/core/services/crash_monitoring_service.dart';
import 'package:base_project/core/services/file_transfer_service.dart';
import 'package:base_project/core/services/notification_service.dart';
import 'package:base_project/core/services/permission_service.dart';
import 'package:base_project/core/services/remote_config_service.dart';
import 'package:base_project/core/storage/hive_storage.dart';
import 'package:base_project/core/storage/local_storage.dart';
import 'package:base_project/core/storage/secure_storage.dart';
import 'package:base_project/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:base_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:base_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:base_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:base_project/features/shop/domain/entities/product_entity.dart';
import 'package:base_project/features/shop/domain/repositories/product_repository.dart';
import 'package:base_project/features/shop/domain/usecases/shop_usecases.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_bloc.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_event.dart';
import 'package:base_project/features/shop/presentation/bloc/cart_state.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_event.dart';
import 'package:base_project/features/shop/presentation/bloc/shop_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Core Services & Infrastructure Mocks
class MockDioClient extends Mock implements DioClient {}
class MockSecureStorage extends Mock implements ISecureStorage {}
class MockLocalStorage extends Mock implements ILocalStorage {}
class MockHiveStorage extends Mock implements IHiveStorage {}
class MockNetworkInfo extends Mock implements INetworkInfo {}
class MockNotificationService extends Mock implements INotificationService {}
class MockAnalyticsService extends Mock implements IAnalyticsService {}
class MockCrashMonitoringService extends Mock implements ICrashMonitoringService {}
class MockRemoteConfigService extends Mock implements IRemoteConfigService {}
class MockFileTransferService extends Mock implements IFileTransferService {}
class MockPermissionService extends Mock implements IPermissionService {}

// 2. Auth Data Mocks
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockAuthRepository extends Mock implements AuthRepository {}

// 3. Auth Domain Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}

// 4. Auth Presentation Mocks
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// 5. Shop Mocks
class MockProductRepository extends Mock implements ProductRepository {}
class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}
class MockGetProductDetailUseCase extends Mock implements GetProductDetailUseCase {}
class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockShopBloc extends MockBloc<ShopEvent, ShopState> implements ShopBloc {}
class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}
