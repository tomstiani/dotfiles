# AGENTS.md — Code Reviewer Rule Compilation

Complete reference of all rules with examples, organized by priority. Load specific rule files for deeper coverage.

---

## Table of Contents

1. [CRITICAL: SQL Injection Prevention](#critical-sql-injection-prevention)
2. [CRITICAL: XSS Prevention](#critical-xss-prevention)
3. [HIGH: N+1 Query Problem](#high-n1-query-problem)
4. [HIGH: Proper Error Handling](#high-proper-error-handling)
5. [MEDIUM: Meaningful Variable Names](#medium-meaningful-variable-names)
6. [MEDIUM: Type Hints](#medium-type-hints)

---

## CRITICAL: SQL Injection Prevention

**Full rule:** [rules/security-sql-injection.md](rules/security-sql-injection.md)

Never interpolate user input into SQL strings. Use parameterized queries or an ORM.

```python
# ❌
query = f"SELECT * FROM users WHERE id = '{user_id}'"

# ✅
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
# ✅ ORM
User.objects.filter(id=user_id)
```

```javascript
// ❌
db.query(`SELECT * FROM users WHERE id = ${userId}`)
// ✅
pool.query("SELECT * FROM users WHERE id = $1", [userId])
```

**Key detection:** string concatenation or f-strings inside SQL; `.raw()` calls with interpolated variables.

---

## CRITICAL: XSS Prevention

**Full rule:** [rules/security-xss-prevention.md](rules/security-xss-prevention.md)

Never render unsanitized user content as HTML. Use text APIs or sanitize before using HTML APIs.

```javascript
// ❌
element.innerHTML = userInput
<div dangerouslySetInnerHTML={{ __html: userContent }} />

// ✅
element.textContent = userInput
<div>{userContent}</div>  // JSX auto-escapes

// ✅ If HTML must be rendered
import DOMPurify from "dompurify";
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userContent) }} />
```

**Key detection:** `innerHTML`, `dangerouslySetInnerHTML`, `document.write`, `|safe` in templates, `echo $var` in PHP.

---

## HIGH: N+1 Query Problem

**Full rule:** [rules/performance-n-plus-one.md](rules/performance-n-plus-one.md)

Never put database queries inside loops. Use eager loading or batch queries.

```python
# ❌ N+1 — 1 query for users + 1 per user for orders
users = User.objects.all()
for user in users:
    orders = Order.objects.filter(user=user)

# ✅ 2 queries total
users = User.objects.prefetch_related("orders").all()

# ❌ Hidden N+1 — lazy load triggers per-object query
for post in Post.objects.all():
    print(post.author.name)  # new query each iteration

# ✅
for post in Post.objects.select_related("author").all():
    print(post.author.name)
```

```typescript
// ❌
for (const id of ids) {
  results.push(await db.user.findUnique({ where: { id } }));
}
// ✅
const results = await db.user.findMany({ where: { id: { in: ids } } });
```

**Key detection:** ORM/DB calls inside `for`/`while` loops; lazy-loaded relations accessed in list views.

---

## HIGH: Proper Error Handling

**Full rule:** [rules/correctness-error-handling.md](rules/correctness-error-handling.md)

Catch specific exceptions. Always log or propagate. Never silently swallow errors.

```python
# ❌ Silent swallow
try:
    save(record)
except:
    pass

# ❌ Too broad
except Exception:
    print("error")

# ✅ Specific, with logging and re-raise
try:
    response = external_api.call(payload)
except requests.Timeout as e:
    logger.error("API timeout: %s", e, exc_info=True)
    raise ExternalServiceError("Upstream timeout") from e
```

```javascript
// ❌ Unhandled promise rejection
someAsyncOperation();  // fire-and-forget

// ✅
try {
  const data = await someAsyncOperation();
} catch (error) {
  logger.error(error);
  throw error;
}
```

```go
// ❌ Ignored error
data, _ := ioutil.ReadFile("config.json")

// ✅
data, err := ioutil.ReadFile("config.json")
if err != nil {
    return fmt.Errorf("reading config: %w", err)
}
```

**Key detection:** bare `except:` / `catch {}`, `pass` in except blocks, `_` discarding error returns in Go, `.then()` without `.catch()`.

---

## MEDIUM: Meaningful Variable Names

**Full rule:** [rules/maintainability-naming.md](rules/maintainability-naming.md)

Names should reveal intent. Avoid generic names (`data`, `result`, `temp`), cryptic abbreviations, and misleading names.

```python
# ❌
def calc(d, r, t):
    return d == r * t

data = get_data()
flag = True

# ✅
def is_distance_covered(distance, rate, time):
    return distance == rate * time

user_profile = fetch_user_profile(user_id)
is_authenticated = True
```

**Conventions:**
- Booleans: `is_`, `has_`, `should_`, `can_` prefix
- Functions: start with a verb (`get_`, `create_`, `validate_`, `process_`)
- Collections: plural (`users`, `order_items`)
- Acceptable singles: `i/j/k` for indices, `e` for exceptions, `f` for file handles

---

## MEDIUM: Type Hints

**Full rule:** [rules/maintainability-type-hints.md](rules/maintainability-type-hints.md)

Annotate all public function signatures. Use specific generics, not bare `list`/`dict`/`any`.

```python
# ❌
def get_user(user_id):
    ...

def process(records: list) -> dict:
    ...

# ✅
from typing import Optional

def get_user(user_id: int) -> Optional[User]:
    ...

def process(records: list[Record]) -> dict[str, int]:
    ...
```

```typescript
// ❌
function processData(data: any): any { ... }

// ✅
async function fetchUser(id: number): Promise<User | null> { ... }

// ✅ unknown + type guard instead of any
function handle(payload: unknown): OrderEvent {
  if (!isOrderEvent(payload)) throw new ValidationError("...");
  return payload;
}
```

**Tooling:** `mypy --strict` (Python), `"strict": true` in tsconfig (TypeScript).

---

## Quick Severity Reference

| Severity | Emoji | Examples |
|---|---|---|
| Critical | 🔴 | SQL injection, XSS, hardcoded secrets, auth bypass |
| High | 🟠 | N+1 queries, swallowed errors, missing null checks, race conditions |
| Medium | 🟡 | Poor naming, missing types, missing tests, DRY violations |
| Low | 🟢 | Style nits, minor doc gaps, minor complexity |
