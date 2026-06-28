# Claude Coding Standards

Modular, AI-loadable coding standards for Claude. Each document covers one concern so Claude loads only what a task needs — not the whole corpus. Most of these standards are from [A Philosophy of Software Design by John. Ousterhout](https://web.stanford.edu/~ouster/cgi-bin/aposd2ndEdExtract.pdf).

## How it works

Standards live in `coding-standards/`. Each file has YAML frontmatter with `triggers` — keywords Claude matches against the current task to decide which docs to load. The `CLAUDE.md` at the repo root (symlinked to `~/.claude/CLAUDE.md`) tells Claude to follow this loading procedure on every coding task.

The result: relevant standards are injected into context automatically, without requiring any manual prompting.

## Installation

```bash
./install.sh
```

This symlinks `coding-standards/` into `~/.claude/coding-standards/` and either symlinks `CLAUDE.md` to `~/.claude/CLAUDE.md` (if none exists) or prints instructions to append it manually (if one already exists).

## The standards

| Document                             | Concern                                                                                         |
| ------------------------------------ | ----------------------------------------------------------------------------------------------- |
| `complexity-and-strategic-design.md` | Root philosophy: minimize complexity, strategic vs. tactical, every element must pay for itself |
| `modules-and-interfaces.md`          | Deep modules, simple interfaces, common-case-simple, when to combine or separate                |
| `information-hiding.md`              | Encapsulating decisions, avoiding leakage, not exposing internal state                          |
| `special-cases-and-control-flow.md`  | Eliminating special cases, common-case code that handles edges naturally                        |
| `errors-and-exceptions.md`           | Define errors out of existence, exception masking and aggregation                               |
| `naming.md`                          | Precision, consistency, accurate mental image, avoid padding                                    |
| `comments-and-documentation.md`      | When and what to comment, comments-first, documenting abstractions                              |
| `evolving-code.md`                   | Changing code as if designed that way from the start, leave-it-better                           |
| `testing.md`                         | Unit-test coverage, tests-first for bug fixes, testing behavior not implementation              |
| `performance.md`                     | Measure before optimizing, baselines, target the critical path                                  |

See `coding-standards/README.md` for the full index, how the concerns relate, and the routing table Claude uses to match tasks to docs.

## Extending

Add a new `.md` file to `coding-standards/` with the same frontmatter shape (`id`, `concern`, `triggers`, optionally `load_with`). Follow the existing doc structure: **Principles** → **Anti-patterns** → **Good vs bad examples**. Update `coding-standards/README.md` to add it to the table.
