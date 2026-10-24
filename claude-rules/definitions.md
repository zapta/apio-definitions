# Definitions (`definitions/*.jsonc`)

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

The `definitions/` dir holds three data files that tell Apio which boards, programmers and FPGAs exist. They are JSON with comments (`.jsonc`). Each file is one JSON object whose keys are IDs, such as a board ID or a programmer ID.

| File | Defines | Referenced by |
|---|---|---|
| `boards.jsonc` | The boards Apio supports | `board =` in each example's `apio.ini` |
| `programmers.jsonc` | The commands that upload a bitstream to a board | the `programmer` field of each board |
| `fpgas.jsonc` | Overrides of the FPGA definitions | the `fpga-id` field of each board |

## Boards (`boards.jsonc`)

Each entry describes one board. For example:

```jsonc
// https://github.com/FPGAwars/Alhambra-II-FPGA
"alhambra-ii": {
  "description": "Alhambra II",
  "fpga-id": "ice40hx4k-tq144-8k",
  "programmer": {
    "id": "openfpgaloader",
    "extra-args": "-b ice40_generic --vid ${VID} --pid ${PID} --busdev-num ${BUS}:${DEV}"
  },
  "usb": {
    "vid": "0403",
    "pid": "6010",
    "product-regex": "^Alhambra II.*"
  }
}
```

The fields:

| Field | Required | Meaning |
|---|---|---|
| key (`alhambra-ii`) | yes | The board ID. Lowercase letters, digits and `-`. It is also the board's dir name under `examples/` and the value of `board =` in `apio.ini`. |
| `description` | yes | The board's name as people know it. |
| `fpga-id` | yes | The FPGA on the board, as an FPGA ID (see "FPGAs" below). |
| `programmer.id` | yes | Which entry of `programmers.jsonc` uploads to this board. |
| `programmer.extra-args` | no | Arguments added after the programmer's own arguments, for options that are specific to this board. |
| `usb.vid`, `usb.pid` | no | The USB vendor and product IDs (hex, without `0x`), used to find the board when it's plugged in. |
| `usb.product-regex` | no | A Python regex matched against the USB product string, as shown by `apio devices usb`. Use it to tell apart boards that share a VID and PID. Start it with `^` to match from the beginning of the string. |
| `tinyprog.name-regex` | no | For boards programmed with `tinyprog`: a regex matched against the name the board reports. |

Put a comment with the board's web page above each entry (`// https://...`), as the other entries do.

## Programmers (`programmers.jsonc`)

Each entry is a command line for uploading a bitstream. For example:

```jsonc
"iceprog": {
  "command": "iceprog",
  "args": "-d d:${BUS}/${DEV}"
}
```

Apio builds the full command from the programmer and the board:

```
<command> <programmer args> <board extra-args>
```

Apio replaces these placeholders when it runs the command:

| Placeholder | Replaced with |
|---|---|
| `${VID}`, `${PID}` | The board's USB vendor and product IDs |
| `${BUS}`, `${DEV}` | The board's USB bus number and device address |
| `${SERIAL_PORT}` | The board's serial port |
| `${BIN_FILE}` | The path to the bitstream file |

A command can use the USB placeholders or `${SERIAL_PORT}`, but not both. If `${BIN_FILE}` doesn't appear in the command, Apio adds the bitstream path at the end.

## FPGAs (`fpgas.jsonc`)

The main FPGA definitions are not in this repo. They are generated automatically elsewhere. `fpgas.jsonc` is only an **override** file: an entry here replaces or adds to the generated definition with the same ID. Add an entry only when a generated definition is wrong or missing.

Today the file holds no active entries, only commented-out templates, one per FPGA family (`ice40`, `ecp5`, `gowin`, `xilinx`). Copy the matching template when you need an override. For example:

```jsonc
"lfe5u-12f-6bg256c": {
  "arch": "ecp5",
  "vendor-part": "LFE5U-12F-6BG256C",
  "size": "12k",
  "ecp5-params": {
    "nextpnr-type": "12k",
    "nextpnr-package": "CABGA256",
    "nextpnr-speed": "6"
  }
}
```

- **Key (FPGA ID):** the vendor part number in lowercase, keeping only letters and digits. It may end with a variant suffix, such as `-8k` for a 4k part that is used as an 8k part (`ice40hx4k-tq144-8k`).
- **Values:** follow the `FpgaDefinition` protocol buffer in Apio's `apio-definitions.proto`.

## Testing definition changes

`test_examples.py` checks the examples' boards against the definitions of the **installed** Apio package (`apio api get-boards`), not against the files in this repo. To test a change to the definitions locally, first copy `definitions/*` into the installed package's `definitions` dir, as CI does. To find that dir, run `apio api get-system` and look for the key `apio-packages-dir`.
