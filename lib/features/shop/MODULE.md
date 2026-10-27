# Module: Shop (`shop`)

- **Responsibility:** Quản lý chức năng thương mại điện tử (E-Commerce) bao gồm duyệt danh mục sản phẩm, tìm kiếm, xem chi tiết sản phẩm, và quản lý giỏ hàng mua sắm (thêm, cập nhật số lượng, xóa, thanh toán).
- **Public API:**
  - `ShopBloc`, `ShopEvent`, `ShopState`, `ShopStatus`
  - `CartBloc`, `CartEvent`, `CartState`, `CartItem`
  - `ProductEntity`
  - `GetProductsUseCase`, `GetProductDetailUseCase`, `SearchProductsUseCase`, `GetCategoriesUseCase`
  - `ProductRepository`
  - `ShopCatalogPage`, `ProductDetailPage`, `CartPage`
- **Internals:**
  - `ShopRemoteDataSource`, `ShopRemoteDataSourceImpl`
  - `ProductRepositoryImpl`
  - `ProductModel`
- **Boundaries:**
  - Phụ thuộc: `core/network` (DioClient, Failures), `shared/widgets`, `app/theme`, `app/router`.
  - Không truy cập private internals của các feature khác (`auth`, `home`).
