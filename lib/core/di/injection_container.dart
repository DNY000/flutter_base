/*
 * ==============================================================================
 * [Dependency Injection] - Bộ Đăng Ký Service Locator Tập Trung (GetIt)
 * ==============================================================================
 */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/shop/data/datasources/shop_remote_data_source.dart';
import '../../features/shop/data/repositories/product_repository_impl.dart';
import '../../features/shop/domain/repositories/product_repository.dart';
import '../../features/shop/domain/usecases/shop_usecases.dart';
import '../../features/shop/presentation/bloc/cart_bloc.dart';
import '../../features/shop/presentation/bloc/shop_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/analytics_service.dart';
import '../services/crash_monitoring_service.dart';
import '../services/file_transfer_service.dart';
import '../services/notification_service.dart';
import '../services/permission_service.dart';
import '../services/remote_config_service.dart';
import '../storage/base_cache_policy.dart';
import '../storage/hive_storage.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External Packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // 2. Core Infrastructure (Storage, Network, Services, Security, Monitoring)
  sl.registerLazySingleton<ISecureStorage>(
    () => SecureStorageImpl(storage: sl()),
  );
  sl.registerLazySingleton<ILocalStorage>(
    () => LocalStorageImpl(prefs: sl()),
  );
  sl.registerLazySingleton<IHiveStorage>(
    () => HiveStorageImpl(),
  );
  sl.registerLazySingleton<BaseCachePolicy>(
    () => BaseCachePolicy(hiveStorage: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<INetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  sl.registerLazySingleton<DioClient>(
    () => DioClient(secureStorage: sl()),
  );
  sl.registerLazySingleton<IFileTransferService>(
    () => FileTransferServiceImpl(sl()),
  );
  sl.registerLazySingleton<INotificationService>(
    () => NotificationServiceImpl(),
  );
  sl.registerLazySingleton<IAnalyticsService>(
    () => AnalyticsServiceImpl(),
  );
  sl.registerLazySingleton<ICrashMonitoringService>(
    () => CrashMonitoringServiceImpl(),
  );
  sl.registerLazySingleton<IRemoteConfigService>(
    () => RemoteConfigServiceImpl(),
  );
  sl.registerLazySingleton<IPermissionService>(
    () => PermissionServiceImpl(),
  );

  // 3. Feature Auth
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), localStorage: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  // BLoCs (Factory để tạo instance mới khi cần)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // 4. Feature Shop & E-Commerce
  // Data Sources
  sl.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      cachePolicy: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductDetailUseCase>(
    () => GetProductDetailUseCase(sl()),
  );
  sl.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );

  // BLoCs
  sl.registerLazySingleton<CartBloc>(() => CartBloc());
  sl.registerFactory<ShopBloc>(
    () => ShopBloc(
      getProductsUseCase: sl(),
      getProductDetailUseCase: sl(),
      searchProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );
}
