# Nugget 65C02 Forth Lab v8 — START HERE

Open `65c02_nugget_forth_lab_v8.html` in a modern browser.

This version is a deliberate bridge between the existing v7 CPU trainer and the much richer 1802/microForth style environment.

## Five-minute tour

1. **Computer → CPU Console**
   - Keep the hex keypad. It is now the lowest-level entry point, not the whole experience.
   - STEP, RUN, registers, address/data/control buses and reversible history remain.

2. **Computer → VIA I/O Board**
   - The original 6522 experiment board still works.
   - Below it is the new direct Nugget lab:
     - `$8000` 8 LEDs
     - `$8001` SPST switches
     - `$8002` buzzer
     - `$8003` 8-bit POT value
     - `$8004/$8005` raw 12-bit ADC
     - `$8006` status
     - `$8100-$810F` 6522 VIA alias

3. **Forth**
   - Start with `1 2 + .`
   - Try `HEX AA LED!`
   - Close Q or W and enter `SW@ .`
   - Move the POT and enter `POT@ .` or `ADC@ .`
   - Define a word: `: SHOW-SW SW@ LED! ;`
   - The stack, dictionary and execution trace are visible.

4. **Assembler**
   - The default demo is now `Nugget Lab: POT / switches / buzzer`.
   - Assemble & Run it. With both switches open, the POT drives the 8 LEDs.
   - Close Q: switch bits replace the POT display and the buzzer turns on.

5. **CPU FIG Console**
   - In the Forth tab, the lower-right console is reserved for a real CPU-resident FIG image.
   - It displays the 65C02 UART/WDM stream, not the host bridge.
   - After loading a historical image, use **PC → $0200 FIG**, then Send & Run.

6. **Memory / I/O**
   - Inspect memory and the direct lab registers.
   - Use `Flat 64K compatibility` to test old whole-machine memory images.
   - A 65536-byte `.img` or `.bin` can be loaded directly from disk.

## Important Forth distinction

The interactive v8 Forth tab is a **host-side bring-up bridge**. It operates on the same machine memory map and physical-lab state, but it is not falsely presented as the historical 1979 FIG kernel executing on the emulated 65C02.

The included `figforth_portkit/` is the source-retargeting path toward the real FIG kernel. The emulator now also has a historical-image compatibility route for testing an already-built 64K fig-FORTH image.

## Historical image experiment

A known public `basfigmon.img` from BigEd/a6502 is documented as containing:

- supermon64 at `$F800`
- fig-FORTH at `$0200`
- EhBASIC at `$C800`

It uses WDM opcode `$42` signature `$00` for output and `$01` for input. v8 emulates that convention.

Download the 64K image yourself from:

https://github.com/BigEd/a6502/tree/master/extras

Then:

1. Memory / I/O → **Load 64K image**
2. select `basfigmon.img`
3. v8 automatically switches to **Flat 64K compatibility**
4. Reset from vectors for the monitor, or use **PC → $0200 FIG** as an experiment
5. use the UART terminal input/output panel

This path is experimental until the exact image has been run end-to-end in this browser emulator.
