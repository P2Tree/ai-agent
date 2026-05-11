# Code Guidelines — Detailed Examples

Real-world code examples demonstrating the four principles. Each example shows what LLMs commonly do wrong and how to fix it.

---

## 1. Think Before Coding

### Example 1: Hidden Assumptions

**User Request:** "Add a feature to export user data"

**Wrong: Silently assumes scope, format, fields, volume**

```python
def export_users(format='json'):
    """Export all users to a file."""
    users = User.query.all()
    if format == 'json':
        with open('users.json', 'w') as f:
            json.dump([u.to_dict() for u in users], f)
    elif format == 'csv':
        with open('users.csv', 'w') as f:
            writer = csv.DictWriter(f, fieldnames=['id', 'email', 'name'])
            writer.writeheader()
            writer.writerows([u.to_dict() for u in users])
    return f"Exported {len(users)} users"
```

**Right: Surface assumptions, ask for clarification**

```
Before implementing, I need to clarify:
1. Scope: Export all users or filtered subset? (privacy implications)
2. Format: Download file in browser? Background job? API endpoint?
3. Fields: Which user fields? (some might be sensitive)
4. Volume: How many users typically? (affects approach)
Simplest approach: Add an API endpoint that returns paginated JSON.
What's your preference?
```

### Example 2: Multiple Interpretations

**User Request:** "Make the search faster"

**Wrong: Picks one interpretation silently and over-engineers**

**Right: Present options with tradeoffs**

```
"Make the search faster" could mean:
1. Faster response time (< 100ms) — add indexes, cache
2. More concurrent searches (throughput) — async, connection pooling
3. Faster perceived speed (UX) — progressive loading
Which aspect matters most?
```

---

## 2. Simplicity First

### Example 1: Over-abstraction

**User Request:** "Add a function to calculate discount"

**Wrong: Strategy pattern with 30+ lines for a single calculation**

**Right:**

```python
def calculate_discount(amount: float, percent: float) -> float:
    return amount * (percent / 100)
```

### Example 2: Speculative Features

**User Request:** "Save user preferences to database"

**Wrong: PreferenceManager with caching, validation, merging, notifications**

**Right:**

```python
def save_preferences(db, user_id: int, preferences: dict):
    db.execute(
        "UPDATE users SET preferences = ? WHERE id = ?",
        (json.dumps(preferences), user_id)
    )
```

Add complexity later only when needed.

---

## 3. Surgical Changes

### Example 1: Drive-by Refactoring

**User Request:** "Fix the bug where empty emails crash the validator"

**Wrong: Improves email validation, adds username validation, changes comments, adds docstring**

**Right: Only change the specific lines that fix empty email handling**

```diff
  def validate_user(user_data):
      # Check email format
-     if not user_data.get('email'):
+     email = user_data.get('email', '')
+     if not email or not email.strip():
          raise ValueError("Email required")
      # Basic email validation
-     if '@' not in user_data['email']:
+     if '@' not in email:
          raise ValueError("Invalid email")
```

### Example 2: Style Drift

**User Request:** "Add logging to the upload function"

**Wrong: Changes quote style, adds type hints, reformats whitespace**

**Right: Match existing style, only add logging lines**

---

## 4. Goal-Driven Execution

### Example 1: Vague vs. Verifiable

**Wrong:** "I'll review and improve the code" (no success criteria)

**Right:** Define verifiable goals:

```
1. Write test: Change password → verify old session invalidated
   Verify: Test fails (reproduces bug)
2. Implement: Invalidate sessions on password change
   Verify: Test passes
3. Check edge cases
   Verify: Additional tests pass
4. Verify no regression: Full test suite green
```

### Example 2: Test-First Verification

**User Request:** "The sorting breaks when there are duplicate scores"

**Wrong:** Immediately changes sort logic without reproducing

**Right:**

1. Write test that reproduces the bug
2. Verify test fails
3. Fix the code
4. Verify test passes consistently

---

## Key Insight

The "overcomplicated" examples aren't obviously wrong — they follow design patterns. The problem is **timing**: adding complexity before it's needed.

**Good code solves today's problem simply, not tomorrow's problem prematurely.**
