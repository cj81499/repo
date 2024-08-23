from pathlib import Path

from python.runfiles import Runfiles

# FIXME: https://github.com/bazelbuild/rules_python/issues/1679
# from rules_python.python.runfiles import runfiles

_RUNFILES = Runfiles.Create()


def locate(path: str | Path, workspace: str = "__main__") -> Path:
    if not isinstance(path, Path):
        path = Path(path)

    if path.is_absolute():
        msg = f"{path=} must be a relative path"
        raise ValueError(msg)

    located = _RUNFILES.Rlocation(f"{workspace}/{path}")
    if located is None:
        msg = f"Failed to locate data-dependency. {path=} {workspace=}"
        raise ValueError(msg)

    pth = Path(located)
    if not pth.exists():
        msg = f"Located data-dependency does not exist. {located=} {path=} {workspace=}"
        raise ValueError(msg)

    return pth
