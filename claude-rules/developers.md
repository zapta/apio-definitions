# Developer tools

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

This repo has a few Python tools for testing and maintaining the examples: Invoke tasks in `tasks.py`, and scripts in `scripts/`. Run the scripts from the repo root, since they use paths relative to the current dir. The Invoke tasks can run from any dir in the repo.

## Invoke tasks (`tasks.py`)

`tasks.py` is modeled on the one in the Apio repo. It needs Invoke (`pip install invoke`). Run `invoke --list` to see the tasks, and `invoke --dry <task>` to print a task's commands without running them.

| Task | Alias | What it does |
|---|---|---|
| `invoke lint` | `l` | Formats the Python code in `scripts/` and `tasks.py` with black, then checks it with pylint and mypy. |
| `invoke test` | `t` | Runs `test_examples.py` on the examples picked by the current dir (see below). Option `--examples-root <dir>` tests the examples in another dir. |
| `invoke format` | `f` | Runs `apio format` in every example, which formats the Verilog with Verible. |
| `invoke copy-common` | `cc` | Runs `copy_common_examples_files.py`. Option `--dry-run` shows what would change without changing anything. |
| `invoke clean` | `c` | Runs `apio clean` in every example, deletes the common files from the examples (`copy_common_examples_files.py --clean`), and deletes the `.mypy_cache` and `__pycache__` dirs. |

`invoke test` decides what to test from the dir it runs in:

| Run from | Tests |
|---|---|
| A board dir (`examples/<board>`) | That board's examples |
| An example dir (`examples/<board>/<example>`) or a dir inside it | That example |
| Anywhere else | All the examples |

## Scripts (`scripts/`)

**`test_examples.py`** tests the examples. With no options it tests all of them. Options:
- `--example <board>` tests one board's examples, and `--example <board>/<example>` tests one example.
- `--examples-root <dir>` tests the examples in another dir.

For each env of each example, it runs `apio build`, `lint`, `lint --nosynth`, `graph`, `report`, `test`, `sim --no-gtkwave`, `format`, and `apio api` commands. It stops at the first failure.

To check one example by hand, `cd examples/<board>/<example>` and run the same `apio` commands, e.g. `apio build -e <env>`, `apio test`, `apio format`.

**`copy_common_examples_files.py`** copies the shared files into every example (see "Common example files" below). Option `--dry-run` shows what would change, and `--clean` removes the copied files.

## Deleting files in Python code

Before `tasks.py` or a script in `scripts/` deletes a file or dir, it must check that the path is inside this repo and isn't the repo root. Use the `delete_path()` helper in `tasks.py` or in `copy_common_examples_files.py`, which does this check. Don't call `shutil.rmtree()` or `unlink()` directly.

## Common example files

Some files are the same in every example: a `.gitignore` and a `.vscode/` dir. They are kept once in `common-examples-files/` and are not committed into each example. `copy_common_examples_files.py` copies them into every example at CI and package-build time. To change them, edit `common-examples-files/`, not the copies in the examples.

## CI (`.github/workflows/`)

| Workflow | Runs | What it does |
|---|---|---|
| `test.yaml` | On push, on PRs, and daily, on Linux, macOS and Windows | Installs the dev version of Apio, overwrites the installed package's definitions and examples with this repo's, then runs `test_examples.py` against the installed copy. |
| `build-pre-release.yaml` | Daily, and manually | Packages `definitions/*`, `examples/`, `LICENSE` and `BUILD-INFO.json` into `apio-definitions-<tag>.tgz` and publishes it as a GitHub pre-release, using shared actions from `fpgawars/apio-workflows`. |

## Line endings

`.gitattributes` forces LF line endings for `*.v`, `*.vh`, `*.sv` and `*.svh` files, because Verible's formatter fails on CRLF files that use `// verilog_format: off`.
