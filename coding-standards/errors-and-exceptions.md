---
id: errors-and-exceptions
concern: Defining errors out of existence; exception masking; exception aggregation; minimizing exception-handling surface area
triggers:
  - exception
  - error handling
  - try/catch
  - raise
  - throw
  - failure
  - error propagation
  - error recovery
  - exception type
  - error design
load_with:
  - special-cases-and-control-flow
---

# Errors & Exceptions

> Exception handling is one of the worst sources of complexity. Reduce the number of places that must handle errors. **Load this when designing error behavior, exception types, or `try`/`catch` structure.**

## Principles

- **Define errors out of existence.** The best exception is one that can't occur. Redesign interfaces so the "error" becomes a normal, valid outcome. This removes handling code entirely rather than relocating it.
- **An exception is any uncommon condition that alters normal control flow.** Each one a caller must handle is added complexity. Minimize how many a caller must reason about.
- **Use exception masking.** Handle a low-level error deep in the system so higher layers never see it. The complexity is absorbed at one well-chosen point instead of propagated upward.
- **Use exception aggregation.** Funnel many possible exceptions to a single handler (e.g., one top-level handler per request) rather than catching each at its origin. One piece of handling code covers many error sites.
- **Don't over-signal.** Throwing for routine, expected conditions forces every caller into defensive handling. Reserve exceptions for genuinely exceptional states.

## Anti-patterns (don't)

- Don't throw when a benign default or empty result expresses the outcome just as well (e.g., "key not found" → return a default, not an exception, when callers can sensibly handle absence).
- Don't catch-log-rethrow at every layer; that multiplies handling sites without adding information.
- Don't let low-level implementation exceptions leak through a clean interface — mask or translate them.
- Don't wrap each operation in its own `try`/`catch` when a single enclosing handler would cover the batch.

## Good vs bad

**Bad — error that shouldn't exist**
```
try:
    item = cache.get(key)        # throws KeyError on miss
except KeyError:
    item = load(key)
```

**Good — define it out of existence**
```
item = cache.get(key, default=None)   # miss is a normal outcome
if item is None:
    item = load(key)
```
*Why:* A cache miss is not exceptional; modeling it as a normal return removes the handling path. (Even better: `cache.get_or_load(key, load)` to hide it entirely.)

**Bad — per-site handling, repeated**
```
for task in tasks:
    try:
        run(task)
    except TaskError as e:
        report(e)     # same handling duplicated at every call site over time
```

**Good — aggregate to one handler**
```
def run_all(tasks):
    for task in tasks:
        run(task)         # raises on failure

try:
    run_all(tasks)
except TaskError as e:
    report(e)             # one handler for the whole batch
```
*Why:* The handling logic exists once. Adding a new call path doesn't add a new handler.

**Bad — leaking low-level errors**
```
def get_config():
    return json.parse(open(path).read())   # caller must handle IOError + ParseError
```

**Good — mask at the boundary**
```
def get_config():
    try:
        return json.parse(open(path).read())
    except (IOError, ParseError):
        return DEFAULT_CONFIG   # callers see a config, never an error
```
*Why:* The complexity is absorbed at one sensible point; every caller is freed from handling it.
