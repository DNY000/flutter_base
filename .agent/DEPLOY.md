# DEPLOY.md — Release Readiness & Operations

> **Core Contract:** Code separated from config, immutable artifacts, pre-release checklist, rollback plan.

---

### 1. Config & Code Separation (Twelve-Factor)
- One codebase runs across all environments (`Development`, `Production`).
- 100% of endpoints, secrets, and feature flags injected via environment variables.
- ❌ Never commit secrets (API keys, passwords, private keys) to Git.

### 2. Immutable Artifacts
- The same built artifact moves through environments without rebuilding.
- ❌ Never modify running code directly on deployed environments.

### 3. Pre-Release Checklist
- [ ] 0 linter / static analysis / typecheck errors.
- [ ] 100% targeted and regression tests passed.
- [ ] Debug logs (`print`, `console.log`) and test credentials removed.
- [ ] Version bumped (`MAJOR.MINOR.PATCH`) with release changelog summary.

### 4. Rollback & Backward Compatibility
- Always have a tested, fast rollback plan for unexpected production issues.
- Schema or public API changes must remain backward-compatible during transitions.
