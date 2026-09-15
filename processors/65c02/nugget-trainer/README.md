# 65C02 Nugget CPU Trainer — migrated project record

**Source repository:** https://github.com/RandoSY/STEM-Fusion

**Source snapshot:** `41b1766c4f721a13312de9200c6c221c61155d8d` (22 Jul 2026)

**Disposition:** estate-owned 65C02 observatory lineage; documentation migrated, source artifacts not present in the source repository snapshot.

The source repository describes a standalone browser-based W65C02 educational simulator and validation laboratory intended to make instruction execution visible through source/disassembly highlighting, instruction and Φ2 stepping, animated datapaths, bus-cycle views, reversible execution, memory visualization, peripheral models, and an assembly test laboratory.

The recorded release is **Validated v6 — July 21, 2026**. Its source README reports:

- Klaus Dormann 6502 functional ROM reaching the success loop at `$37B9`;
- 30,038,893 instructions executed in the external ROM run;
- 566,401 independently calculated expected-value cases passed;
- 25 integrated Chromium checks passed;
- 20 standalone assembly validation programs included.

The README explicitly describes the validation boundary as instruction-level/educational rather than pin-accurate or transistor-level timing.

## Migration finding

At the inspected GitHub snapshot, the legacy repository tree contains only its `README.md`; the `index.html`, simulator, tests, manuals, and validation paths named by that README are not present there. Therefore those artifacts have **not** been fabricated or marked migrated here.

## Third-party boundary

The source README states that the intended validation tree included Klaus Dormann functional-test material under GPL-3.0 and that no project-wide open-source license had yet been selected for the original Nugget simulator/documentation. Any later recovery of those missing artifacts must preserve that licensing distinction.

## Next recovery action

Search the broader Intellectual Estate file archive for the named v6 artifacts (`index.html`, `OPERATIONS_MANUAL.md`, validation reports/results, and assembly tests). If recovered, bring them here with their original provenance and licensing intact.
