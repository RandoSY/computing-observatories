# Computing Observatories

Computing Observatories are educational systems that make otherwise hidden computation visible: machine state, stacks, registers, instruction flow, timing, memory, and the relationship between source code and execution.

The goal is not retrocomputing for nostalgia alone. Older and simpler machines are useful because a learner can still see enough of the whole system to form a working mental model.

## Canonical families

### CRCL

A browser-hosted Forth-like environment and teaching system that connects visible stack behavior and simple language ideas to small physical-computing targets.

### Forth Observatories

AVR, MSP430, CH32V003, RP2040-related and other small-machine Forth work used to expose execution state, memory, and interactive programming.

### Processor simulators

65C02, RCA COSMAC 1802, and related simulators/teaching systems belong here when their central purpose is to make architecture and execution observable.

### Visible state tools

Animated stack traces, glossaries, Reality View concepts, instruction stepping, and source/machine correspondence all serve the same educational purpose: turn computation into something that can be inspected rather than merely trusted.

## Design rules

- Prefer systems small enough to understand end to end.
- Keep state visible.
- Make stepping and cause/effect easy to observe.
- Use simulation when it improves access without erasing the underlying machine model.
- Keep platform-specific ports beneath the durable educational idea.
- Preserve historical variants as lineage, not as competing current products.

## Planned repository structure

- `crcl/`
- `forth-observatories/`
- `processors/65c02/`
- `processors/1802/`
- `visible-state/`
- `examples/`
- `docs/`
- `validation/`

## Current state

**Lifecycle:** `active / preservation`

**Priority:** P2/P3 packaging. The goal is to preserve and package the strongest working examples without reopening broad feature development.

Existing source and historical repositories still need to be classified as canonical source, upstream dependency, preserved snapshot, or superseded lineage.
