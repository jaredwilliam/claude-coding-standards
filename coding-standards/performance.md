---
id: performance
concern: Measure before optimizing; establish baselines; target the critical path; only add complexity for genuinely expensive operations
triggers:
  - performance
  - optimize
  - optimization
  - slow
  - bottleneck
  - latency
  - throughput
  - profil
  - benchmark
  - cache
  - I/O
  - memory allocation
  - critical path
load_with: []
---

# Performance

> Performance can't be ignored in the name of design — but optimize with measurement, on the critical path, only where it pays. **Load this when a performance concern arises or before optimizing.**

## Principles

- **Design isn't an excuse to ignore performance.** A clean design that's unusably slow has failed. Sometimes added complexity for speed is the right call — but it must be justified, not assumed.
- **Only the expensive operations are worth complicating for.** Reserve performance-driven complexity for genuinely costly operations: network communication, secondary-storage I/O, dynamic memory allocation, and cache misses. Micro-optimizing cheap in-memory work adds complexity for nothing.
- **Measure before you change.** Before modifying a module for performance, measure and record current behavior. This (1) identifies the small number of places actually consuming time, so you optimize where it matters, and (2) establishes a baseline to compare against afterward.
- **Profile over intuition.** Don't guess at bottlenecks — they're frequently wrong. Let measurement, not hunch, direct the effort.
- **Design around the critical path.** Find the hot path and make it as simple and direct as possible — the fewest operations, the least work. Push complexity off the critical path onto rarely-executed code.
- **Change one variable at a time.** Apply a single optimization, re-measure against the baseline, keep it only if the data shows a real win. Avoid shotgun tuning.

## Anti-patterns (don't)

- Don't optimize without a profile that names the bottleneck.
- Don't add caching/pooling/batching to code that isn't hot — you've added complexity with no payoff.
- Don't bundle several optimizations into one change; you can't tell which helped (or hurt).
- Don't skip recording the baseline; without it, "faster" is an assertion, not a measurement.
- Don't trade correctness or a clean interface for a speedup that the numbers don't justify.

## Good vs bad

**Bad — speculative optimization, no data**
```
# "Loops feel slow," so hand-roll a cache nobody profiled.
_cache = {}
def square(n):
    if n in _cache: return _cache[n]
    _cache[n] = n * n             # caching a trivial op; pure overhead
    return _cache[n]
```

**Good — measure, target the real cost, re-measure**
```
# Profile shows 80% of time in per-row DB round-trips on the hot path.
# Baseline: 1200 ms for 1k rows.
rows = db.fetch_all(ids)          # one round-trip instead of N
# Re-measured: 90 ms. Single change, verified against baseline.
```
*Why:* The optimization targets a genuinely expensive operation (network/IO) identified by profiling, changes one thing, and is validated against a recorded baseline — complexity added only where it demonstrably pays.

**Bad — complexity spread across the whole path**
```
# Inlined bit-twiddling and manual loop unrolling everywhere "to be fast."
```

**Good — keep the critical path simple, push cost aside**
```
# Hot path: a tight, clear loop. Rare path (cold-start rebuild) absorbs the complexity.
```
*Why:* The common, performance-sensitive path stays simple and fast; the expensive-but-rare work is moved off it rather than complicating every execution.
