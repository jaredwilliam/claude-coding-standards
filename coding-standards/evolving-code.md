---
id: evolving-code
concern: Changing code as if it were designed that way from the start; maintaining consistency; strategic improvement vs. tactical patching
triggers:
  - modify
  - change
  - refactor
  - update
  - extend
  - edit
  - maintain
  - legacy code
  - existing code
  - bug fix
  - patch
  - migrate
load_with:
  - complexity-and-strategic-design
---

# Evolving Existing Code

> Every change should leave the system in the state it would have had if designed that way from the start. **Load this when modifying, extending, or refactoring existing code.**

## Principles

- **Design each change in retrospect.** After a change, the system should look as if you'd designed it from the beginning with that change in mind — not as if you bolted the change on.
- **If you're not making the design better, you're probably making it worse.** Entropy is the default. Each edit either improves the design or degrades it; "neutral" edits usually degrade. Leave the code cleaner than you found it.
- **Consistency reduces mistakes.** Follow existing conventions (naming, structure, patterns, error handling) within a codebase. A reader who learns the local convention once can rely on it; deviations cost attention and breed bugs.
- **Don't tactically patch.** Resist the quick local fix that adds a special case or a flag. Make the change that fits the design, even if it's slightly more work now (see `complexity-and-strategic-design.md`).
- **Invest opportunistically.** When touching an area, make the small surrounding improvement that the change reveals — but keep refactors scoped and reviewable; don't smuggle a rewrite into a bug fix.

## Anti-patterns (don't)

- Don't bolt on a flag/branch to avoid touching the existing structure when the structure is what should change.
- Don't introduce a new convention beside an existing one for the same concept; conform or migrate, don't fork.
- Don't leave the design slightly worse "just this once" — that's how systems rot.
- Don't blend a large unrelated refactor into a feature/fix commit; it hides risk and defeats review.

## Good vs bad

**Bad — tactical patch that degrades the design**
```
def price(order):
    total = base_price(order)
    if order.customer == "ACME":      # special case bolted on
        total *= 0.9
    return total
# Next special customer → another branch. Decay begins.
```

**Good — change as if designed in from the start**
```
def price(order):
    return base_price(order) * discount_for(order.customer)

def discount_for(customer):
    return DISCOUNTS.get(customer, 1.0)   # extensible, no special cases
```
*Why:* The new requirement (per-customer discounts) is absorbed into a clean structure. The next customer is data, not code — the system looks designed for this.

**Bad — inconsistent with local convention**
```
# Codebase uses get_*; this edit adds:
def retrieve_order(id): ...
```

**Good — conform to the established convention**
```
def get_order(id): ...
```
*Why:* Matching the existing pattern lets readers apply what they already know and avoids the friction (and bugs) of two conventions for one idea.
