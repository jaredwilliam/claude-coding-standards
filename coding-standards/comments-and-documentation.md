---
id: comments-and-documentation
concern: When and what to comment; writing comments before code; documenting abstractions; interface vs. implementation comments
triggers:
  - comment
  - documentation
  - docstring
  - inline doc
  - annotate
  - explain
  - self-documenting
  - comments-first
  - interface documentation
  - abstraction documentation
load_with:
  - naming
---

# Comments & Documentation

> Comments capture what was in the designer's mind but couldn't be expressed in code. Code carries the *what*; comments carry the *why* and the *abstraction*. **Load this when writing comments, docstrings, or interface documentation.**

## Principles

- **Code should be self-documenting; comments fill what code can't say.** Clear structure and names handle the obvious. Comments exist for the information that doesn't fit in code — rationale, abstractions, constraints, units, invariants.
- **Comment things that are *not* obvious from the code.** A comment restating the code adds noise and rots. If the code already says it, delete the comment (or improve the code).
- **Use different words than the entity's name.** A comment that just re-spells the name adds nothing. Add information the name can't carry.
- **Lower-level comments add precision; higher-level comments add intuition.** Near the code: exact units, ranges, edge conditions, ownership. Above a block/module: the overall purpose and the "why."
- **Comments define abstractions.** An interface comment should let a reader use the method without reading its body. Documenting the abstraction is what makes the abstraction real.
- **If an interface comment must describe the implementation, the module is shallow.** A good interface is summarizable without leaking internals. Needing to explain *how* at the interface is a design smell, not a documentation problem.
- **Implementation comments explain *what*, not *how*.** Inside a method, clarify what a tricky block accomplishes and why; the mechanics are visible in the code itself.
- **Write comments first; delayed comments are bad comments.** Write the interface comment before the body. Benefits: (1) better comments, written while the design is fresh; (2) it surfaces design issues early; (3) it forces you to think in terms of the abstraction and interface before the implementation distracts you.

## Anti-patterns (don't)

- Don't write comments that echo the code (`i += 1  # increment i`).
- Don't defer commenting to "later" — the rationale is gone by then, and the comment never gets written.
- Don't document *how* a public method works in its interface comment; document what it does and what the caller needs.
- Don't let comments and code drift; when you change code, change the comment in the same edit.

## Good vs bad

**Bad — restates the code, no new information**
```
# loop over users and deactivate them
for u in users:
    u.deactivate()
```

**Good — explains the non-obvious why**
```
# Deactivate before billing close so the nightly job skips them;
# order matters — billing reads the active flag.
for u in users:
    u.deactivate()
```
*Why:* The loop is self-evident; the *reason* and the *ordering constraint* are not, and they're what a future editor needs.

**Bad — interface comment leaks implementation (shallow module)**
```
# Iterates a hash table, rehashing on collision, then linear-probes...
def lookup(key): ...
```

**Good — interface comment defines the abstraction**
```
# Return the value for `key`, or None if absent. O(1) expected.
def lookup(key): ...
```
*Why:* The caller can use it from the comment alone. That the comment *can* be written without mentioning internals is evidence the module is deep.

**Bad — precision missing where it matters**
```
def wait(t): ...   # t is... seconds? ms? a deadline?
```

**Good — lower-level precision**
```
def wait(timeout_ms): ...   # milliseconds; <=0 returns immediately
```
*Why:* Units and the boundary behavior are exactly the non-obvious facts a caller will get wrong without a precise, low-level note.
