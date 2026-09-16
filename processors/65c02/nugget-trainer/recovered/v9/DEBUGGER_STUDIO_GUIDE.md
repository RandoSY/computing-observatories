# Nugget 65C02 Studio v9.4.1 — Debugger Studio Guide

## Purpose

The debugger is the educational center of Nugget Studio. It is designed to answer four increasingly detailed questions without forcing the learner into different tools:

1. **Where is the program?** — source line, PC, disassembly, call stack.
2. **What changed?** — registers, watches, memory, I/O and data watchpoints.
3. **How did it get here?** — execution trace and reversible history.
4. **What did the hardware see?** — bus-cycle Timeline and full Hardware Timeline.

The marquee `RG_SHOW_10BIT.asm` application is the reference program because it exercises subroutines, ADC input, bit manipulation, timing loops, direct MMIO, VIA output, buzzer output, and a persistent LED record.

## Color language

- **Green — Run / perform:** Build + Run, Run.
- **Blue — Step / navigate execution:** Into, Over, Out, Cursor.
- **Gold — Time travel:** Back, Forward, reversible history.
- **Red — Execution breakpoint:** stop when the PC reaches code.
- **Amber — Data watchpoint:** stop when an address is read, written, accessed, or changed.
- **Purple — Inspect:** I/O Board, watches, diagnostic views.
- **Slate — Neutral machine actions:** Load, PC → start, Reset.

## Recommended R&G debugging exercise

### 1. Build without running

Select `RG_SHOW_10BIT.asm` and choose **Build + Load**. This creates machine code, source-to-address correlation, symbols, disassembly, and the default marquee Watch set.

### 2. Inspect the measurement

The Watch pane includes:

- `ADC0` — decimal, hexadecimal, and 10-bit binary.
- `SAMPLE_HI:SAMPLE_LO` — preserved 10-bit sample.
- `TX_HI:TX_LO` — current transmit shift register.
- `LED_RECORD` — byte being accumulated for D7..D0.
- `LEDS` — `$8000` rendered in hex and binary.
- `ORB` — VIA traffic-light output.

A `HI:LO` watch expression combines two named byte locations into a single 16-bit value.

### 3. Use execution breakpoints

Put the cursor on a source line and press **Breakpoint** (F9), or enter labels such as `sample_adc10`, `transmit_10_bits`, `send_zero`, `send_one`, or `finish_signal` in **Execution Breakpoints**.

### 4. Use data watchpoints

Data watchpoints stop on hardware or memory events instead of program addresses. Modes are WRITE, CHANGE, READ, and ACCESS. One-click presets are provided for `$8000` (LED record), `$8002` (buzzer gate), and `$8100` (VIA ORB). When one fires, Studio pauses after the triggering instruction and opens Trace.

### 5. Read the execution trace

Trace retains up to **4096 instruction records** including sequence number, PC, source line, decoded instruction, A/X/Y/SP after execution, important I/O events, call/return events, and data-watchpoint hits. Filters include all instructions, I/O events, calls/returns, and watchpoint hits.

### 6. Follow the symbolic call stack

JSR/RTS execution is tracked as a symbolic call chain. The Stack dock shows the symbolic chain first, then the real page-$0100 65C02 hardware stack.

### 7. Rewind execution

At normal educational speeds, Studio captures every instruction into compact reversible history. Up to **4096 states** are retained. v9.4.1 stores one RAM baseline plus instruction write deltas and compact CPU/peripheral snapshots, retaining the full R&G performance without cloning 64 KB of RAM per instruction.

Use Back/Forward, Alt+Left/Alt+Right, or the full History slider. Restoring history also restores CPU state, peripheral state, switches, and the symbolic call stack. Resuming from a restored point creates a new execution branch.

### 8. Inspect one instruction at the bus level

The compact Timeline dock shows bus cycles of the last instruction. **Open full Hardware Timeline** expands this into address, data, R/W, SYNC, decoded target, and a plain-language hardware effect. Useful examples include `STA $8000`, `STA $8002`, `STA $8007/$8008`, and `STA $8100`.

## Keyboard shortcuts

- **F5** — Run / Pause
- **F9** — Toggle source breakpoint
- **F10** — Step Over
- **F11** — Step Into
- **Shift+F11** — Step Out
- **Alt+Left** — history Back
- **Alt+Right** — history Forward

The existing Space/P/R trainer shortcuts remain available outside text-entry controls.

## Design boundary

The top-level **Replay bus cycles** mode replays modeled external cycles of the last completed instruction. It is intentionally described as replay, not as a claim of pin-accurate half-cycle simulation. The full Hardware Timeline is an explanatory hardware view; ordinary source debugging should remain in the Assembler workspace.
