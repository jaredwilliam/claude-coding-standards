---
id: testing
concern: Unit tests for coverage; writing tests first when fixing bugs; not letting TDD distort design; testing behavior through interfaces
triggers:
  - test
  - unit test
  - testing
  - TDD
  - test-driven
  - bug fix
  - regression
  - coverage
  - assert
  - test case
  - test suite
  - mock
load_with: []
---

# Testing

> Tests exist to give high coverage and safe change — but testing strategy shouldn't be allowed to distort design. **Load this when writing tests or choosing a testing approach.**

## Principles

- **Favor unit tests for coverage.** Unit tests reach paths and edge conditions that system/integration tests can't reliably hit, and they pinpoint failures. They're the backbone of confident refactoring.
- **Write tests first when fixing a bug.** Reproduce the bug with a failing test before fixing it. This proves you understand the bug, prevents regressions, and verifies the fix actually addresses it.
- **Don't let test-first drive design (general feature work).** Pure TDD optimizes for "make this feature pass," which biases toward whatever structure makes the next test green — not the best overall design. Design the module deliberately (see `modules-and-interfaces.md`), then test it thoroughly.
- **Test behavior through interfaces, not internals.** Tests coupled to implementation details break on every refactor and discourage improving the design. Test the contract.
- **Define success criteria up front.** A feature isn't scoped until you can say what "this works" looks like. If you can't state the observable pass condition, you're not done scoping.

## Anti-patterns (don't)

- Don't rely on end-to-end tests for coverage that unit tests should provide — slow, flaky, and vague on failure cause.
- Don't shape a module's design solely to satisfy the next failing test.
- Don't assert on private state or internal call sequences; assert on observable outcomes.
- Don't fix a bug without first writing a test that fails because of it.
- Don't ship a feature whose "done" can't be stated as a checkable condition.

## Good vs bad

**Bad — bug fix with no reproducing test**
```
# Quietly patch the off-by-one and move on.
def page_range(n): return range(1, n)   # was range(1, n-1)
```

**Good — failing test first, then fix**
```
def test_page_range_includes_last_page():
    assert list(page_range(3)) == [1, 2, 3]   # fails before the fix

def page_range(n): return range(1, n + 1)
```
*Why:* The test proves the bug existed, proves the fix works, and locks out the regression.

**Bad — test coupled to internals**
```
def test_cache():
    c = Cache()
    c.get("k")
    assert c._lookups == 1          # breaks on any refactor
```

**Good — test the contract**
```
def test_cache_returns_loaded_value():
    c = Cache(loader=lambda k: "v")
    assert c.get("k") == "v"        # survives internal changes
```
*Why:* The behavioral test stays green through refactors, so it encourages improving the design rather than fossilizing it.
