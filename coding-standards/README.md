# Coding Standards — Index / Map of Content

User-level coding standards for AI agents. Modular by design: each document covers **one concern** so an agent loads only what a task needs, not the whole corpus. Start here, then pull the specific doc(s) relevant to the work.

## How to use this

1. Identify the concern in front of you (designing a module? naming things? handling errors?).
2. Load the matching doc(s) below — they're independent and can be combined.
3. For any non-trivial design decision, also load `complexity-and-strategic-design.md`; it holds the priorities the others serve.

Each doc follows the same shape: **Principles** (rule + brief rationale) → **Anti-patterns (don't)** → **Good vs bad** examples. Examples are language-agnostic pseudocode.

## The documents

| Document                             | Concern                                                                                                                                                | Load when…                                                                   |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------- |
| `complexity-and-strategic-design.md` | The root philosophy: minimize complexity/cognitive load, strategic vs. tactical, every design element must pay for itself, DRY/SOLID framing, patterns | Any non-trivial design decision; the default lens                            |
| `modules-and-interfaces.md`          | Deep modules, simple interfaces, general-purpose interfaces, common-case-simple, combine vs. separate                                                  | Defining a module, class, function signature, or public API                  |
| `information-hiding.md`              | Encapsulating design decisions, avoiding leakage, not exposing state                                                                                   | Deciding what a module reveals vs. conceals; reviewing coupling              |
| `special-cases-and-control-flow.md`  | Eliminating special cases, common case handles edges, general vs. specialized, pushing specialization up                                               | Code is sprouting edge-case branches; separating general from specific logic |
| `errors-and-exceptions.md`           | Define errors out of existence, masking, aggregation                                                                                                   | Designing error behavior, exception types, or `try`/`catch` structure        |
| `naming.md`                          | Precision, consistency, image-in-the-reader's-mind, avoid extra words                                                                                  | Naming variables, functions, types, modules, files                           |
| `comments-and-documentation.md`      | Self-documenting code, what to comment, comments-first, documenting abstractions                                                                       | Writing comments, docstrings, or interface docs                              |
| `evolving-code.md`                   | Changing code as if designed that way from the start, consistency, leave-it-better                                                                     | Modifying, extending, or refactoring existing code                           |
| `testing.md`                         | Unit-test coverage, TDD caveats, tests-first-for-bugfixes, success criteria                                                                            | Writing tests or choosing a testing approach                                 |
| `performance.md`                     | Measure-first, baselines, critical path, when added complexity is justified                                                                            | A performance concern arises or before optimizing                            |

## How the concerns relate

- **`complexity-and-strategic-design`** is the spine. Everything else is a tactic in service of minimizing complexity.
- **Design-time cluster:** `modules-and-interfaces`, `information-hiding`, and `special-cases-and-control-flow` are usually loaded together when shaping new code — they're three angles on "make deep, decoupled, branch-free modules."
- **Communication cluster:** `naming` and `comments-and-documentation` cover expressing intent. Code clarity (naming) handles the obvious; comments handle what code can't say.
- **`errors-and-exceptions`** is a specific application of "eliminate special cases" (errors are special cases of control flow) — pair the two when error handling is proliferating.
- **`evolving-code`** governs *changes*; it applies the design-time principles retroactively so the system doesn't rot.
- **`testing`** and **`performance`** are process concerns that guard against two failure modes — unsafe change and unjustified slowness — and both insist on measurement/criteria over intuition.

## Conventions for these docs

- One concern per file; keep them independently loadable.
- Keep examples language-agnostic and minimal — illustrate the principle, nothing more.
- When adding a rule, also add its **don't** and a **good vs bad** pair; a rule without a counter-example is half-documented.
- If two docs start needing the same rule, that rule may belong in `complexity-and-strategic-design` (shared spine) — or the concern boundary is wrong; re-cut it.
