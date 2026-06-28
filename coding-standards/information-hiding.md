---
id: information-hiding
concern: Encapsulating design decisions; avoiding information leakage; not exposing internal state; getters/setters as a last resort
triggers:
  - encapsulation
  - coupling
  - information hiding
  - leakage
  - internal state
  - expose
  - getter
  - setter
  - property
  - private
  - public field
  - visibility
load_with:
  - modules-and-interfaces
  - special-cases-and-control-flow
---

# Information Hiding & Encapsulation

> Each module should hide a few design decisions, exposing only what callers genuinely need. **Load this when deciding what a module reveals vs. conceals, or when reviewing coupling.**

## Principles

- **Encapsulate design decisions, not just data.** Each module should own a small number of pieces of knowledge — a storage format, a protocol detail, an algorithm choice — that nothing outside needs to know.
- **Minimize the information needed outside a module.** The less a caller must know to use a module correctly, the looser the coupling and the freer you are to change the internals.
- **Information hiding only applies to information not needed outside.** Don't hide something callers legitimately require — that just forces leakage through a side channel. Hide what is genuinely internal.
- **Avoid information leakage.** Leakage happens when a design decision is reflected in multiple modules, so a change forces edits in several places. If two modules must change together for one decision, that decision is leaking.
- **Design around knowledge, not task order.** Decompose by *what knowledge is needed to do each job*, not by the temporal sequence of steps. Sequence-based decomposition spreads one decision across many "phase" modules and leaks badly.
- **Don't expose internal state.** Public/exposed fields make part of the implementation visible externally, breaking information hiding. Prefer not exposing state at all.
- **Getters/setters are a fallback, not a default.** If state genuinely must be exposed, accessors are acceptable — but the better move is to not expose it and instead offer behavior that uses it internally.

## Anti-patterns (don't)

- Don't decompose a pipeline into `parse → transform → serialize` modules that all must know the same format — that format decision now leaks across three modules.
- Don't add a getter for every field reflexively; that's exposing state with extra ceremony.
- Don't let a "config" object carry internal knobs that only one module understands but everyone passes around.
- Don't surface an internal enum/flag/format in a public signature when a higher-level intent would do.

## Good vs bad

**Bad — leakage via task-order decomposition**
```
raw   = Reader.read(path)          # knows the on-disk format
rows  = Transformer.transform(raw) # ALSO must know the format
out   = Writer.write(rows)         # ALSO must know the format
# Change the format → edit all three.
```

**Good — hide the format behind one module**
```
table = Table.load(path)   # format knowledge lives here, nowhere else
table.add_column(...)      # callers work in terms of rows/columns
table.save(path)
```
*Why:* The format decision is encapsulated. Callers manipulate the abstraction; a format change touches one module.

**Bad — exposed state**
```
account.balance = account.balance - amount   # caller mutates internals
if account.balance < 0: ...                  # caller enforces the rule
```

**Good — behavior hides the decision**
```
account.withdraw(amount)   # invariant (no overdraft) enforced inside
```
*Why:* The overdraft rule and the representation of balance are hidden. Callers can't violate the invariant and don't depend on how balance is stored.
