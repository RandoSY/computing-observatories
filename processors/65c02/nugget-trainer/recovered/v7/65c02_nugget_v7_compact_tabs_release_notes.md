# Nugget 65C02 Simulator v7 — Compact Tabbed Workspace

## Layout update

The simulator now uses a viewport-contained application shell designed for a normal desktop browser window.

- The page itself no longer scrolls at standard desktop sizes; each workspace owns its scrolling area when needed.
- The global title, status, run controls, workspace tabs, and active workspace remain visible together.
- The Trainer workspace now has three nested tabs:
  - **CPU Console**
  - **VIA I/O Board**
  - **History**
- The CPU trainer and the experiment board are no longer forced side-by-side, allowing both to use the full available width.
- Code, disassembly, memory, bus-cycle, reference, and test views use the remaining viewport height instead of fixed oversized editor heights.
- At narrower desktop widths, the main workspace tabs become horizontally scrollable.
- At phone-sized widths, the layout returns to conventional document scrolling for usability.

## Validation

- Integrated simulator self-test: **8/8 passed**.
- JavaScript syntax check passed.
- No duplicate element IDs or broken `aria-controls` targets.
- Tested at 1366×768 and 1280×720:
  - body width equals viewport width;
  - body height equals viewport height;
  - all seven main workspaces remain within the browser session window;
  - content-heavy reference material scrolls inside its workspace rather than extending the page.
