# Examples (`examples/<board-id>/<example-name>/`)

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

Each example is a standalone Apio project. Users fetch it with `apio examples fetch` and learn from it, so keep the code easy to read:
- Choose the simplest design that shows the point.
- Use clear names.
- Leave out clever tricks and features the example doesn't need.
- Give each group of related lines (a declaration, an `always` block, an `assign`, an instance) a short comment above it saying what it does.

`alhambra-ii/blinky/main.v` shows the style.

## Which rules apply

The rules in this file are a mix of what `test_examples.py` enforces and repo conventions. Many existing examples predate the conventions. Apply the rules to new examples and to examples you rework. Don't fix other examples unless asked. Where a rule says how many examples follow it today, rename or rewrite the others only when asked or when already reworking that example.

## The `blinky` example

Every board should have an example named `blinky` that blinks an LED at about 1 Hz. It is the board's "hello world", so keep it as simple as possible: a clock divider driving one LED, plus its testbench. `alhambra-ii/blinky` is the reference.

Boards without a `blinky` yet:
- `fomu` (it has `blink` instead)
- `ice40-hx1k-evb`, `ice40-hx8k-evb`, `ice40-hx8k`
- `icestick`, `icezum`, `kefir`
- `soan-papdi-mini`, which has no examples at all yet

## Files in an example

| File | Required | Purpose |
|---|---|---|
| `info` | yes | A one-line description of the example |
| `apio.ini` | yes | The Apio project file |
| `main.v` / `main.sv` and other Verilog files | yes | The design |
| `pinout.<ext>` | yes | The constraint file, mapping signals to FPGA pins |
| `<name>_tb.v` / `<name>_tb.sv` | should have | Testbenches |
| `<name>_tb.gtkw` | one per testbench | The saved GTKWave view for each testbench |

Names:
- The board dir name must be a board ID defined in `boards.jsonc`. Add the board definition before adding its examples.
- Board and example names match `^[a-z][a-z0-9-]*$`.

### `info`

Every example must have an `info` file in its root dir. It holds exactly one line of text that describes the example, at most 40 characters long, with no leading or trailing spaces.

`test_examples.py` checks for one line of 10 to 100 characters, so it doesn't catch lines of 41 to 100 characters. Today 8 of the 112 `info` files are longer than 40 characters.

### `apio.ini`

Every Apio project needs an `apio.ini` at the top of its dir, and all the examples have one. The format is documented at https://fpgawars.github.io/apio/docs/project-file/. In short:

- **Header:** start the file with these two comment lines:
  ```ini
  ; Apio project configuration file.
  ; See https://fpgawars.github.io/apio/docs/project-file for details.
  ```
- **Sections:**
  - `[apio]` (optional): may hold only `default-env`.
  - `[common]` (optional): options shared by all envs.
  - `[env:<name>]`: one or more envs. An env's own values override `[common]`.
- **Env names:** an example with a single env names it `[env:default]`. All the current single-env examples do.
- **Which env runs:** the `--env` flag if given, else `[apio] default-env`, else the first env listed.
- **Required in each env** (directly or through `[common]`):
  - `board`: must be a known board. In each example, at least one env's `board` must be the board of its parent dir. Examples for several boards are allowed.
  - `top-module`: name the top module `main`, not an example-specific name like `blinky`. Today 65 of the 112 examples still use other names (`blinky`, `Test`, `top`, `leds`, ...).
- **Common optional options:**
  - `constraint-file`: needed only if the example doesn't have exactly one file with the FPGA family's constraint extension.
  - `default-testbench`: the testbench `apio sim` opens when run without arguments. Set it when the example has more than one testbench.
  - `defines`: Verilog macros, one per line, passed as `-D`.
  - `programmer-cmd`.
  - `yosys-extra-options`, `nextpnr-extra-options`, `verilator-extra-options`, `gtkwave-extra-options`, and `format-verible-options`.

`alhambra-ii/multi-env` shows `[apio]`, `[common]` and several `[env:*]` sections together.

### Constraint file (`pinout.<ext>`)

- **Name:** `pinout.<ext>`, with the extension for the FPGA family:

  | Family | Extension | Example line |
  |---|---|---|
  | ice40 | `.pcf` | `set_io leds[0] 45` |
  | ecp5 | `.lpf` | `LOCATE COMP "leds[0]" SITE "H3";` |
  | gowin | `.cst` | `IO_LOC "leds[0]" T6;` |
  | xilinx | `.xdc` | `[get_ports {leds[0]}]` |

  Today 38 of the 114 constraint files are named `pinout.*`. The others use board or example names (`leds.pcf`, `blinky.cst`, `<board>.xdc`, ...).
- **Several constraint files:** an example that needs more than one selects one per env with `constraint-file = ...` in `apio.ini`. See `alhambra-ii/constraint-files` and `alhambra-ii/multi-board`.
- **Contents:** define only the pins the example uses. Other board pins may also be listed as a reference, as long as they're commented out and their definitions are correct. Many existing constraint files still define every board pin uncommented (e.g. with `set_io -nowarn`).

## Verilog design rules

### Clock

Name the design's main clock `sys_clk`:
- **Without a PLL**, or with a PLL that keeps the same frequency, `sys_clk` is the external clock: name the top module's input `sys_clk` and use that name in the constraint file.
- **With a PLL that changes the frequency**, `sys_clk` is the PLL's output clock, and the external clock input gets another name.

Testbenches drive `sys_clk` too. Many Gowin examples already do this (e.g. `sipeed-tang-nano-9k/blinky`). Others still use `CLK`, `clk`, etc.

### Reset

Designs are synchronous by default: one clock `sys_clk` and one common active-high reset `sys_rst`.
- Generate `sys_rst` inside the top module as a power-on reset. Don't use a board pin, since many boards have no reset button.
- Apply it synchronously: `always @(posedge sys_clk) if (sys_rst) ... else ...`. Don't put `posedge sys_rst` in the sensitivity list.
- By default the reset lasts 3 clocks, using a 2-bit `rst_cnt`. An n-bit counter gives 2^n − 1 clocks.

This pattern was checked with `apio build` and `apio test` on alhambra-ii. `alhambra-ii/bcd-counter` and `alhambra-ii/bcd-counter-sv` use it.

```verilog
// Power-on reset: sys_rst is high for the first 3 clocks.
reg [1:0] rst_cnt = 0;
wire sys_rst = ~&rst_cnt;
always @(posedge sys_clk) if (sys_rst) rst_cnt <= rst_cnt + 1;
```

**Exception for simple `blinky` examples:** prefer dropping `sys_rst` and giving registers initial values instead (`reg [N-1:0] counter = 0;`). Do this only if it works in both places:
- On the FPGA, where Yosys turns the value into the flip-flop's power-up value.
- In the testbench, where Icarus applies the value at time 0. Without it the register stays `X`.

`alhambra-ii/blinky` does this.

### Ports and names

- For groups of LEDs, buttons, switches, etc., use one vector port (`output [7:0] leds`) rather than separate signals (`LED0` ... `LED7`). The constraint file then names each bit, e.g. `leds[0]` (see the table above).
- Name modules, instances, signals and files in lowercase `snake_case`, and parameters in `UPPER_CASE` (`DIV`).
- Name active-low signals with an `_n` suffix (`btn_n`). Invert active-low board signals once, in the top module, so the rest of the design is active-high.

### Code structure

- **One module per file**, with the file named after the module (`ticker` in `ticker.v`).
- **Timing constants are parameters:** make clock dividers, counter widths and delays module parameters. The default is the value for the real board, and testbenches override it with a small value so simulations run quickly. Examples: `DIV` in `alhambra-ii/bcd-counter`, `N` in `alhambra-ii/blinky`.
- **Assignments:** in clocked `always @(posedge sys_clk)` blocks, use non-blocking `<=`. In combinational `always @(*)` blocks, use blocking `=`, and assign every output in every branch so no latches are inferred.
- **Long numbers:** use `_` to group digits from the right: every 3 digits in decimal numbers of 5 or more digits (`12_000_000`, not `12000000`), and every 4 digits in hex and binary numbers longer than 4 digits (`32'hDEAD_BEEF`, `8'b1010_0101`). Short numbers such as `1000`, `8'hFF` and `4'b1010` stay as they are. Today most examples don't follow this.
- **Inputs:** pass button and switch inputs through a two flip-flop synchronizer clocked by `sys_clk` before using them. Debounce them when the design reacts to presses.
- **Comments:** start each Verilog file with a one-to-three-line comment saying what the module does. In the top module, give the clock input's frequency in its port comment (`input sys_clk,  // 12MHz clock`).

### Vendor primitives that can't be simulated

Some primitives, such as the PLLs `SB_PLL40_CORE` and `PLLE2_BASE`, can't be simulated. Wrap the primitive in `` `ifdef SYNTHESIS`` (Yosys defines `SYNTHESIS` during synthesis), and put a simple simulation model in the `` `else`` branch, so the same module works in testbenches. For a PLL, the model passes the input clock through and ties `locked` high.

See `pll.v` in `examples/alhambra-ii/pll` or `examples/arty-a7-35t/pll`. The PLL examples for `colorlight-5a-75b-v8`, `sipeed-tang-nano-9k` and `sipeed-tang-nano-20k` don't have this yet.

## Lint and formatting

- **Lint:** `apio lint` must report no warnings. It exits with an error on any Verilator warning, so `test_examples.py` already fails on them. Width-explicit constants (`4'd0` rather than `0` where widths differ) avoid most width warnings.
- **Formatting:** all examples must be formatted with `apio format`, so that running it again changes no file. Run `apio format` in each example you add or edit, or `invoke format` for all. `test_examples.py` runs `apio format` but doesn't check for a diff, so check with `git diff` afterwards. As of 2026-10-22, every example passes this check.
- **`NO_FORMAT_EXAMPLES`** in `test_examples.py` lists examples the test skips formatting for (`fomu/blink`, `icezum/marcha-imperial`). Both now format cleanly, so the list may be stale.

## Testbenches

Every example should have at least one testbench, named `*_tb.v` or `*_tb.sv`. `apio test` runs the testbenches in batch mode, and `apio sim` opens one in GTKWave. Each testbench needs a matching `.gtkw` file (see "GTKWave save files" below). `test_examples.py` doesn't enforce the at-least-one rule yet, and some older examples have no testbench.

### Testbench rules

Write new testbenches, and testbenches you rewrite, to these rules.

**Checking results**

1. Define an `EXPECT_EQ(actual, expected)` macro at the top of the file. On a mismatch it prints the expected and actual values with the file name and line (`` `__FILE__ ``, `` `__LINE__ ``), then stops with `$fatal`.
2. Declare `reg assertion_err = 0;` and set it to 1 when an assertion fails.
3. Always guard `$fatal` as `` if (!`APIO_SIM) $fatal; ``. Apio defines `APIO_SIM=0` for `apio test` and `1` for `apio sim`, so a failure under `apio sim` keeps running and the bad signals can be inspected in GTKWave.
4. Keep testbenches self-contained: define helper macros (such as `EXPECT_EQ`) in the testbench file itself rather than `` `include``-ing a shared macro file.

**Structure and names**

5. Name the testbench module after its file (`bcd_digit_tb.v` holds `module bcd_digit_tb`). `$dumpvars` and the `.gtkw` signal paths use this name.
6. Name the instance of the module under test `dut` (e.g. `main dut (...)`), so signal paths are always `<tb>.dut.<signal>`. Today 13 of the 77 testbenches do this.
7. Give each submodule with non-trivial logic its own testbench next to its source file (e.g. `bcd/bcd_digit_tb.v` and `util/ticker_tb.v` in `alhambra-ii/bcd-counter`).

**Clock and timing**

8. Use `` `timescale 1ns / 1ps`` and a 10 ns clock (`always #5 sys_clk = ~sys_clk;`), so timings and `.gtkw` zoom values are comparable across examples.
9. Declare a clock counter `clk_num` that increments on each rising edge of `sys_clk`. It's an `integer`, or an `int` in SystemVerilog: `integer clk_num = 0; always @(posedge sys_clk) clk_num <= clk_num + 1;`.
10. Change inputs and check outputs away from the clock edge, e.g. `@(posedge sys_clk); #1;` before setting inputs or calling `EXPECT_EQ`. This avoids races between the testbench and the design.

**What to test**

11. Check the behavior throughout the simulation, not one value at the end, and cover edge cases such as reset and wrap-around. `alhambra-ii/bcd-counter/main_tb.v` checks the count after every clock, past the 99 to 00 wrap.

**Simulation output**

12. Call `$dumpvars(0, <testbench_module_name>);`.
13. Never call `$dumpfile()`. Apio sets the VCD file itself, and `test_examples.py` fails on it.
14. Print `End of simulation` at the end of the testbench.

### Testbench skeleton

This skeleton was checked with `apio test`, both passing and failing. Icarus Verilog substitutes macro parameters even inside string literals, so don't name the macro's parameters with words that appear in its message: use `actual_val`/`expected_val`, not `actual`/`expected`.

```verilog
`define EXPECT_EQ(actual_val, expected_val) \
  if ((actual_val) !== (expected_val)) begin \
    $display("*** ASSERTION FAILED at %s:%0d: expected 'h%h, actual 'h%h", \
             `__FILE__, `__LINE__, (expected_val), (actual_val)); \
    assertion_err = 1; \
    if (!`APIO_SIM) $fatal; \
  end

`timescale 1ns / 1ps

module main_tb;
  reg assertion_err = 0;

  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // ... DUT instance and signals ...
  initial begin
    $dumpvars(0, main_tb);
    // ... stimulus, then e.g. `EXPECT_EQ(count, 4'd3)
    $display("End of simulation");
    $finish;
  end
endmodule
```

### Older testbenches

Most existing testbenches predate these rules. 13 of them `` `include`` an `apio_testing.vh` or `apio_testing.svh` macro file and use its `` `EXPECT``, `` `TEST_BEGIN`` and `` `TEST_END`` macros. Don't copy that style into new testbenches.

## GTKWave save files (`<testbench>.gtkw`)

A `.gtkw` file is the saved GTKWave signal view that `apio sim` opens for a testbench.

### Signals

- **Order:** list `assertion_err` first, shown in red with `[color] 1`. Then `clk_num`, `sys_clk`, and `sys_rst` if the design has one. Then the other signals.
- **Groups:** separate related groups with blank lines (`@200` followed by `-`) and comment lines (`@200` followed by `-<text>`).
- **Paths:** signal paths are hierarchical from the testbench module. `sys_rst` is generated inside the DUT, so its path is `<tb>.dut.sys_rst`.
- **Formats:** the flag line before a signal sets its display format:

  | Flag | Format | Use for |
  |---|---|---|
  | `@28` | binary | 1-bit signals |
  | `@24` | decimal | |
  | `@22` | hex | |
  | `@420` | signed decimal | integers such as `clk_num` |

  List an integer such as `clk_num` without a range (`<tb>.clk_num`), as the existing GTKWave-saved files do.

### Machine-specific lines

Leave out the `[dumpfile]` and `[savefile]` lines (and `[dumpfile_mtime]`, `[dumpfile_size]`). They hold absolute paths from the author's machine. GTKWave writes them on every save, so remove them after saving a file from GTKWave.

### Editing an existing `.gtkw` file

Keep the author's choices: the signals, their grouping and order, comment lines, display formats and colors. They were picked to be intuitive to read. Change them only where a rule requires it (e.g. adding `assertion_err` and `clk_num`), or where a signal was renamed or removed. Don't add, drop, regroup or reformat signals otherwise.

Keep the author's markers too, except markers past the end of the simulation (e.g. after the testbench got shorter): set those to `-1`.

### Zoom and markers

The file should open zoomed out to show the whole simulation. Fitting the zoom by hand in GTKWave and saving works. GTKWave has no "zoom to fit" setting in save files, so to set the zoom in the file itself:

- **The zoom line** looks like `*<zoom> <marker> -1 ...`. The first number is the zoom. The 27 values after it are the primary marker and then the named markers A–Z, all in VCD time units. A marker of `-1` means none.
- **The formula:** GTKWave shows `2^(-zoom) / 200` VCD time units per pixel. For a simulation that ends at time `T` and a wave area `W` pixels wide:

  ```
  zoom = -log2(T * 200 / W)
  ```

  - Get `T` from the `$finish called at T` line in the `apio sim` output. It's in VCD units, usually ps.
  - With `[size] 1000 600`, `[sst_width] 253` and `[signals_width] 160`, `W` ≈ 559. This was calibrated against `getting-started/main_tb.gtkw`, which was saved with Zoom Full.
- **When to recompute:** whenever the testbench's length changes.
- **No scripting:** the GTKWave in oss-cad-suite has no Tcl `--script` support, so this can't be automated with a GTKWave script.
- **macOS:** that GTKWave (4.0.0-prealpha) opens at full screen width and can't be made narrower, whatever `[size]` says. This happens with GTKWave-saved files too, so it can't be fixed in `.gtkw` files.

Example:

```
[size] 1000 600
*-17.347122 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[sst_width] 253
[signals_width] 160
@28
[color] 1
main_tb.assertion_err
@420
main_tb.clk_num
@28
main_tb.sys_clk
main_tb.dut.sys_rst
@200
-
-Counter
@24
main_tb.dut.counter[3:0]
@200
-
-LEDs
@28
main_tb.led7
```
