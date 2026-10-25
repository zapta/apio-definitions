# CLAUDE.md

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

The source of the `definitions` package of [Apio CLI](https://github.com/FPGAwars/apio). It has no application code. It holds data files (board definitions, programmer definitions, an FPGA definitions override file) and example FPGA projects laid out as `examples/<board>/<example-name>/`, which Apio downloads as a package. The Python under `scripts/` is only tooling to test and maintain the examples. Apio's general documentation (commands, project file, boards, etc.) is at https://fpgawars.github.io/apio/docs/. Check it when you're unsure how an `apio` command or option behaves. All work needs the `apio` CLI installed (`pip install git+https://github.com/fpgawars/apio.git` then `apio packages install`).

## Rules by topic

- Examples (layout, `apio.ini`, Verilog design, constraint files, testbenches, GTKWave files): @claude-rules/examples.md
- Definitions (`boards.jsonc`, `programmers.jsonc`, `fpgas.jsonc`): @claude-rules/definitions.md
- Developers (Invoke tasks, scripts, common example files, CI): @claude-rules/developers.md

## Private rules

Each developer can keep their own rules in `CLAUDE.local.md` at the repo root. It is gitignored, so it stays on their machine, and Claude Code loads it automatically together with this file. Use it for personal preferences that shouldn't apply to other contributors. Private rules may add to the public rules but must not contradict them. If a private rule conflicts with a public rule, don't follow either one and don't continue the task. Stop and report an error that quotes both rules and their files, and ask the developer to fix `CLAUDE.local.md`.
