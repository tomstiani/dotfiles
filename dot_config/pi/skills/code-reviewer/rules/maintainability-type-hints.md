# Rule: Add Type Hints

**Category:** Maintainability  
**Priority:** MEDIUM  
**Languages:** Python, TypeScript, Go, Java, Rust

---

## What It Is

Type annotations on function signatures and variables make contracts explicit, enable IDE autocompletion, power static analysis tools (mypy, pyright, tsc), catch entire classes of bugs before runtime, and serve as machine-verified documentation.

---

## Detection Patterns

### Python — Missing Annotations

```python
# ❌ No type hints on parameters or return
def get_user(user_id):
    ...

# ❌ Missing return type
def create_order(user_id: int, items: list):
    ...

# ❌ Overly broad — `list` and `dict` without generics
def process_records(records: list) -> dict:
    ...
```

### TypeScript — `any` Usage

```typescript
// ❌ any defeats the type system
function processData(data: any): any {
  return data.value;
}

// ❌ Implicit any from missing annotations
function fetchUser(id) {
  return api.get(`/users/${id}`);
}

// ❌ Type assertions without validation
const user = response as User; // assumes shape without checking
```

### Go — Interface Overuse

```go
// ❌ Using interface{} / any when a concrete type is known
func process(data interface{}) interface{} {
    return data
}
```

---

## Fixes

### Python — Complete Annotations

```python
from typing import Optional
from collections.abc import Sequence

# ✅ Typed parameters and return
def get_user(user_id: int) -> Optional[User]:
    ...

# ✅ Specific generics (Python 3.9+ built-in generics)
def process_records(records: list[Record]) -> dict[str, int]:
    ...

# ✅ Union types (Python 3.10+ syntax)
def find(query: str | int) -> User | None:
    ...

# ✅ Callables, iterables
from collections.abc import Callable, Iterator

def apply(fn: Callable[[int], str], values: Iterator[int]) -> list[str]:
    return [fn(v) for v in values]
```

### TypeScript — Strict Types

```typescript
// ✅ Explicit types on all public interfaces
interface User {
  id: number;
  email: string;
  createdAt: Date;
}

async function fetchUser(id: number): Promise<User | null> {
  const response = await api.get<User>(`/users/${id}`);
  return response.data ?? null;
}

// ✅ Use unknown instead of any for unvalidated input, then narrow
function processWebhook(payload: unknown): OrderEvent {
  if (!isOrderEvent(payload)) {
    throw new ValidationError("Invalid webhook payload");
  }
  return payload; // TypeScript narrows here
}

// ✅ Type guard instead of blind cast
function isOrderEvent(value: unknown): value is OrderEvent {
  return (
    typeof value === "object" &&
    value !== null &&
    "orderId" in value &&
    "status" in value
  );
}
```

### Go — Generics (1.18+) over interface{}

```go
// ✅ Concrete types where possible
func processUser(u User) (*Order, error) { ... }

// ✅ Generics for truly generic utilities
func Map[T, U any](slice []T, fn func(T) U) []U {
    result := make([]U, len(slice))
    for i, v := range slice {
        result[i] = fn(v)
    }
    return result
}
```

---

## Tooling to Recommend

| Language | Tool | Config |
|---|---|---|
| Python | `mypy` | `mypy --strict` |
| Python | `pyright` / Pylance | `pyrightconfig.json` |
| TypeScript | `tsc` | `"strict": true` in tsconfig |
| Go | Built-in | `go vet`, `staticcheck` |
| Rust | Built-in | Compiler enforces types |

### Enable Strict Mode

```json
// tsconfig.json — enable all strict checks
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUncheckedIndexedAccess": true
  }
}
```

```ini
# mypy.ini
[mypy]
strict = true
disallow_untyped_defs = true
disallow_any_generics = true
```

---

## When Annotations Are Less Critical

- Private helper functions used in only one place (acceptable to omit)
- Short lambdas where type is locally obvious
- Test code (pragmatic relaxation acceptable)

Even in these cases, return types on public-facing functions should always be annotated.

---

## Impact If Missed

- Runtime `AttributeError` / `TypeError` that mypy/tsc would have caught at build time
- IDE cannot offer meaningful completions or refactoring support
- Onboarding friction — readers must trace calls to understand data shapes
- Regressions when refactoring untyped code
