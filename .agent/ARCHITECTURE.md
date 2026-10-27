# ARCHITECTURE.md — System Design & Boundaries

> **Core Contract:** Strict layering, unidirectional data flow, modular boundaries.

---

### 1. 3-Tier Layering & Separation of Concerns
- **Presentation (Entrypoint):** UI, Controllers, CLI. Validates input, delegates to Domain, formats output. No business logic allowed.
- **Domain (Core Business):** Entities, Business Rules, Logic. **100% independent** of frameworks, UI, databases, and third-party tools.
- **Infrastructure (Data & External):** Databases, APIs, Cache, File system. Implements contracts/interfaces defined by Domain.

### 2. Unidirectional Data Flow
- Strict direction: `Entrypoint → Domain → Infrastructure → Output`.
- Outer layers depend on inner layers; inner layers know nothing about outer layers. No upward calls, no shortcuts.

### 3. Module Boundaries (Loose Coupling)
- Modules communicate exclusively through **Public Interfaces/Contracts**.
- ❌ Never access private/internal files of other modules directly.
- ❌ Never create circular dependencies (`Module A ↔ Module B`).

### 4. State & Lifecycle Management
- **Single Source of Truth:** Never duplicate state across components.
- **Resource Cleanup:** Always dispose/cancel streams, listeners, timers, and connections on teardown to eliminate memory leaks.

### 5. Cross-Cutting Security Architecture
- **Entrypoint:** Validate, sanitize, and rate-limit all inputs at the boundary.
- **Domain:** Enforce business authorization rules (RBAC/ABAC).
- **Infrastructure:** Encrypt sensitive stored data; load secrets from external environment.
