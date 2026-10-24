"""Tasks definitions for the 'invoke' command."""

# To install 'invoke' run: pip install invoke
#
# A few useful Invoke tasks
#   invoke --list         # Show available tasks
#   invoke -l             # Show available tasks
#   invoke lint           # Format and lint the python code.
#   invoke test           # Test all the examples.
#   invoke format         # Format the examples' Verilog files.
#   invoke copy-common    # Copy the common files into every example.
#   invoke clean          # Clean the examples and other temporary files.

#  NOTE: The shortcut 'inv' can be used instead of 'invoke'.

import sys
import os
from os import sep
from pathlib import Path
import shutil
import subprocess
from subprocess import CompletedProcess
from importlib.metadata import version, PackageNotFoundError
from invoke.tasks import task
from invoke.context import Context

# ========================== Helper definitions ===============================


# -- NOTE: The first sentence of a task docstring is also its help string
# -- which is printed when running 'invoke --list'.

# -- The python interpreter that we currently use.
PYTHON = sys.executable


def package_version(package_name: str) -> str | None:
    """Get the version of installed package or None if not installed."""
    try:
        return version(package_name)
    except PackageNotFoundError:
        return None


def install_package(package_name: str, required_version: str) -> None:
    """If the package/version is not installed then install it. Otherwise
    do nothing."""
    # -- Update if needed.
    if package_version(package_name) != required_version:
        print(f"\n*** Auto installing {package_name}@{required_version} ***")
        subprocess.check_call(
            [
                sys.executable,
                "-m",
                "pip",
                "install",
                "--force-reinstall",
                f"{package_name}=={required_version}",
            ]
        )

    # -- Verify.
    assert (
        package_version(package_name) == required_version
    ), f"Expected to find {package_name}=={required_version}"


DEPENDENCIES = [
    ("rich", "14.0.0"),
    ("black", "25.1.0"),
    ("pylint", "3.3.7"),
    ("mypy", "2.3.1"),
]


def install_dependencies():
    """Install any dependency that is missing or has a different version."""
    for package_name, required_version in DEPENDENCIES:
        install_package(package_name, required_version)


# -- Make sure required python dependencies are installed.
install_dependencies()


# -- Now that Rich is installed, we can import and use it.
# pylint: disable=wrong-import-position
from rich.console import Console

# -- For outputting via Rich. The regular rich.print() doesn't not allow to
# -- disable markup.
console = Console()


def cout(*args, markup=False, highlight=False, **kwargs):
    """A shortcut for Rich lib console.print()."""
    console.print(*args, markup=markup, highlight=highlight, **kwargs)


def announce_task(task_name: str) -> None:
    """Prints a message saying that the task is starting."""
    cout(
        f"Executing Apio definitions dev task: {task_name}",
        style="magenta bold",
    )


def get_repo_root() -> Path:
    """Return the root of the local apio definitions github repository."""
    # -- Return the directory that contains this file.
    return Path(__file__).resolve().parent


def delete_path(path: Path) -> None:
    """Delete a file or a directory tree. The path must be inside the repo.
    Use this for every delete in this file."""
    # -- Safety check. Resolve the parent dirs but not the item itself, so
    # -- a symlink is checked (and deleted) as a link.
    repo_root = get_repo_root()
    real_path = path.parent.resolve() / path.name
    assert (
        real_path.is_relative_to(repo_root) and real_path != repo_root
    ), f"Refusing to delete {real_path}, it's not inside {repo_root}"

    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def get_example_dirs() -> list[Path]:
    """Return the dirs of all the examples, sorted. Examples are at
    examples/<board>/<example>."""
    examples_dir = get_repo_root() / "examples"
    assert examples_dir.is_dir(), examples_dir
    return sorted(
        example_dir
        for board_dir in examples_dir.iterdir()
        if board_dir.is_dir()
        for example_dir in board_dir.iterdir()
        if example_dir.is_dir()
    )


def run(ctx: Context, cmd: list[str], cwd: Path | None = None) -> None:
    """Run a command, in dir 'cwd' if specified. Abort if it returns an
    error code."""
    dry_run: bool = ctx.config.run.dry
    prefix = "DRY: " if dry_run else ""
    # -- Show the dir relative to the repo root, e.g. [examples/x/y].
    where = f"[{cwd.relative_to(get_repo_root()).as_posix()}] " if cwd else ""
    cout(f"{prefix}{where}{' '.join(cmd)}", style="cyan")
    if not dry_run:
        result: CompletedProcess = subprocess.run(cmd, cwd=cwd, check=False)
        if result.returncode != 0:
            cout("Command failed.", style="red bold")
            sys.exit(1)


# ===================== Tasks definitions start here ==========================


@task(name="lint", aliases=["l"])
def lint_task(ctx: Context):
    """Format and lint the python code."""
    announce_task("lint")
    # -- Paths are relative to the repo root.
    os.chdir(get_repo_root())
    lint_items = ["scripts", "tasks.py"]
    run(ctx, [PYTHON, "-m", "black", "--line-length", "79", *lint_items])
    run(ctx, [PYTHON, "-m", "pylint", *lint_items])
    run(ctx, [PYTHON, "-m", "mypy", *lint_items])
    if not ctx.config.run.dry:
        cout("Lint passed.", style="green bold")


@task(
    name="test",
    aliases=["t"],
    help={
        "examples_root": "Test the examples in this dir instead of the "
        "repo's examples dir.",
        "example": "Test only this board (e.g. alhambra-ii) or this "
        "example (e.g. alhambra-ii/blinky).",
    },
)
def test_task(
    ctx: Context,
    examples_root: str | None = None,
    example: str | None = None,
):
    """Test all the examples."""
    announce_task("test")
    cmd = [PYTHON, f"scripts{sep}test_examples.py"]
    if examples_root:
        # -- Make it absolute before we change the current dir.
        cmd += ["--examples-root", str(Path(examples_root).absolute())]
    if example:
        cmd += ["--example", example]
    # -- The scripts use paths relative to the repo root.
    os.chdir(get_repo_root())
    run(ctx, cmd)
    if not ctx.config.run.dry:
        cout("All examples passed.", style="green bold")


@task(name="format", aliases=["f"])
def format_task(ctx: Context):
    """Format the examples' Verilog files with 'apio format'."""
    announce_task("format")
    for example_dir in get_example_dirs():
        run(ctx, ["apio", "format"], cwd=example_dir)
    if not ctx.config.run.dry:
        cout("All examples formatted.", style="green bold")


@task(
    name="copy-common",
    aliases=["cc"],
    help={
        "dry_run": "Show what would change without changing anything.",
    },
)
def copy_common_task(ctx: Context, dry_run=False):
    """Copy the common files into every example."""
    announce_task("copy-common")
    # -- The scripts use paths relative to the repo root.
    os.chdir(get_repo_root())
    cmd = [PYTHON, f"scripts{sep}copy_common_examples_files.py"]
    if dry_run:
        cmd.append("--dry-run")
    run(ctx, cmd)


@task(name="clean", aliases=["c", "cl"])
def clean_task(ctx: Context):
    """Clean the examples' build output, common files and temporary files."""
    announce_task("clean")
    repo_root = get_repo_root()
    assert isinstance(repo_root, Path)

    # -- The scripts use paths relative to the repo root.
    os.chdir(repo_root)

    # -- Run 'apio clean' in each example.
    for example_dir in get_example_dirs():
        run(ctx, ["apio", "clean"], cwd=example_dir)

    # -- Delete the common files that 'invoke copy-common' copied into
    # -- the examples.
    run(ctx, [PYTHON, f"scripts{sep}copy_common_examples_files.py", "--clean"])

    # -- Collect other items to delete.
    items: list[Path] = []
    # -- Collect top level items first so they will be deleted first.
    items.extend(repo_root.glob(".mypy_cache"))
    # -- Collect nested items
    items.extend(repo_root.rglob("__pycache__"))

    if not items:
        print("No other items to delete.")
        return

    dry_run: bool = ctx.config.run.dry
    print("Would delete:" if dry_run else "Deleting:")

    for item in items:
        # -- E.g. if we hit a __pycache__ under .mypy_cache but already
        # -- deleted .mypy_cache.
        if not item.exists():
            continue

        description = "{repo}/" + str(item.relative_to(repo_root))
        print(f"[{'d' if item.is_dir() else 'f'}] {description}")
        if not dry_run:
            delete_path(item)
