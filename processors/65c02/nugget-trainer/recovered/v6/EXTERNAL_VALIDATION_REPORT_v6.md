# 65C02 Nugget CPU Trainer — External Validation Report v6

**Validation date:** July 21, 2026 (America/Chicago)  
**Validated artifact:** `65c02_nugget_simulator_validated_v6.html`

## Executive result

The validation did **not** support calling the previous v5 simulator bug-free. Independent testing found real cycle-accounting defects. Those defects were corrected in v6, and the corrected build then passed:

- the externally authored Klaus Dormann original-6502 functional test;
- **566,401** separately calculated instruction/property cases with **0 failures**; and
- **25/25** integrated browser tests in Chromium with no JavaScript page errors.

The result materially raises confidence in the instruction-level emulator. It does **not** certify exact W65C02 pin-level timing or prove that no defect remains.

## What was independently tested

### 1. Klaus Dormann functional test

The external test was the Klaus Dormann `6502_functional_test`, assembled for load and execution at `$0800`. It tests valid original 6502 opcodes and addressing modes, with emphasis on processor-status behavior. The test signals failure by trapping in a loop at the failing location and success by reaching its terminal self-loop.

**v6 result:**

| Measurement | Result |
|---|---:|
| Outcome | Stable success loop |
| Final PC | `$37B9` |
| Progress byte `$3F00` | `$F0` |
| Instructions executed | 30,038,893 |
| Modeled cycles | 92,996,833 |

Raw result: `results/klaus_result_v6.json`

### 2. Separately calculated oracle cases

A Node.js harness extracted the simulator CPU class and compared its output against independently written expected-value calculations. It covered:

- exhaustive binary `ADC` and `SBC` for every accumulator, operand, and carry input;
- exhaustive valid packed-BCD `ADC` and `SBC` for values 00–99 and both carry states;
- accumulator shifts and rotates;
- `BIT` immediate and zero-page behavior;
- exhaustive `TSB` and `TRB` combinations;
- conditional branches and `BRA`, including page crossings;
- absolute-indexed and indirect-indexed read page-cross penalties;
- read-modify-write timing;
- WDC reserved-NOP lengths and cycle counts;
- stack-pull timing; and
- `WAI` and `STP` timing.

**v6 result:** **566,401 cases, 0 failures**.  
Raw result: `results/property_validation_v6.json`

### 3. Browser-integrated validation

The complete single-file application was executed in headless Chromium. The Test Lab ran all built-in assembly and engine checks.

**v6 result:**

- 25/25 checks passed;
- seven workspace tabs were present;
- exactly one tab panel was visible;
- no JavaScript page errors were observed.

Raw result: `results/browser_validation_v6.json`

## Defects found in v5 and corrected in v6

The pre-fix property harness produced **65,554 failures in 566,393 checks**. Most were repeated instances of one incorrect `BIT` zero-page cycle value. The first failure evidence is preserved in `results/property_before.json`.

| Area | v5 defect | v6 correction |
|---|---|---|
| Page-cross reads | No extra cycle for qualifying absolute-X, absolute-Y, and `(zp),Y` reads | Added page-cross tracking and conditional cycle increment |
| Conditional branches | Taken branch crossing a page omitted one cycle | Added taken and page-cross cycle accounting |
| `BRA` | Overcounted | Corrected base/taken/page-cross rule |
| `BBR` / `BBS` | Taken and page-cross timing incomplete | Added conditional timing |
| Decimal `ADC` / `SBC` | Missing CMOS decimal-mode cycle | Added one cycle when decimal mode is active |
| `BIT zp` | Modeled as 4 cycles | Corrected to 3 cycles |
| Read-modify-write instructions | Several zero-page, indexed, and absolute-X cycle values were wrong | Corrected per addressing mode, including indexed page crossing |
| Pull instructions | `PLA`, `PLP`, `PLY`, and `PLX` modeled as 3 cycles | Corrected to 4 cycles |
| `WAI` / `STP` | Modeled as 2 cycles | Corrected to 3 cycles |
| Reserved WDC NOPs | Operand lengths and cycle counts were generalized incorrectly | Added explicit WDC NOP forms and timings |
| `JMP (indirect)` at `$xxFF` | Special boundary timing not represented | Added boundary-specific extra cycle while retaining CMOS pointer increment behavior |

## Sources and provenance

- Klaus Dormann 6502/65C02 functional tests: `https://github.com/Klaus2m5/6502_65C02_functional_tests`
- `$0800`-assembled Intel HEX image used here: `https://gist.github.com/BigEd/8323021`
- Western Design Center documentation portal: `https://www.westerndesigncenter.com/wdc/documentation.php`
- SingleStepTests 65x02 project, identified as a future pin/bus-sequence validation source: `https://github.com/SingleStepTests/65x02`

The external Klaus material is GPL-3.0 licensed. A GPL-3.0 license copy is included in `external_test/` in the original validation package.

## Remaining limitations

1. **The external Klaus 65C02-extended binary was not executed in this pass.** The built-in suite exercises the implemented 65C02 mnemonics, and the property harness checks several major CMOS extensions, but this is not equivalent to completing Klaus's separate extended-opcode ROM.
2. **The full SingleStepTests per-cycle JSON corpus was not run.** That corpus includes bus activity and is the appropriate next step for exact dummy-read/write sequence comparison.
3. **Bus Cycles remains an educational model.** It shows real emulator memory transactions and fills out internal cycles, but it does not claim transistor- or pin-certified ordering for every dummy access.
4. **Decimal testing is exhaustive for valid packed BCD values, not every invalid BCD nibble combination.**
5. **Browser validation in this pass used Chromium.** Firefox, Safari, and a broad Android device matrix were not exhaustively tested.
6. **VIA and UART are intentionally simplified educational peripherals**, not complete transistor-accurate models of every hardware register and timing interaction.

## Reproduction

From the package root, with Node.js and Python/Chromium available:

```text
node harness/property_validate_v6.js
node harness/run_klaus_v6.js
python harness/browser_validate_v6.py
```

The packaged harnesses resolve simulator and test-data paths relative to the package root. The browser harness requires Chromium and Python's `websocket-client` module.

## Confidence after this pass

A defensible description is:

> **Extensively validated instruction-level educational 65C02 simulator with corrected cycle metadata; not a pin-timing-certified W65C02 implementation.**

The external functional-ROM pass and zero-failure oracle run make common instruction-semantics defects much less likely. Literal bug-free status is still not established, because no finite suite proves absence of all defects and the most demanding per-cycle external corpus remains outstanding.
