import sys

import pytest

from tools import runfiles


def test_runfiles_happy():
    data = runfiles.locate("tools/runfiles/runfiles_test_data.txt")
    assert data.read_text() == "Hello, world!\n"


def test_runfiles_error():
    to_locate = "tools/runfiles/does_not_exist.txt"
    with pytest.raises(
        ValueError,
        match=r"^Located data-dependency does not exist.",
    ):
        runfiles.locate(to_locate)


if __name__ == "__main__":
    sys.exit(pytest.main(sys.argv))
