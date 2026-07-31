# Rule: SQL Injection Prevention

**Category:** Security  
**Priority:** CRITICAL  
**Languages:** Python, JavaScript, TypeScript, Java, Go, PHP, Ruby

---

## What It Is

SQL injection occurs when user-supplied data is embedded directly into a SQL query string, allowing attackers to alter query logic, exfiltrate data, bypass authentication, or destroy the database.

---

## Detection Patterns

Flag any of the following:

- String concatenation (`+`, `,`) used to build SQL strings
- f-strings / `.format()` / `%` interpolation inside SQL
- Template literals (`` ` ` ``) inside SQL strings (JS/TS)
- Raw query calls with user input passed as a string argument
- ORM `.raw()` / `.execute()` calls that interpolate variables

```python
# ❌ Vulnerable patterns
query = "SELECT * FROM users WHERE id = " + user_id
query = f"SELECT * FROM users WHERE name = '{name}'"
query = "SELECT * FROM users WHERE email = '%s'" % email
cursor.execute("DELETE FROM sessions WHERE token = " + token)
```

```javascript
// ❌ Vulnerable patterns
db.query(`SELECT * FROM users WHERE id = ${userId}`)
db.query("SELECT * FROM users WHERE email = '" + email + "'")
```

---

## Fixes

### Parameterized Queries (preferred)

```python
# ✅ Python — DB-API 2.0
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))

# ✅ Python — SQLAlchemy core
result = conn.execute(text("SELECT * FROM users WHERE id = :id"), {"id": user_id})
```

```javascript
// ✅ Node.js — pg
const result = await pool.query("SELECT * FROM users WHERE id = $1", [userId]);

// ✅ Node.js — mysql2
const [rows] = await conn.execute("SELECT * FROM users WHERE email = ?", [email]);
```

```go
// ✅ Go — database/sql
row := db.QueryRow("SELECT * FROM users WHERE id = ?", userID)
```

### ORM Methods (safest)

```python
# ✅ Django ORM
User.objects.filter(id=user_id)
User.objects.filter(email=email)

# ✅ SQLAlchemy ORM
session.query(User).filter(User.id == user_id)
```

```javascript
// ✅ Prisma
const user = await prisma.user.findUnique({ where: { id: userId } });

// ✅ Sequelize
await User.findOne({ where: { email } });
```

### When Raw Queries Are Unavoidable

If `.raw()` or `.execute()` must be used, always pass parameters separately — never as part of the string:

```python
# ✅ Django raw with params
User.objects.raw("SELECT * FROM users WHERE id = %s", [user_id])

# ❌ Still vulnerable even with raw()
User.objects.raw(f"SELECT * FROM users WHERE id = {user_id}")
```

---

## Common Bypass Mistakes

| Mistake | Why It Fails |
|---|---|
| `str(user_id)` before interpolation | Doesn't prevent `1 OR 1=1` |
| Manual quoting (`"'" + val + "'"`) | Bypassable with escaped quotes |
| Blacklist filtering | Incomplete; always bypassable |
| Only checking type (`isinstance(x, int)`) | Safe for ints but not strings |

---

## Impact If Missed

- Full database exfiltration (`UNION SELECT` attacks)
- Authentication bypass (`' OR '1'='1`)
- Data destruction (`DROP TABLE`)
- Privilege escalation via stored procedures
