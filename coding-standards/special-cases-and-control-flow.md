---
id: special-cases-and-control-flow
concern: Eliminating special cases; designing common-case code to handle edges naturally; separating and pushing specialized logic up the stack
triggers:
  - special case
  - edge case
  - conditional
  - branch
  - guard clause
  - null check
  - None check
  - flag
  - mode
  - if/else chain
  - default value
  - general purpose
  - specialized
load_with:
  - modules-and-interfaces
  - information-hiding
---

# Special Cases & Control Flow

> Specialized code is a top source of complexity. Eliminate special cases so the common-case code also handles the edges. **Load this when code is sprouting `if`-branches for edge conditions, or when separating general from specific logic.**

## Principles

- **Eliminate special cases.** The most effective way to simplify detailed code is to design so that edge cases don't need separate handling — the general path covers them naturally. Fewer branches, fewer bugs.
- **Make the common case handle the edges.** Choose representations and defaults (empty collection instead of null, a no-op default instead of a "none" branch) so the normal code path is also correct for the boundary.
- **Special cases of any kind make code harder to understand and more bug-prone.** Each branch is another state a reader must track and a path a test must cover.
- **Cleanly separate specialized code from general-purpose code.** Don't interleave one-off logic into a reusable component. Keep the reusable core free of special-purpose contamination.
- **Push specialized code upward.** Top-level classes provide specific features and are *necessarily* specialized — that's fine. But that specialization should not percolate down into the lower-level, reusable building blocks. Keep specifics high, generality low.

## Anti-patterns (don't)

- Don't scatter `if first / if last / if empty` checks through an algorithm — restructure so the loop body is uniform.
- Don't represent "nothing" as `null` and then null-check everywhere; use an empty/neutral value so the normal path just works.
- Don't bake a caller-specific rule into a shared utility; lift it to the caller.
- Don't let low-level helpers grow flags that only exist to serve one high-level feature.

## Good vs bad

**Bad — special-cased boundaries**
```
def join(parts, sep):
    if not parts:
        return ""
    result = parts[0]
    for p in parts[1:]:      # special-cases the first element
        result += sep + p
    return result
```

**Good — uniform path**
```
def join(parts, sep):
    return sep.join(parts)   # empty and single-element cases fall out for free
```
*Why:* The empty and first-element edges vanish into the general operation. No branch, nothing extra to test.

**Bad — null forces branches everywhere**
```
groups = find_groups()        # returns null when none
if groups is not None:
    for g in groups: process(g)
```

**Good — neutral value, no branch**
```
groups = find_groups()        # returns [] when none
for g in groups: process(g)
```
*Why:* "No groups" is handled by the loop naturally. The special case was designed out of existence.

**Bad — specialization leaked downward**
```
def render_cell(value, *, invoice_currency=False, dashboard_red=False):
    ...   # a generic renderer knows about invoices and dashboards
```

**Good — specialization pushed up**
```
def render_cell(value, formatter): ...
# invoice/dashboard knowledge lives in the caller's formatter
```
*Why:* The reusable renderer stays general. Feature-specific behavior lives in the high-level code that owns the feature.
