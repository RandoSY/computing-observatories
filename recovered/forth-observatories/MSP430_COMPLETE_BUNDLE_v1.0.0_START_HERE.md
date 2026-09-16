# MSP430 Forth Observatory — Complete Bundle v1.0.0

This is the consolidated release containing the two current software branches of the MSP430/430eForth project in one download.

## Included versions

### 1. Forth Observatory Dashboard v0.4.2

Folder: `01_Forth_Observatory_Dashboard_v0.4.2/`

The browser laboratory includes:

- JavaScript MSP430G2553 CPU simulation,
- authentic Ting/Kalus/Mahlow 430eForth 43n1 execution,
- SIM / LIVE / COMPARE operation,
- CPU microscope, Forth stacks, disassembly and LaunchPad digital twin,
- MSPDebug / Spy-Bi-Wire physical-debug qualification path,
- **Forth Awareness** semantic colors,
- **Execution Elevation**: CPU / FORTH / WORD / COMMAND stepping,
- bounded semantic runs, stop conditions and replay timeline.

For this complete bundle, the pinned 430eForth HEX is already present under `vendor/upstream/`, so SIM can boot without first downloading it.

Start it with:

```text
cd 01_Forth_Observatory_Dashboard_v0.4.2
python -m pip install -r requirements.txt
python tools/serve_observatory.py --open
```

Run `python tools/vendor_upstream.py` only when you want the additional pinned ASM/INC/source files used for rebuilding the eForth kernel.

### 2. RP2040 Virtual MSP430G2553 LaunchPad v0.1.0

Folder: `02_RP2040_Virtual_LaunchPad_v0.1.0/`

This is the new dual-core C++/Arduino-Pico hardware-emulator branch:

- RP2040 Core 1 executes a virtual MSP430G2553,
- RP2040 Core 0 handles USB, terminal and debugger requests,
- authentic 430eForth 43n1 is embedded as the default target image,
- USB CDC acts as the virtual MSP430 application UART,
- a second vendor USB interface implements MehFET framing for MSPDebug,
- a semantic classic-MSP430 JTAG/SBW DAP models register/memory/debug behavior,
- a built-in Ctrl-] monitor provides halt/run/reset/step/register/memory control.

The C++ emulator is independently regression-tested and currently boots the real 430eForth image and evaluates:

```forth
1 1 + .
```

as:

```text
2 ok
```

See the component `README.md` for Arduino IDE setup and the physical MSPDebug qualification sequence.

## The intended three-way laboratory

Once the Pico USB path is physically qualified, the project can compare three representations of the same machine:

```text
                         Forth Observatory
                    Forth Awareness / Elevation
                               |
              +----------------+----------------+
              |                |                |
              v                v                v
        JavaScript G2553   Real TI G2553   RP2040 Virtual
          simulator         LaunchPad       LaunchPad
                                              |
                                       virtual G2553
                                       + virtual probe
```

The point is not merely to run Forth three ways. It is to make the causal chain visible from **Forth word -> threaded execution -> MSP430 instruction -> register/stack change -> I/O effect**, while retaining a real-hardware reference.

## What is qualified today

Dashboard v0.4.2 application/tests are passing in this bundle. The RP2040 C++ CPU, authentic Forth boot/interpreter, MehFET framing, and virtual JTAG/DAP semantic tests are also passing.

The remaining major qualification is physical: compile/upload the Pico sketch, confirm the composite USB interfaces, and connect an unmodified MSPDebug build to the MehFET interface. Until that succeeds, the Pico branch is correctly labeled **v0.1.0 / hardware-integration stage**, not a finished replacement for a TI LaunchPad.

## First recommended sequence

1. Run the Dashboard in SIM and confirm `1 1 + .` -> `2`.
2. Open the Dashboard's Execution Elevation controls and use FORTH stepping.
3. Compile/upload the Pico firmware using Arduino-Pico + Adafruit TinyUSB.
4. Confirm the Pico CDC terminal displays `430eForth43n1` and answers `1 1 + .`.
5. Press Ctrl-] and exercise `.regs`, `.step`, `.mem`, `.reset`.
6. Determine the Pico VID:PID and try `mspdebug -V <VID>:<PID> mehfet`.
7. Begin with nondestructive MSPDebug commands: `regs`, `md`, `dis`, `step`.
8. Only after those pass, qualify virtual flash programming/erase.

## Integrity

`CHECKSUMS.sha256` contains hashes for every regular file in the bundle.
`TEST_RESULTS.txt` records the tests run immediately before packaging.
