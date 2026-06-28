---
id: modules-and-interfaces
concern: Deep modules with simple interfaces; general-purpose interfaces; making the common case trivially easy; when to combine or separate functionality
triggers:
  - module
  - interface
  - API
  - class design
  - function signature
  - public method
  - parameter
  - argument
  - deep module
  - shallow module
  - abstraction layer
  - dependency
load_with:
  - information-hiding
  - special-cases-and-control-flow
---

# Modules & Interfaces

> Design deep modules: lots of functionality behind a simple interface. **Load this when defining a module, class, function signature, or public API.**

## Principles

- **Prefer deep modules.** A good module offers powerful functionality through a small, simple interface. Depth = (functionality provided) / (interface complexity). Shallow modules (big interface, little behind it) add complexity without hiding much.
- **A simple interface matters more than a simple implementation.** Interface complexity is paid by *every* caller; implementation complexity is paid once. Take on extra implementation pain to spare your users.
- **Minimize dependencies between modules.** The fewer connections a module has to the rest of the system, the more independently it can be understood and changed.
- **Make the common case trivially simple.** Offering choice is good, but the default path should require minimal knowledge and ceremony. Push configuration to optional parameters with sane defaults.
- **Design interfaces to be *somewhat* general-purpose.** Implementation reflects today's needs; the interface should not be over-fitted to today's single use. A slightly general interface is often simpler *and* more reusable than a special-cased one.
- **Reduce method count only while each method's API stays simple.** Collapsing many methods into few isn't a win if it forces a pile of extra arguments or mode flags. Count *total* interface complexity, not method count.
- **Red flag: lots of boilerplate to use a class.** If callers must write significant glue to get value out of an interface, the interface is providing the wrong functionality. Move that work inside.
- **Combine two pieces of functionality when** they share information, combining simplifies the interface, or it eliminates duplication. **Separate them when** one is general-purpose and the other special-purpose.

## Anti-patterns (don't)

- Don't expose a thin pass-through interface that just forwards to another layer — that's a shallow module; inline it or deepen it.
- Don't widen a method's signature to avoid adding a method, or vice versa; optimize total interface complexity.
- Don't make callers assemble several calls in a fixed order to achieve the basic outcome — provide one call for the common case.
- Don't tailor an interface to a single caller's current shape; you'll re-cut it at the next caller.
- Don't merge a general-purpose utility with special-purpose logic — it contaminates the reusable part.

## Good vs bad

**Bad — shallow + caller does the work**
```
buf = Buffer()
buf.open(path)
buf.set_mode(READ)
data = buf.read_all()
buf.close()
# Every caller repeats this 5-line ritual.
```

**Good — deep, common case is one call**
```
data = read_file(path)          # common case: trivial
data = read_file(path, mode=READ, encoding="utf-8")  # choice available, optional
```
*Why:* The complexity (open/mode/close/error handling) lives once inside the module. Callers express intent in one line; options exist but don't intrude.

**Bad — fewer methods, worse API**
```
# One "do everything" method with mode flags
store.operate(item, mode="insert", upsert=True, dedupe=False, ttl=None, ...)
```

**Good — small methods, each simple**
```
store.insert(item)
store.upsert(item)
```
*Why:* Collapsing to one method traded a small interface for a confusing argument matrix. Two clear methods carry less total complexity than one overloaded one.

**Bad — over-fitted interface**
```
def get_active_premium_users_sorted_by_signup(): ...
```

**Good — somewhat general interface, specific use built on top**
```
def query_users(filter=None, sort=None): ...
# caller composes the specific case it needs today
```
*Why:* The general query serves the next requirement without an interface change; the specialization lives at the call site, not baked into the module.
