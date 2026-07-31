# Rule: Avoid N+1 Query Problem

**Category:** Performance  
**Priority:** HIGH  
**Languages:** Python, JavaScript, TypeScript, Ruby, Go, Java

---

## What It Is

An N+1 query problem occurs when code executes one query to fetch a list of N records, then executes an additional query **for each record** to fetch related data — resulting in N+1 total queries instead of 1 or 2.

At small scale it's invisible. At production scale it is a primary cause of slow API responses and database overload.

---

## Detection Patterns

### The Core Pattern: DB Call Inside a Loop

```python
# ❌ N+1 — fetches users, then hits DB once per user
users = User.objects.all()
for user in users:
    orders = Order.objects.filter(user=user)  # 1 query per user
    print(user.name, len(orders))
```

```javascript
// ❌ N+1 — same pattern in JS/TypeScript
const users = await User.findAll();
for (const user of users) {
  const orders = await Order.findAll({ where: { userId: user.id } }); // N queries
}
```

### ORM Lazy Loading (hidden N+1)

```python
# ❌ Django — accessing related field triggers a new query per object
posts = Post.objects.all()
for post in posts:
    print(post.author.name)  # 1 query per post — lazy load
```

```ruby
# ❌ Rails — same issue
Post.all.each do |post|
  puts post.author.name  # N queries
end
```

### Async Loops (JS/TS)

```typescript
// ❌ Awaiting inside a loop — sequential DB calls
const results = [];
for (const id of userIds) {
  results.push(await db.user.findUnique({ where: { id } })); // sequential
}
```

---

## Fixes

### Eager Loading (ORM)

```python
# ✅ Django — select_related (JOIN for FK/OneToOne)
posts = Post.objects.select_related("author").all()
for post in posts:
    print(post.author.name)  # no extra query

# ✅ Django — prefetch_related (separate IN query for M2M / reverse FK)
users = User.objects.prefetch_related("orders").all()
for user in users:
    print(len(user.orders.all()))  # no extra query
```

```ruby
# ✅ Rails — includes
Post.includes(:author).each do |post|
  puts post.author.name
end
```

```javascript
// ✅ Prisma — include
const users = await prisma.user.findMany({
  include: { orders: true },
});

// ✅ Sequelize — include
const users = await User.findAll({ include: [Order] });
```

### Batch / Bulk Queries

```python
# ✅ Load all related records in one IN query
user_ids = [u.id for u in users]
orders_by_user = defaultdict(list)
for order in Order.objects.filter(user_id__in=user_ids):
    orders_by_user[order.user_id].append(order)
```

```typescript
// ✅ Parallel fetching with Promise.all (not sequential)
const results = await Promise.all(
  userIds.map((id) => db.user.findUnique({ where: { id } }))
);

// ✅ Better — single query with IN
const users = await db.user.findMany({ where: { id: { in: userIds } } });
```

### DataLoader Pattern (GraphQL / APIs)

```typescript
// ✅ DataLoader batches and deduplicates DB calls
import DataLoader from "dataloader";

const userLoader = new DataLoader(async (ids: readonly number[]) => {
  const users = await db.user.findMany({ where: { id: { in: [...ids] } } });
  return ids.map((id) => users.find((u) => u.id === id));
});

// In resolver — looks like N+1 but DataLoader batches automatically
const user = await userLoader.load(post.authorId);
```

---

## How to Detect in Production

- Django Debug Toolbar → SQL panel (look for repeated similar queries)
- Rails Bullet gem
- `EXPLAIN ANALYZE` on slow endpoints
- APM tools (Datadog, New Relic) → database query count per request

---

## Impact If Missed

- 100 users → 101 queries instead of 2
- Response times scale linearly with record count
- Database connection pool exhaustion under load
- Timeouts and cascading failures in production
