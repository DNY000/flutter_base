# Module: Home & Showcase (`home`)

- **Responsibility:** Màn hình chính đóng vai trò Gallery & Trình diễn (Showcase) toàn bộ hệ sinh thái UI, Design System Tokens, Shared Widgets, và các tương tác mẫu (Localization, Notification, Confirm Dialogs).
- **Public API:**
  - `HomePage`
- **Internals:**
  - Các widget con nội bộ dùng riêng cho trang showcase.
- **Boundaries:**
  - Phụ thuộc: `shared/widgets`, `core/services` (NotificationService), `core/storage` (LocalStorage), `app/theme`, `app/router`.
  - Giao tiếp với `auth` chỉ qua public `AuthBloc` và `RouteNames.login`.
