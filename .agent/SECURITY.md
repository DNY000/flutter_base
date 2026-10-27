# SECURITY.md — System Security Guidelines

> **Core Contract:** Defense in depth, least privilege, zero trust for client input.

---

### 1. Authorization & Zero Trust
- **Least Privilege:** Grant only the minimum permissions necessary for the specific operation.
- **Zero Trust:** Treat all client inputs as untrusted. Enforce access control (RBAC/ABAC) on the server/domain; never rely solely on UI button visibility.

### 2. Input Sanitization & Injection Defense
- Validate and sanitize 100% of incoming data (parameters, queries, payloads, headers).
- **Prevent Injection:** Always use parameterized queries / ORM. Enforce payload size limits and rate limiting.

### 3. Data Protection & Cryptography
- **Passwords:** Always use salted hashing (e.g., Argon2, bcrypt); never store plaintext.
- **Sensitive Data:** Encrypt sensitive data at rest and in transit.
- **Log Masking:** Never log passwords, tokens, API keys, or personally identifiable information (PII).

### 4. Secrets Management
- ❌ Never hardcode API keys, passwords, or credentials into code or Git. 100% loaded via environment variables.
- Audit third-party dependencies periodically to remediate known CVEs.

### 5. Fail-Secure Behavior
- On auth/system failure $\rightarrow$ Default to **Deny by default** (fail-closed).
- Never expose stack traces, software versions, or database schemas in client error responses.
