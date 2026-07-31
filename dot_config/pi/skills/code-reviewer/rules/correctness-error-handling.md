# Rule: Proper Error Handling

**Category:** Correctness  
**Priority:** HIGH  
**Languages:** Python, JavaScript, TypeScript, Go, Java, Rust

---

## What It Is

Improper error handling causes silent failures, misleading error messages, crashes, data corruption, and security leaks. Good error handling ensures errors are caught at the right level, communicated clearly, and recovered from gracefully.

---

## Detection Patterns

### Silent Swallowing

```python
# ❌ Catches everything and does nothing
try:
    result = process(data)
except:
    pass

# ❌ Logs but continues as if nothing happened
try:
    save_to_db(record)
except Exception:
    print("error")  # No reraise, no fallback — caller doesn't know
```

```javascript
// ❌ Swallowed in async context
async function fetchUser(id) {
  try {
    return await api.get(`/users/${id}`);
  } catch (e) {
    // nothing
  }
}
```

### Overly Broad Catches

```python
# ❌ Catches KeyboardInterrupt, SystemExit, etc.
except Exception:
    ...

# ❌ Even broader
except:
    ...
```

### Uncaught Promise Rejections

```javascript
// ❌ Missing await — rejection is unhandled
function loadData() {
  fetchData().then(process);  // rejection from fetchData() ignored
}

// ❌ Fire-and-forget without .catch()
someAsyncOperation();
```

### Missing Null/None Checks

```python
# ❌ Assumes result exists
result = db.query("SELECT * FROM users WHERE id = ?", (user_id,))
return result[0]["name"]  # IndexError if not found

# ❌ Attribute access on potentially None
user = get_user(id)
print(user.email)  # AttributeError if user is None
```

### Go — Ignored Errors

```go
// ❌ Error return value discarded
data, _ := ioutil.ReadFile("config.json")
json.Unmarshal(data, &config)  // error ignored
```

---

## Fixes

### Catch Specific Exceptions

```python
# ✅ Python — specific exception types
try:
    result = db.execute(query, params)
except DatabaseConnectionError as e:
    logger.error("DB connection failed: %s", e)
    raise ServiceUnavailableError("Database temporarily unavailable") from e
except QueryError as e:
    logger.warning("Query failed: %s", e)
    return None
```

### Always Log or Propagate

```python
# ✅ Log with context and re-raise or return sentinel
try:
    response = external_api.call(payload)
except requests.Timeout as e:
    logger.error("API timeout after %ds calling %s", TIMEOUT, endpoint, exc_info=True)
    raise ExternalServiceError("Upstream timeout") from e
```

```javascript
// ✅ Log and rethrow in JS
async function fetchUser(id) {
  try {
    return await api.get(`/users/${id}`);
  } catch (error) {
    logger.error({ id, error }, "Failed to fetch user");
    throw new UserFetchError(`Could not load user ${id}`, { cause: error });
  }
}
```

### Null Safety

```python
# ✅ Check before accessing
result = db.query("SELECT * FROM users WHERE id = ?", (user_id,))
if not result:
    return None
return result[0]["name"]

# ✅ Or use .get() / walrus operator
if user := get_user(id):
    print(user.email)
```

```typescript
// ✅ TypeScript — use optional chaining and nullish coalescing
const name = user?.profile?.displayName ?? "Anonymous";
```

### Go — Handle Every Error

```go
// ✅ Check every error return
data, err := ioutil.ReadFile("config.json")
if err != nil {
    return fmt.Errorf("reading config: %w", err)
}
if err := json.Unmarshal(data, &config); err != nil {
    return fmt.Errorf("parsing config: %w", err)
}
```

### Async JavaScript — Consistent Pattern

```typescript
// ✅ Either async/await with try/catch...
async function load() {
  try {
    const data = await fetchData();
    return process(data);
  } catch (error) {
    logger.error(error);
    throw error;
  }
}

// ✅ ...or .then/.catch chains — not mixed
fetchData()
  .then(process)
  .catch((error) => {
    logger.error(error);
    throw error;
  });
```

---

## Error Hierarchy Design

When defining custom errors, create meaningful hierarchies:

```python
class AppError(Exception):
    """Base for all application errors."""

class NotFoundError(AppError):
    """Resource does not exist."""

class ValidationError(AppError):
    """Input failed validation."""
    def __init__(self, field: str, message: str):
        self.field = field
        super().__init__(f"{field}: {message}")
```

---

## Impact If Missed

- Silent data corruption (writes fail, but caller assumes success)
- Crashes in production with no diagnostic context
- Security: error messages leaking stack traces / internal paths to clients
- Cascading failures when one service's errors aren't contained
