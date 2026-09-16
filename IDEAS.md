# Computing Observatories — Idea Record

## Problem

Most programming environments reveal source code and final output while hiding the computational process between them. That makes debugging harder and turns processor architecture, stacks, buses, memory, and language execution into abstractions learners are asked to trust.

## Central idea

Treat the computer itself as an observable phenomenon. A **computing observatory** instruments execution so learners can watch internal state change and connect language, machine architecture, and physical I/O.

## Observatory principle

A useful observatory makes important state visible at the moment it matters:

- instruction/source position;
- registers and flags;
- stack contents;
- memory and I/O;
- buses or logical datapath;
- dictionary/state for Forth;
- execution trace and history;
- breakpoints/watchpoints;
- cause-and-effect between program action and physical/virtual device state.

## Forth observatories

Forth is especially valuable because its data stack, return behavior, dictionary, and incremental interaction can be exposed directly. AVR, MSP430, CH32V003, and browser environments provide different machines while preserving the common act of observing execution.

## Reality View

The important idea behind Reality View is to connect abstract execution state to a representation of the machine or experiment the program is affecting. The learner should not have to choose between “code view” and “real system view.”

## 65C02 lineage

Validated v6 established an instruction-level educational simulator with strong external/regression evidence. Later v8 Forth Lab and v9 Studio work add richer language, debugging, and operator interfaces. These are an evolution of observability; later features must not silently inherit v6 validation claims.

## CRCL / CIRCLE

A compact Forth-like language acts as a transparent control/teaching layer for physical computing. The goal is not a language competition; the goal is a small enough language that execution and device interaction can remain understandable to learner and AI alike.

## Virtual processors on modern hosts

An RP2040 or browser can host classic/simple virtual machines. This turns inexpensive modern hardware into a laboratory for comparing architectures rather than making the modern host itself the only object of study.

## Why it matters

Computational literacy improves when execution is evidence. Learners can form causal explanations instead of memorizing language syntax or treating a debugger as an emergency tool.

## Distinctive contribution

The observatory is not merely an IDE with extra panes. It is an **instrument for computation**, analogous to an oscilloscope or data logger for a physical experiment.

## Representative evidence

- 65C02 validated-v6 simulator, validation report and tests
- 65C02 Instructor Guide / Student Workbook / assessments
- v8 Forth Lab start guide
- v9.4.1 quality audit, debugger guide, R&G examples
- CRCL v0.6.1 translator/validation/Reality View schema
- MSP430/AVR/CH32 Forth Observatory QA and bundle records
- Interactive Arduino historical snapshot

## Reconstruction path

Choose a small processor or VM. Make one instruction step visible from source through machine state. Add stack/memory/I/O views. Add trace and reversible/history behavior. Connect one I/O action to a physical or virtual device. Require prediction before stepping and causal explanation after stepping.
