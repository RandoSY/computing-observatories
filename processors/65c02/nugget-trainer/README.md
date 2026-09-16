# 65C02 Nugget CPU Trainer — recovered project record

**Legacy source repository:** `RandoSY/STEM-Fusion`  
**Legacy snapshot:** `41b1766c4f721a13312de9200c6c221c61155d8d` (22 Jul 2026)  
**Disposition:** estate-owned 65C02 observatory lineage; legacy GitHub snapshot preserved, with later source and curriculum artifacts recovered from the Intellectual Estate Library.

The historical project is a standalone browser-based W65C02 educational simulator and validation laboratory intended to make instruction execution visible through source/disassembly highlighting, instruction and Φ2 stepping, animated datapaths, bus-cycle views, reversible execution, memory visualization, peripheral models, and an assembly test laboratory.

## Validated-v6 recovery

The legacy `STEM-Fusion` GitHub snapshot itself retained only its README, but the broader Intellectual Estate Library contained the missing v6 artifacts. They have now been recovered here rather than fabricated from the README.

Recovered under `recovered/v6/`:

- exact recovered `65c02_nugget_simulator_validated_v6.html`, preserved losslessly as a deterministic gzip/base64 chunk archive with reconstruction instructions and SHA-256 hashes;
- `EXTERNAL_VALIDATION_REPORT_v6.md`;
- `TEST_RESULTS.md`.

The recovered validation evidence reports:

- Klaus Dormann 6502 functional ROM reaching the success loop at `$37B9`;
- 30,038,893 instructions and 92,996,833 modeled cycles in that run;
- 566,401 independently calculated instruction/property cases with 0 failures after the v6 corrections;
- 25/25 browser-integrated Chromium checks with no JavaScript page errors;
- a separate regression record with 24/24 integrated checks, 20 runnable assembly programs, 98/98 implemented mnemonics exercised, 216/216 assembler forms assembled, and 256/256 opcode decoder slots validated.

The external report also records that the pre-fix v5 property run exposed 65,554 failures in 566,393 checks, leading to corrections in page-cross timing, branch timing, decimal-cycle accounting, `BIT zp`, read-modify-write timing, pull instructions, `WAI`/`STP`, reserved WDC NOPs, and indirect-JMP boundary behavior.

## Validation boundary

A defensible description remains:

> Extensively validated instruction-level educational 65C02 simulator with corrected cycle metadata; not a pin-timing-certified W65C02 implementation.

The recovered report explicitly notes remaining limits: the separate Klaus extended-65C02 ROM was not run in that pass; the full SingleStepTests per-cycle bus corpus was not run; decimal testing was exhaustive for valid packed BCD rather than all invalid-nibble combinations; browser validation was centered on Chromium; and the VIA/UART models are educational simplifications.

## Curriculum recovery

The Library also contains substantial instructional material built around the validated-v6 simulator, including:

- `65C02_Nugget_Instructor_Curriculum_Guide.pdf`;
- `65C02_Nugget_Student_Laboratory_Workbook.pdf`;
- `65C02_Nugget_Assessments_Rubrics_and_Answer_Key.pdf`;
- `65C02_Nugget_Complete_Curriculum_All_Volumes.pdf`.

These documents describe a 36-lesson, 24-primary-lab curriculum with projects, unit checks, midterm/final work, capstone, and oral defense, organized around the cycle **Predict -> Execute -> Observe -> Explain -> Rewind -> Modify -> Validate**. Searchable repository-native editions are being recovered under this project record.

## Later lineage

The Library also contains later 65C02 Nugget/Forth/Studio HTML lineages (v7 release notes, v8 Forth-lab builds, and v9 Studio builds). Their presence is evidence of continued development, but version number alone is not treated as proof of equal or greater validation. They will be preserved with their own historical status.

## Third-party boundary

The recovered v6 validation record cites Klaus Dormann functional-test material under GPL-3.0. That third-party test material must retain its own license and attribution. No project-wide estate license is inferred from its presence.

## Remaining recovery targets

Continue searching for the original operations manual, validation harness directories, raw result JSON, assembly-test tree, extended-65C02 test evidence, and any release package/manifest that can be recovered as an exact artifact. Missing elements should remain explicitly identified rather than silently reconstructed.
