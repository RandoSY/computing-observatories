# CRCL v0.6.1 Classroom Workspace — Validation

## Scope

v0.6.1 is a presentation-layer release over the v0.6.0 language-closure baseline. It does not remove or weaken the closed Forth kernel. The default browser experience is intentionally simplified to two large panels: CRCL source and Robot/Reality.

## Verified in this build

- CRCL opens with the CRCL pane active rather than Dashboard.
- Simple View hides the tab strip, generated-Python side panel, target/deployment/debug controls, and other advanced controls.
- Simple View uses a 50/50 CRCL ↔ Reality layout on wide displays.
- Default CRCL code font is 21 px; A− / A+ provide three persistent sizes (21 / 24 / 27 px code scale).
- MORE TOOLS / SIMPLE VIEW preserves the complete advanced UI rather than deleting features.
- Returning to Simple View restores the CRCL editor and Robot Digital Twin.
- Top-level Windows/macOS/Linux launchers serve the correct repository root.
- Static layout render confirms the two panels fill the available browser viewport.
- Existing v0.6.0 language, simulator, BLE, target-certification, glossary, semantic-color, Python Workshop, PXT Harvester, and runtime tests continue to pass.
- Added `tests/test_classroom_ui.mjs` for classroom-presentation regressions.

## Automated suite

`npm test` passes **19 JavaScript + 2 Python** test files.

`npm run check` passes JavaScript syntax validation across the project.

## Browser-render note

A Chromium static-layout render was performed in the build environment and saved as `docs/classroom_ui_static_preview.png`. The environment blocks browser navigation by administrator policy, so a full live Playwright localhost interaction run could not be completed here. Existing application modules and source-level browser integration tests remain green; classroom UI interaction should receive a quick manual smoke test on the target classroom browser.

## Physical validation

Unchanged from v0.6.0: micro:bit v2 + CircuitPython 10.2.1 + Maqueen physical BLE/motor/sensor acceptance remains pending.
