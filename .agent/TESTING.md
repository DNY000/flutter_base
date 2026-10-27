# TESTING.md — Testing Strategy & Verification

> **Core Contract:** Isolated tests, 4 mandatory edge cases, security validation, zero hallucinated passes.

---

### 1. Testing Pyramid
- **Unit Tests (Core Focus):** Domain logic, utilities, mappers. Fast, isolated, reliable.
- **Integration Tests:** Interaction between adjacent layers (Repository ↔ DB/API).
- **Smoke Tests:** Critical business journeys only (e.g., auth, primary workflow).

### 2. Isolation & Mocking
- Tests must be 100% independent of execution order.
- **Mock 100% External I/O:** Network requests, databases, file system, and system clock.

### 3. The 4 Mandatory Edge Cases
1. **Happy Path:** Valid input produces expected output.
2. **Empty / Null:** Empty inputs, blank strings, null/undefined payloads.
3. **Boundary Values:** Minimum, maximum, negative values, length limits.
4. **Error Scenarios:** Network drops, timeouts, 4xx/5xx responses, authorization errors.

### 4. Security Testing
- **Auth Bypass:** Unauthorized requests must receive 401/403.
- **Injection:** Malicious payloads must be safely rejected without crashing.
- **Data Leakage:** Responses and logs must not contain secrets or sensitive tokens.

### 5. Definition of Done (DoD)
- Run commands and verify 100% pass before reporting completion.
- ❌ **Never weaken assertions** or comment out tests to force a passing suite.
