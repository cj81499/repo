import ast
import sys
from pathlib import Path

import pytest


class PythonVersionFinder(ast.NodeVisitor):
    def __init__(self):
        self.version = None

    def visit_Assign(self, node: ast.Assign) -> None:
        match node:
            case ast.Assign(
                targets=[ast.Name(id="PY_VERSION")],
                value=ast.Constant(value=str(py_version)),
            ):
                self.version = py_version


def test_version():
    # read version from MODULE.bazel
    module_bazel_contents = Path("MODULE.bazel").read_text()
    parsed = ast.parse(module_bazel_contents)
    pvf = PythonVersionFinder()
    pvf.visit(parsed)
    py_version = pvf.version
    assert py_version is not None, "PY_VERSION assignment not found in MODULE.bazel"

    # Compare against current runtime major.minor.patch version (eg: 3.14.2)
    assert sys.version_info[:3] == tuple(map(int, py_version.split(".")))


if __name__ == "__main__":
    # raise SystemExit(1)
    raise SystemExit(pytest.main(sys.argv))
