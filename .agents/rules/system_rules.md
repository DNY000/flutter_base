# System Rules & Standards Compliance

Before reading, generating, or modifying code in this workspace, the agent MUST strictly enforce the 6 foundational rulebooks located in `.agent/`:

1. **Playbook & Lifecycle** (`.agent/AGENTS.md`):
   - Adhere to the 6-step operational lifecycle: Ground truth over assumptions, minimal blast radius, never hallucinate completion.
   - Command Matrix: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --debug`.

2. **System Design & Boundaries** (`.agent/ARCHITECTURE.md`):
   - 3-tier layering: Presentation (UI/Controllers) -> Domain (Pure Business, 0 external framework dependencies) -> Infrastructure (Data & External).
   - Unidirectional data flow: Outer layers depend on inner layers; inner layers know nothing about outer layers.
   - Module boundaries: Loose coupling, access exclusively via public API contracts/barrel exports (`auth.dart`, `shop.dart`), never access private internals directly.

3. **Code Standards & Modularity** (`.agent/CODING.md`):
   - Each module MUST maintain a `MODULE.md` file.
   - Zero silent failures: Never write empty `catch` blocks. Always log with `AppLogger` or bubble up errors.
   - Clean code: Single responsibility, intent-revealing names, prefer immutability, zero dead code, standard TODO format.

4. **System Security** (`.agent/SECURITY.md`):
   - Defense in depth, least privilege, zero trust for client input.
   - Log masking: Never log tokens (Bearer tokens), passwords, or PII. PrettyDioLogger requestHeader must remain false.
   - Secrets management: Load secrets through environment variables/AppConfig, never commit plain credentials.

5. **Testing Strategy** (`.agent/TESTING.md`):
   - Testing pyramid: Unit tests (core focus), Integration tests, authentic Smoke tests (critical business journeys).
   - 4 mandatory edge cases: Happy Path, Empty/Null, Boundary Values, Error Scenarios.
   - Security testing: 401/403 auth bypass protection, injection defense, data leakage.
   - Definition of Done: 100% tests must pass. Never weaken assertions.

6. **Release Readiness & Deployment** (`.agent/DEPLOY.md`):
   - 12-Factor config separation: Endpoints and flags managed through AppConfig.
   - Pre-release checklist: 0 linter errors, 100% tests pass, debug credentials removed.
