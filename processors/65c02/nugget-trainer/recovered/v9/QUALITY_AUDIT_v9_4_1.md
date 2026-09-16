# Nugget 65C02 Studio v9.4.1 — Quality Audit

## Audit scope

This pass reviewed the single-file Studio application as an emulator, assembler, debugger, Forth host, and operator interface. Checks covered JavaScript syntax, DOM wiring, duplicate IDs, source/demo consistency, CPU state transitions, MMIO read/write behavior, 6522 side effects, debugger observation semantics, watchpoints, trace/history branching, symbolic call stack, R&G protocol edge cases, and responsive layout.

## Important findings repaired

### 1. Debugger observation could change the machine

The v9.4 memory/debug paths used `rawRead()`. That is correct for CPU/program execution but incorrect for a debugger because some device reads are destructive. In particular, a VIA Timer-1 low-byte read acknowledges the timer interrupt and UART data reads remove bytes from the receive queue.

v9.4.1 separates the two concepts:

- `rawRead()` — CPU/program-visible read with authentic side effects.
- `peek()` — debugger-visible observation with no device acknowledgement or data consumption.

The Memory window, disassembler, Watch pane, history/watchpoint baselines, raw stack display, keypad EXAM, and Forth `DUMP` now use `peek()`.

### 2. STP could be accidentally resumed

The Run command formerly cleared `cpu.stopped`, allowing execution to continue after the W65C02 `STP` instruction. v9.4.1 preserves STP until an explicit restart operation.

### 3. Rewind could leave a misleading future trace

History state was restored correctly, but the Trace pane retained records from the old future if execution resumed from a rewound state. The trace now has a historical view cursor; it remains non-destructive while browsing backward/forward, then truncates the abandoned future exactly when execution branches.

### 4. Debugger interrupt trace origin

IRQ/NMI pseudo-instructions previously recorded the handler address as the instruction origin. They now preserve both the interrupted PC and the vector destination, and the symbolic call chain includes interrupt frames until RTI.

### 5. W65C02 decimal ADC flags

The CMOS W65C02 defines valid flags after decimal arithmetic. Decimal ADC now derives V from the binary intermediate and N/Z from the corrected BCD result.

## R&G marquee protocol matrix

The assembler marquee was executed for representative 10-bit ADC values:

| ADC | Binary | Final D7..D0 | Result |
|---:|---|---|---|
| 0 | `0000000000` | `$00` | pass |
| 1 | `0000000001` | `$01` | pass |
| 341 | `0101010101` | `$55` | pass |
| 682 | `1010101010` | `$AA` | pass |
| 1023 | `1111111111` | `$FF` | pass |

Every case produced one ready beep, ten correctly pitched/color-coded data announcements, two termination beeps, preserved the sampled 10-bit word, left the correct low byte on D7..D0, and ended dark/quiet.

## Static and UI checks

- JavaScript syntax: pass
- Duplicate DOM IDs: none
- Missing `$()` DOM references: none
- Built-in self-test: 25/25
- All seven built-in assembler programs assemble
- Embedded R&G assembler source exactly matches `RG_SHOW_10BIT.asm`
- Embedded R&G Forth source exactly matches `RG_SHOW_10BIT.fth`
- No page JavaScript errors in headless Chromium
- No page-level horizontal overflow at 1600×900, 1366×768, 1200×800, 1024×768, 900×800, or 700×800

Machine-readable details are in `VALIDATION_v9_4_1.json`.
