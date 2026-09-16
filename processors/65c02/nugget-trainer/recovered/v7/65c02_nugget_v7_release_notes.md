# 65C02 Nugget CPU Trainer — Version 7

## Release focus

Version 7 adds a polished, program-controlled VIA experiment board while preserving the simulator as one standalone, offline HTML file.

## New VIA experiment board

- Three large output LEDs connected to VIA Port B:
  - PB0 — red
  - PB1 — yellow
  - PB2 — green
- Two active-low SPST input switches connected to VIA Port A:
  - PA0 / SW1 — keyboard `Q`
  - PA1 / SW2 — keyboard `W`
- Simulated pull-ups: an open switch reads 1 and a closed switch reads 0.
- The keyboard changes only the external input pins. A running 65C02 program must read Port A, make a decision, and write Port B to change the LEDs.
- Professional board styling with PCB traces, terminals, silkscreen, fasteners, switch hardware, LED lenses, and a 6522 package.

## VIA and I/O model

- `$F800` — ORB / Port B
- `$F801` — ORA / Port A pin state
- `$F802` — DDRB
- `$F803` — DDRA
- Timer 1, ACR, IFR, IER, and VIA IRQ behavior
- UART remains at `$F810` / `$F811`
- Front-panel latches remain at `$F820`–`$F825`

## Assembler improvements

- Labels and forward references
- `NAME = expression`
- `.equ NAME, expression`
- `.org`, `.byte`, `.word`, and `.text`
- Character literals
- Arithmetic and bitwise expressions
- `LOW()` and `HIGH()`
- 65C02 addressing modes and extensions used by the included demonstrations

## Included demonstrations

- Heavily commented VIA switch-to-traffic-light program
- UART hello program
- VIA Port B counter
- Timer 1 IRQ heartbeat

## Simulator workspaces

1. Trainer
2. Datapath
3. Bus Cycles
4. Code
5. Memory / I/O
6. Reference
7. Test Lab

## Validation performed

- JavaScript syntax checked with Node.js
- Browser smoke test completed without console or page errors
- Integrated Test Lab result: 8/8 passed
- VIA functional test:
  - both switches open → green
  - SW1 closed → yellow
  - both switches closed → all three LEDs

## Model boundary

Bus-cycle replay is an educational transaction model. It is intended to connect instructions to observable reads and writes; it is not a transistor-level or pin-waveform simulation.
