# Rule: XSS Prevention

**Category:** Security  
**Priority:** CRITICAL  
**Languages:** JavaScript, TypeScript, Python, Ruby, PHP, Go

---

## What It Is

Cross-Site Scripting (XSS) occurs when untrusted data is rendered as HTML in a browser without proper encoding, allowing attackers to inject malicious scripts that steal cookies, hijack sessions, or deface pages.

Three types:
- **Reflected** — input echoed immediately in the response
- **Stored** — input saved to DB and rendered later
- **DOM-based** — client-side JS writes input to the DOM

---

## Detection Patterns

### JavaScript / TypeScript

```javascript
// ❌ Direct DOM injection
element.innerHTML = userInput
document.write(userInput)
element.outerHTML = userInput

// ❌ React escape hatch
<div dangerouslySetInnerHTML={{ __html: userContent }} />

// ❌ jQuery
$(element).html(userInput)

// ❌ URL-based sinks
location.href = userInput
location.replace(userInput)
element.setAttribute("href", userInput)  // if userInput can be javascript:
```

### Server-side Templates

```python
# ❌ Jinja2 with autoescape off or using |safe filter carelessly
{{ user_comment | safe }}
Markup(user_input)  # without sanitizing first
```

```erb
<%== user_input %>   # ❌ Ruby ERB unescaped
```

```php
echo $userInput;           // ❌ PHP direct echo
echo "<p>" . $name . "</p>"; // ❌ PHP concatenation
```

---

## Fixes

### React / Modern JS Frameworks (preferred)

Use text content APIs, not HTML APIs:

```javascript
// ✅ Safe — sets text, not HTML
element.textContent = userInput
element.setAttribute("data-value", userInput)

// ✅ React — JSX auto-escapes by default
<div>{userContent}</div>

// ✅ If you must render HTML — sanitize first
import DOMPurify from "dompurify";
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userContent) }} />
```

### Server-side Templates

```python
# ✅ Jinja2 — autoescape enabled (default in Flask for .html files)
# Enable globally:
env = Environment(autoescape=True)

# ✅ Never use |safe on untrusted content
# If rendering rich text, sanitize before storing:
import bleach
clean = bleach.clean(user_html, tags=ALLOWED_TAGS, attributes=ALLOWED_ATTRS)
```

```php
// ✅ PHP — always use htmlspecialchars
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');
```

### URL Attributes

```javascript
// ✅ Validate URL scheme before setting href
function safeHref(url) {
  const parsed = new URL(url);
  if (!["http:", "https:"].includes(parsed.protocol)) {
    throw new Error("Unsafe URL scheme");
  }
  return url;
}
element.setAttribute("href", safeHref(userUrl));
```

### Content Security Policy (defence-in-depth)

Recommend adding a CSP header as a second layer:

```http
Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none';
```

---

## Sanitization Libraries

| Language | Library |
|---|---|
| JavaScript (browser) | `dompurify` |
| JavaScript (server) | `sanitize-html` |
| Python | `bleach`, `nh3` |
| Ruby | `rails-html-sanitizer` (built into Rails) |
| Java | OWASP Java HTML Sanitizer |
| Go | `bluemonday` |

---

## Impact If Missed

- Session hijacking via `document.cookie` theft
- Credential harvesting via injected fake login forms
- Keylogging / full page defacement
- Stored XSS can affect every subsequent visitor
