# Coding Standards

Coding standards live in `~/.claude/coding-standards/`. Apply them to **all coding tasks** across all projects.

## Loading procedure

1. **Read `~/.claude/coding-standards/README.md`** at the start of any non-trivial coding task to orient on the full system.
2. **Match triggers to load specific docs.** Each standard doc has a `triggers` list in its YAML frontmatter. Scan the task for keywords; load every doc with a matching trigger.
3. **For any non-trivial design decision, always load `complexity-and-strategic-design.md`** — it's the root lens all other docs serve.
4. **Respect `load_with`.** When you load a doc, also load any docs named in its `load_with` field. Those docs form the natural clusters.

## Routing table (quick reference)

| Task                                       | Load these docs                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------- |
| Any design decision / new code             | `complexity-and-strategic-design`                                                  |
| New module, class, or API                  | `modules-and-interfaces` + `information-hiding` + `special-cases-and-control-flow` |
| Error / exception design                   | `errors-and-exceptions` + `special-cases-and-control-flow`                         |
| Naming anything                            | `naming` + `comments-and-documentation`                                            |
| Writing or reviewing comments / docstrings | `comments-and-documentation` + `naming`                                            |
| Modifying or refactoring existing code     | `evolving-code` + `complexity-and-strategic-design`                                |
| Writing, fixing, or reviewing tests        | `testing`                                                                          |
| Performance investigation or optimization  | `performance`                                                                      |

## Enforcement intent

These are design standards, not style lint. Apply them as judgment, not checklist. The single goal behind all of them is to reduce complexity — use the standards to reason toward that goal.

When standards conflict with each other or with a project constraint, flag the tension explicitly rather than silently choosing one.
