# 🏗️ Hướng Dẫn Kỹ Thuật & Quy Chuẩn Phát Triển (Technical Architecture & Guidelines)

Tài liệu này cung cấp quy chuẩn kiến trúc và hướng dẫn từng bước tạo mới một tính năng (**New Feature**) theo chuẩn **Clean Architecture** trong dự án `base_project`.

---

## 📑 Mục Lục
1. [Nguyên Tắc Kiến Trúc 3 Lớp (Clean Architecture Rules)](#1-nguyên-tắc-kiến-trúc-3-lớp-clean-architecture-rules)
2. [Quy Trình 10 Bước Tạo Tính Năng Mới Chuẩn Mực](#2-quy-trình-10-bước-tạo-tính-năng-mới-chuẩn-mực)
3. [Quy Chuẩn Xử Lý Mạng & Ngoại Lệ (Errors & Failures)](#3-quy-chuẩn-xử-lý-mạng--ngoại-lệ-errors--failures)
4. [Quy Chuẩn Cache & Hỗ Trợ Offline Mode (Hive CE)](#4-quy-chuẩn-cache--hỗ-trợ-offline-mode-hive-ce)
5. [Quy Chuẩn Viết Unit Test & Mocking (Mocktail)](#5-quy-chuẩn-viết-unit-test--mocking-mocktail)

---

## 1. Nguyên Tắc Kiến Trúc 3 Lớp (Clean Architecture Rules)

```
        +-----------------------------------+
        |       Presentation (BLoC + UI)    |
        +-----------------+-----------------+
                          | Phụ thuộc vào (Depends on)
                          v
        +-----------------------------------+
        |         Domain (Entities + UC)    |  <--- Trái tim của hệ thống (KHÔNG phụ thuộc vào thư viện bên ngoài)
        +-----------------+-----------------+
                          ^
                          | Thực thi (Implements)
        +-----------------+-----------------+
        |     Data (Models + DataSources)   |
        +-----------------------------------+
```

* **Quy tắc 1 (Domain Isolation)**: Tầng `domain/` là tầng thuần túy nhất. Không được `import` bất kỳ package UI nào (như `flutter/material.dart`), không phụ thuộc vào `dio`, `hive` hay `shared_preferences`.
* **Quy tắc 2 (Dependency Inversion)**: Tầng `domain/` định nghĩa Interface Contract của Repository. Tầng `data/` chịu trách nhiệm hiện thực hóa (`implements`) Interface đó.
* **Quy tắc 3 (Unidirectional Data Flow)**: Dữ liệu di chuyển 1 chiều: `UI -> BLoC Event -> UseCase -> Repository -> DataSource -> Network/Cache -> Repository -> Either<Failure, Entity> -> BLoC State -> UI Render`.

---

## 2. Quy Trình 10 Bước Tạo Tính Năng Mới Chuẩn Mực

Giả sử bạn cần tạo một tính năng mới tên là **`product`** (Danh sách sản phẩm):

### Bước 1: Tạo cấu trúc thư mục
```
lib/features/product/
├── data/
│   ├── datasources/
│   │   ├── product_remote_data_source.dart
│   │   └── product_local_data_source.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── product_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product_entity.dart
│   ├── repositories/
│   │   └── product_repository.dart
│   └── usecases/
│       └── get_products_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── product_bloc.dart
    │   ├── product_event.dart
    │   └── product_state.dart
    └── pages/
        └── product_list_page.dart
```

---

### Bước 2: Tạo Entity trong `domain/entities/product_entity.dart`
```dart
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, price, imageUrl];
}
```

---

### Bước 3: Tạo Repository Interface trong `domain/repositories/product_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({bool forceRefresh = false});
}
```

---

### Bước 4: Tạo UseCase trong `domain/usecases/get_products_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({bool forceRefresh = false}) {
    return _repository.getProducts(forceRefresh: forceRefresh);
  }
}
```

---

### Bước 5: Tạo Model trong `data/models/product_model.dart`
```dart
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'image_url': imageUrl,
  };
}
```

---

### Bước 6: Tạo Remote DataSource trong `data/datasources/product_remote_data_source.dart`
```dart
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dioClient.get<List<dynamic>>('/products');
    return (response.data ?? [])
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

---

### Bước 7: Tạo Repository Impl (tích hợp Cache & Offline) trong `data/repositories/product_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/errors/exceptions.dart';
import '../../../../core/network/errors/failures.dart';
import '../../../../core/storage/base_cache_policy.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final BaseCachePolicy _cachePolicy;

  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required BaseCachePolicy cachePolicy,
  })  : _remoteDataSource = remoteDataSource,
        _cachePolicy = cachePolicy;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({bool forceRefresh = false}) async {
    try {
      final products = await _cachePolicy.fetchWithCache<List<ProductModel>>(
        cacheKey: 'CACHE_PRODUCTS_LIST',
        ttl: const Duration(hours: 2), // Lưu cache trong 2 tiếng
        forceRefresh: forceRefresh,
        remoteCall: () => _remoteDataSource.fetchProducts(),
        toJson: (list) => list.map((e) => e.toJson()).toList(),
        fromJson: (json) => (json as List).map((e) => ProductModel.fromJson(e)).toList(),
      );
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
```

---

### Bước 8: Tạo BLoC trong `presentation/bloc/`
```dart
// product_event.dart
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class ProductFetchRequested extends ProductEvent {
  final bool forceRefresh;
  const ProductFetchRequested({this.forceRefresh = false});
}

// product_state.dart
enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductEntity> products;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}

// product_bloc.dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductBloc(this._getProductsUseCase) : super(const ProductState()) {
    on<ProductFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    ProductFetchRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await _getProductsUseCase(forceRefresh: event.forceRefresh);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
      )),
    );
  }
}
```

---

### Bước 9: Đăng ký Dependency Injection trong `lib/core/di/injection_container.dart`
```dart
// Feature Product
sl.registerLazySingleton<ProductRemoteDataSource>(
  () => ProductRemoteDataSourceImpl(sl()),
);

sl.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(
    remoteDataSource: sl(),
    cachePolicy: sl(),
  ),
);

sl.registerLazySingleton<GetProductsUseCase>(
  () => GetProductsUseCase(sl()),
);

sl.registerFactory<ProductBloc>(
  () => ProductBloc(sl()),
);
```

---

### Bước 10: Đăng ký Route trong `lib/app/router/app_router.dart`
```dart
GoRoute(
  path: '/products',
  name: 'products',
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    state: state,
    child: BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const ProductFetchRequested()),
      child: const ProductListPage(),
    ),
  ),
),
```

---

## 3. Quy Chuẩn Xử Lý Mạng & Ngoại Lệ (Errors & Failures)

Tất cả các lỗi mạng được phân loại và bọc thành `Failure` trong [failures.dart](file:///d:/base_project/lib/core/network/errors/failures.dart):

* `ServerFailure`: Lỗi phản hồi từ máy chủ (HTTP 400, 500...).
* `NetworkFailure`: Mất kết nối mạng hoặc Request Timeout.
* `UnauthorizedFailure`: Phiên làm việc hết hạn (HTTP 401).
* `CacheFailure`: Lỗi đọc ghi dữ liệu cục bộ.
* `UnexpectedFailure`: Ngoại lệ không xác định.

---

## 4. Quy Chuẩn Cache & Hỗ Trợ Offline Mode (Hive CE)

* Sử dụng [BaseCachePolicy](file:///d:/base_project/lib/core/storage/base_cache_policy.dart) để tự động quản lý vòng đời Cache.
* Khi offline, ứng dụng tự động lấy bản ghi Hive cũ hiển thị cho người dùng thay vì báo lỗi mất mạng ngay lập tức.
* Khi người dùng kéo làm mới (Pull-to-refresh), truyền `forceRefresh: true` để ép ứng dụng lấy dữ liệu mới nhất từ Server.
