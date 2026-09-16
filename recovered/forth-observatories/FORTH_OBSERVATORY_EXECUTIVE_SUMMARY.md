# Forth Observatory — Executive Summary

The **Forth Observatory** is an attempt to make a tiny computer completely visible.

The physical computer is a Texas Instruments **MSP430G2553**, a 16-bit microcontroller with 16 KB of Flash and 512 bytes of RAM. On that chip runs **430eForth**, descended from Dr. C. H. Ting's work. Forth is unusually useful for this purpose because it is interactive: a learner can type a word, define a new word, inspect memory, control an LED, and immediately see the machine respond.

The Observatory is a browser laboratory around that computer. It combines an interactive Forth terminal, an MSP430 simulator, a processor microscope, a LaunchPad digital twin, and a bridge to the real MSP430G2553.

## A real processor emulator, not a JavaScript imitation of Forth

The most important design decision was **not to rewrite 430eForth in JavaScript**. The browser instead simulates the MSP430 processor and loads the actual compiled 430eForth Intel HEX image.

If the simulated machine accepts:

```forth
1 1 + .
```

and prints `2`, the result comes from the same MSP430 machine instructions that run on the physical LaunchPad.

That lets one computation be examined at several connected levels:

```text
Forth source
    ↓
430eForth dictionary
    ↓
MSP430 assembly
    ↓
machine instructions
    ↓
registers and memory
    ↓
simulated or physical I/O
```

## Why an MSP430 emulator could be built quickly

An emulator does not require inventing a computer. Texas Instruments has already specified the MSP430 architecture precisely. The job is to implement a small, well-defined state machine.

At the center are roughly:

```text
16 registers
64-KiB address space
status flags
program counter
peripheral registers
```

The execution loop is the familiar processor cycle:

1. fetch an instruction,
2. decode it,
3. obtain operands,
4. perform the operation,
5. write the result,
6. update flags,
7. advance or redirect the program counter.

The classic MSP430 is especially approachable because most instructions fall into only three encoding families: **two-operand instructions, single-operand instructions, and jumps**. General operand-reading and operand-writing code also handles register, indexed, indirect, autoincrement and immediate addressing, so many instructions share the same machinery.

The G2553 peripherals can then be added incrementally. Booting 430eForth first requires the CPU, memory, the registers touched during startup, USCI_A0 UART, and selected GPIO behavior—not a perfect simulation of every analog detail of the chip.

The real 430eForth image becomes a demanding regression test. Rather than only asking whether an individual `ADD` seems correct, the stronger question is: **can the authentic firmware boot and operate?** Small independent tests for arithmetic, addressing, branches, HEX loading, UART and GPIO catch simpler bugs before the full firmware exposes them.

The speed therefore came mainly from the MSP430's compact regular architecture, reuse of addressing-mode machinery, and the existence of a real firmware image that defines exactly what compatibility means.

## Why Forth makes the processor visible

In the Ting/Kalus 430eForth implementation, several MSP430 registers have clear Forth roles:

```text
R4 = cached top of data stack (TOS)
R5 = data-stack pointer (DSP)
R6 = Forth instruction pointer (IP)
```

The Observatory can therefore show a Forth word and the processor state that implements it at the same time. The learner is not looking at an abstract virtual machine disconnected from the chip; the language and processor share the same visible state.

## v0.3: two real execution paths

The Observatory now has three primary modes:

- **SIM** — the JavaScript MSP430 executes the 430eForth image.
- **LIVE** — the browser talks through the local Python/pyserial bridge to a physical MSP-EXP430G2ET running eForth.
- **COMPARE** — one Forth command is sent to both, with their terminal streams displayed side by side.

LIVE v0.3 is deliberately honest about its boundary: UART communication does not reveal the physical CPU registers or LEDs. Those physical internals will require the eZ-FET / Spy-Bi-Wire debugger layer planned for a later DEBUG release.

The connected LaunchPad is now a known-good physical reference. When SIM and LIVE disagree, the physical target gives the project an external standard against which the emulator can be improved.

## Educational purpose

The larger principle is simple:

> **Hard to understand what you cannot see.**

The Forth Observatory is intended to make the chain from a Forth word to an MSP430 instruction to a register change to a physical effect observable in one place. It is therefore more than a terminal and more than an emulator: it is a **microscope for computation**.
