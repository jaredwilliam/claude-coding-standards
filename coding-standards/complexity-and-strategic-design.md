---
id: complexity-and-strategic-design
concern: Root philosophy — minimize complexity and cognitive load; strategic vs. tactical programming; every design element must pay for itself; DRY/SOLID; design patterns
triggers:
  - design decision
  - architecture
  - system design
  - structure
  - complexity
  - simplicity
  - cognitive load
  - DRY
  - SOLID
  - design pattern
  - abstraction
  - new feature
  - new module
  - refactor
  - over-engineering
load_with: []
---

# Complexity & Strategic Design

> The root philosophy: minimize complexity and cognitive load, and invest in design rather than just shipping features. **Load this for any non-trivial design decision** — it sets the priorities the other docs serve.

## Principles

- **Strategic over tactical.** The goal is a great *design* that also happens to work — not working code that happens to have a design. Tactical programming (just get the feature working) accumulates complexity that compounds. Spend the extra time now to keep the system clean.
- **As simple as it can be, but no simpler.** Simplicity is the target, but not at the cost of correctness or necessary capability. Don't strip away something load-bearing to chase a smaller line count.
- **Minimize cognitive load.** The real cost of code is how much a reader must hold in their head to work on it safely. Optimize for the next person (often a future agent) understanding it, not for writing it fast.
- **Every design element must pay for itself.** Each interface, argument, function, class, or abstraction *adds* complexity by existing. It's only justified if it removes more complexity than it introduces. If an element doesn't earn its keep, build the system without it.
- **DRY — but eliminate duplication of *knowledge*, not coincidental similarity.** Two pieces of code that look alike but represent different decisions should stay separate; they'll diverge. Deduplicate facts and design decisions, not shapes.
- **SOLID as guidance, not ritual.** Single-responsibility, open/closed, etc. are heuristics toward low coupling and high cohesion. Apply the spirit; don't contort code to satisfy the letter.
- **Modularity is the primary weapon against complexity.** Break systems into parts that can be understood and changed in isolation. (See `modules-and-interfaces.md`, `information-hiding.md`.)
- **Use design patterns where they fit naturally — never force them.** Not every problem maps cleanly to a known pattern. A forced pattern is added complexity that doesn't pay for itself.
- **Make it self-documenting.** Code structure and names should carry the intent; comments fill the gap for what code can't express (see `comments-and-documentation.md`).

## Anti-patterns (don't)

- Don't optimize for "done fast" at the expense of design — that's tactical programming and it compounds.
- Don't add a class/layer/abstraction "for flexibility" with no current consumer that needs it. Speculative generality is complexity that hasn't paid for itself.
- Don't reach for a design pattern because it's familiar; reach for it because the problem's shape calls for it.
- Don't treat DRY as "no two lines may look alike." Merging coincidental duplicates creates false coupling.
- Don't equate fewer lines with simpler. Cognitive load, not length, is the metric.

## Good vs bad

**Bad — speculative element that doesn't pay for itself**
```
# One caller, one backend, but built as a plugin registry "in case"
registry = HandlerRegistry()
registry.register("default", DefaultHandler())
result = registry.resolve(config.handler_key).run(payload)
```
*Three new concepts (registry, keys, resolution) to do one thing once.*

**Good — match the element to the actual need**
```
result = DefaultHandler().run(payload)
```
*Why:* The interface is added only when a second handler actually exists. The design stays open to extension (you can introduce the registry later) without paying for it today.

**Bad — false DRY**
```
def validate_user(x):   reuse_validate(x)   # different rules over time
def validate_invoice(x): reuse_validate(x)   # coupled by accident
```

**Good — separate distinct decisions**
```
def validate_user(x):    ...   # user rules
def validate_invoice(x): ...   # invoice rules; shares helpers, not policy
```
*Why:* Users and invoices encode different knowledge. Sharing the *mechanism* (helpers) is fine; sharing the *policy* couples two things that will diverge.
