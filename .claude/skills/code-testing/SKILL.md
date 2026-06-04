---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: code-testing
description: Use when writing or modifying tests, fixing a bug (regression test required), adding CLI executables (execution tests required), setting up coverage / benchmarks / fuzzing, or deciding what kind of test (unit / integration / acceptance, blackbox / greybox, specific / invariant) to write.
---

# Code testing

Serokell's testing philosophy is built around two qualities of the
system being developed:

- **External Quality** — how well the system meets its functional
  requirements and external constraints (what the customer sees).
- **Internal Quality** — how well the system is designed, how easily
  it can be changed (what the developers feel).

Both matter. Tests serve both. Different kinds of tests serve them in
different ratios.

## Mandatory rules

### Defect-driven testing

When you fix a bug, you **must** add a test that fails before the fix
and passes after. Commit them together (or the test in the same PR).
This:

1. Documents the bug — the test explains the failure mode.
2. Increases coverage on a previously uncovered code path.

The PR template's "Tests" checkbox under "Related changes" enforces
this for bugs.

### Edge-case safety

While writing code, identify edge cases (empty inputs, boundary
values, error paths, etc.) and add a test for each one — even if it
passes trivially. The point is not the assertion but the marker: the
test will be there when someone later modifies the code, and it will
make them pay attention to the case.

### Execution tests for CLI tools

If the product ships any CLI tool (a binary the user invokes, not a
long-running daemon), the test suite **shall** execute that tool
through a standard shell-like invocation and validate every subcommand
and option as thoroughly as possible. This is the single most
important kind of test for shipping a high-quality CLI product.

### Test coverage in CI

- CI should produce a test coverage report.
- CI should fail merges that reduce coverage.
- CI jobs should exercise **every** executable file in the
  repository — including small scripts — to catch breakage in
  rarely-touched code.

## Test classification (vocabulary)

These terms are used consistently across Serokell — use them when
discussing or naming tests.

### Level

- **Acceptance tests** (highest level) — verify the system as a whole.
  Cover all components and their interactions.
- **Integration tests** — verify that specific modules interact
  correctly.
- **Unit tests** (lowest level) — verify the smallest independently
  testable component in isolation.

Higher levels → more feedback on External Quality, less on Internal.
Lower levels → opposite.

### Interface use

- **Edge-to-edge** (aka **end-to-end**) — the test feeds inputs through
  the public interface (UI, API) and reads outputs through the public
  interface, just like a real user.
- **Blackbox** — an edge-to-edge test that does not peek at internal
  state at all. Strictly measures External Quality.
- **Greybox** — between blackbox and unit; uses private interfaces to
  customise initialisation or observe internal state, but tests
  higher-level behaviour. Balances External / Internal feedback.

### Data generation

- **Specific** test — given a known input, expects a known output.
- **Invariant** test (aka **Property** / **Generative** test) — random
  data generated, output checked against a predicate.

### Purpose

- **Customer test** — derived from customer-facing specs; mostly
  measures External Quality.
- **Developer test** — written for developers' own benefit; mostly
  measures Internal Quality.

## Preferred testing strategies

### Pure unit testing

Lowest-level developer tests of pure components. Greatest impact on
Internal Quality.

- Prefer **probabilistic invariant** (property-based) testing as the
  primary tactic.
- Fall back to **specific tests** for edge cases that property-based
  generators don't reliably hit.

The mere existence of a unit test forces the surrounding code to be
decoupled enough to be tested — that's a benefit independent of the
assertions.

### Functional blackbox testing

Highest-level customer blackbox tests for functional requirements.
Most important for External Quality. Non-intrusive: they don't need
support from the system under test, and the framework is independent
of the technology stack.

### Durability / load / stress / fuzzing

Highest-level blackbox tests for non-functional constraints
(reliability, resilience, security). Deploy the system in a typical
configuration, then:

- **Durability** — leave it under normal load for a month.
- **Load** — leave it under very high load for a couple of hours.
- **Stress** — slowly increase load over ~10 minutes until it fails.
- **Fuzzing** — throw random or semi-random data at the public
  interface.

These are valuable when the project has infrastructure for them, but
require no input from the customer or developer beyond instrumentation.

## Product-level expectations

If you're authoring or maintaining a Serokell product (library or
application):

- **Fuzzing generators**: the product should ship an executable or API
  that produces random *valid* inputs, with a knob for "meaningfulness"
  of generated data. Useful both for fuzzing the product itself and
  for fuzzing things that consume the product.
- **Benchmarks**: every product, **including libraries**, should ship
  executables for benchmarking. CI should run them, report results, and
  collect profiling data (language-specific tools plus `perf` where
  applicable). This catches performance regressions, e.g. after
  updating dependencies.

## Where this skill does NOT prescribe

- **Impure unit testing** (mocking IO-bound components) — Serokell
  knows it matters but doesn't have a settled methodology. Use your
  judgement.
- **Functional greybox testing** — same status: valuable in principle,
  no settled approach. Don't avoid it, but don't expect a template.
- **TDD** — supported in principle but not mandated.

## Local Haskell specifics

The `haskell-style` skill notes that `tasty` is the assumed primary
test runner in this repo and that tests should be built with
`-threaded -with-rtsopts=-N`. The `setup-ci` skill covers Haskell-CI
test jobs (multiple GHC versions, multiple stack snapshots, hlint).
