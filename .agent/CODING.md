# CODING.md — Code Standards & Modular Structure

> **Core Contract:** Each module has 1 MD file, clean code, no silent failures, manage technical debt.

---

### 1. The "Each Module 1 MD" Rule (`MODULE.md`)
Before modifying any module, agents **must read the `MODULE.md`** file in that module's directory. Standard template:
```markdown
# Module: [Name]
- **Responsibility:** [Core business problem this module solves]
- **Public API:** [Exported classes/functions permitted for external use]
- **Internals:** [Private components forbidden from outside access]
- **Boundaries:** [Allowed dependencies; no circular imports]
```

### 2. Clean Code Principles
- **Single Responsibility:** Each function/class does exactly one thing. Split if too long.
- **Intent-Revealing Names:** Names must reflect domain concepts; avoid cryptic abbreviations.
- **No Magic Values:** Use named constants instead of hardcoded numbers/strings.
- **Prefer Immutability:** Avoid in-place mutations; return fresh data copies.

### 3. Error Handling Protocol
- **Classify Errors:** Operational errors (user-friendly message) vs. System errors (catch & log).
- ❌ **No Silent Failures:** Never write empty `catch` blocks. Always handle, map, or bubble up errors.
- **Contextual Logging:** Always log errors with action context and relevant entity IDs.

### 4. Technical Debt Management
- **Boy Scout Rule:** Always leave code cleaner than you found it. Clean nearby minor messes.
- **Zero Dead Code:** Delete unused/commented-out code immediately (Git preserves history). Remove unused imports/variables.
- **Standardized TODOs:** Always format as `// TODO(reason): [actionable plan]`. No vague TODOs.
- **No Duct-Tape Solutions:** Fix root causes; never apply temporary hardcoded hacks.
- **DRY (Don't Repeat Yourself):** If logic repeats 3+ times, extract it into a shared function/module.
