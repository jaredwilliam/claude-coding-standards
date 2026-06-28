---
id: naming
concern: Naming with precision and consistency; building an accurate mental image; avoiding vague or padded names
triggers:
  - naming
  - name
  - rename
  - identifier
  - variable name
  - function name
  - class name
  - method name
  - module name
  - constant name
load_with:
  - comments-and-documentation
---

# Naming

> A name should create an accurate image in the reader's mind of what the thing is — and what it is not. **Load this when naming variables, functions, types, modules, or files.**

## Principles

- **A name builds a mental image.** Good names convey what the entity is *and*, just as importantly, what it isn't. The reader should be able to predict behavior from the name alone.
- **Precision.** The name should pin down the specific thing, not gesture at a category. Vague names (`data`, `info`, `handle`, `process`) force the reader into the code to recover meaning.
- **Consistency.** Use the same word for the same concept everywhere, and never reuse one word for two concepts. Consistency lets a reader trust an inference instead of re-checking. Inconsistency causes mistakes.
- **Avoid extra words.** Drop words that add no information (`theManager`, `dataObject`, `doProcessing`). Every word should earn its place.
- **Match the abstraction level.** Name by intent/role, not by incidental implementation detail, so the name survives refactors.

## Anti-patterns (don't)

- Don't use generic placeholders (`tmp`, `data`, `obj`, `val`) for things with a real role.
- Don't use one term for several concepts (e.g., `block` meaning both a disk block and a code block) or several terms for one concept (`size`/`length`/`count` interchangeably).
- Don't encode type or implementation in the name when it adds nothing (`user_list` that's actually a set; `str_name`).
- Don't pad names with filler (`Helper`, `Manager`, `Util`, `Data`) unless it genuinely distinguishes.

## Good vs bad

**Bad — imprecise, image-free**
```
def handle(data):
    x = data.get_stuff()
    return process(x)
```
*Reader learns nothing; must read every body to know what flows where.*

**Good — names carry the meaning**
```
def settle_invoice(invoice):
    line_items = invoice.line_items()
    return apply_payment(line_items)
```
*Why:* Each name predicts content and behavior. The code reads as a description of intent.

**Bad — inconsistent terms for one concept**
```
fetch_user(id); get_account(id); load_member(id)   # all the same lookup
```

**Good — one word, one concept**
```
get_user(id); get_account(id); get_member(id)
```
*Why:* A reader who learns `get_` once can trust it everywhere; the cognitive load drops to zero on each new occurrence.

**Bad — extra words**
```
the_user_object_manager_instance
```

**Good**
```
users
```
*Why:* The removed words (`object`, `manager`, `instance`, `the`) carried no information the type and context didn't already supply.
