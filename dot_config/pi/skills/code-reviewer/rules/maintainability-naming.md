# Rule: Use Meaningful Variable Names

**Category:** Maintainability  
**Priority:** MEDIUM  
**Languages:** All

---

## What It Is

Variable, function, and class names are the primary documentation of code. Names that reveal intent make code self-documenting, reduce cognitive load, and prevent bugs caused by misunderstanding what a variable holds.

---

## Detection Patterns

### Single-letter and Cryptic Names

```python
# ❌ What is d? What is r? What is t?
def calc(d, r, t):
    return d == r * t

# ❌ Single-letter loop variables (outside trivial loops)
for i in data:
    for j in i.items:
        process(j)
```

### Generic / Meaningless Names

```python
# ❌ "data", "info", "result", "temp", "obj", "item", "value", "thing"
data = get_data()
result = process(data)
temp = result["info"]
return temp

# ❌ Boolean names that don't read as predicates
flag = True
check = validate(x)
status = is_active()
```

### Misleading Names

```python
# ❌ Name says one thing, code does another
def get_user(user_id):
    # also modifies last_seen — not a pure getter
    user = db.find(user_id)
    user.last_seen = now()
    db.save(user)
    return user

# ❌ Plural when it holds a single item
users = db.get_user(id)  # returns one user
```

### Abbreviations That Require Mental Decoding

```python
# ❌
mgr = UserManager()
usr_nm = "alice"
srv = get_service()
dtstr = "2024-01-01"
```

---

## Fixes

### Reveal Intent

```python
# ✅ Names explain what the value represents
def is_distance_covered(distance, rate, time):
    return distance == rate * time

# ✅ Loop variables named for what they iterate
for order in customer.orders:
    for line_item in order.line_items:
        process(line_item)
```

### Specificity Over Brevity

```python
# ✅ Replace generic names with specific ones
user_profile = fetch_user_profile(user_id)
processed_invoice = apply_discounts(raw_invoice)
expiry_date = response["subscription"]["expires_at"]
return expiry_date

# ✅ Booleans as predicates
is_authenticated = True
has_valid_email = validate_email(email)
should_send_notification = user.preferences.notifications_enabled
```

### Honest Function Names

```python
# ✅ Name reflects side effects
def update_last_seen_and_get_user(user_id):
    ...

# Or better — separate concerns
def get_user(user_id):
    return db.find(user_id)

def record_last_seen(user):
    user.last_seen = now()
    db.save(user)
```

### Consistent Conventions by Language

| Language | Convention |
|---|---|
| Python | `snake_case` for variables/functions, `PascalCase` for classes |
| JavaScript/TypeScript | `camelCase` for variables/functions, `PascalCase` for classes |
| Go | `camelCase`, exported identifiers start with uppercase |
| Rust | `snake_case` for variables/functions, `PascalCase` for types |
| Java | `camelCase` for fields/methods, `PascalCase` for classes |

---

## Acceptable Single-Letter Names

These are conventionally understood and acceptable:

- `i`, `j`, `k` — numeric loop indices in tight loops
- `x`, `y`, `z` — coordinates in geometric/math contexts
- `e` — caught exception in `except/catch` blocks
- `f` — file handle in `with open(...) as f:`
- `T`, `K`, `V` — generic type parameters

---

## Naming Checklist

- [ ] Does the name explain **what** it holds, not just **that** it holds something?
- [ ] Can you read the code aloud and have it make sense?
- [ ] Are booleans named as yes/no questions (`is_`, `has_`, `should_`, `can_`)?
- [ ] Are functions named with a verb describing their action?
- [ ] Are collections named in plural form?
- [ ] Is the name consistent with others in the same codebase?
