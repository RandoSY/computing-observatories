# QA Report — DP10 Synchronized Three Observatories

## Release intent

DP10 brings the MSP430G2553 and CH32V003 Observatory dashboards to the same usability/accessibility level as the qualified AVR DP9.3 interface, while preserving the already-qualified guest firmware and emulator cores.

## Regression results

### AVR / ATmega328P

PASS:
- AVR core and authentic 328eForth instruction tests.
- Ting dictionary/elevation profile.
- Authentic 328eForth boot/interpreter.
- Resident `SEE` cold boot.
- Corrected `FLUSH` cold-reboot persistence.
- Compile + FLUSH + execute.
- Browser/Pico/corrected-HEX image consistency.
- Browser SIM structure.
- Accessibility + semantic-color contract.
- Persistent shell-style Forth command history.
- Browser emulator + 328eForth + cold-reboot persistence.

### MSP430G2553

PASS:
- Virtual LaunchPad desktop core.
- Authentic 430eForth boot/interpreter.
- MehFET framing/handshake.
- Virtual MSP430 JTAG/DAP semantics.
- Authentic 430eForth SEE profile.
- Resident `SEE` cold boot.
- Browser emulator JavaScript test suite.
- DP10 static accessibility/history synchronization contract.

### CH32V003 / RV003eForth

PASS:
- JavaScript CH32V003/RV003eForth emulator.
- `9 SQUARE .` -> `81 ok`.
- Ting Browser SIM compatibility: **22 commands**.
- **0 bad reads / 0 bad writes** in Ting compatibility run.
- Chromium Browser UI test at 1366×768 and 1920×1080.
- Resident SEE after cold boot.
- Observatory/original image selector.
- CPU/token/word elevation controls.
- DP10 static accessibility/history synchronization contract.

## Launcher qualification

The local servers were started and probed directly. Each returned its expected `X-Observatory-Release` identity and served the DP10 Browser SIM page:

- AVR: `127.0.0.1:8785` — `DP10-AVR`
- MSP430: `127.0.0.1:8786` — `DP10-MSP430`
- CH32V003: `127.0.0.1:8787` — `DP10-CH32V003`

No launcher silently falls back to a random port.

## Qualified default image hashes

- AVR corrected 328eForth HEX: `2325bfc17e81408fa872fd3bd6b03e5c0df0db78bdfec12400233aefe2bfbb6e`
- MSP430 resident-SEE HEX: `04422d13b3ee5ed6bebf272947bf7fe51e876a7b3e2ea7532f60ae22233a563b`
- CH32V003 RV003eForth Observatory-SEE BIN: `443b6f1d882b021413501e6892737e9d3fa988ebcfa73294d2f906185640769e`

The synchronized release modifies presentation/launcher files for MSP430 and CH32V003, not these qualified guest images.
