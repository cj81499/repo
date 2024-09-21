import os
import textwrap
from collections.abc import Sequence
from pathlib import Path

import click
import pydpkg.dpkg


@click.command()
@click.argument(
    "output-path",
    type=click.Path(
        file_okay=True,
        dir_okay=False,
        writable=True,
        path_type=Path,
    ),
)
@click.argument(
    "relative-to",
    required=True,
    type=click.Path(
        exists=True,
        file_okay=False,
        dir_okay=True,
        path_type=Path,
    ),
)
@click.option(
    "--package",
    "package_paths",
    type=click.Path(
        exists=True,
        file_okay=True,
        dir_okay=False,
        readable=True,
        path_type=Path,
    ),
    multiple=True,
    required=True,
)
def main(
    *,
    output_path: Path,
    relative_to: Path,
    package_paths: Sequence[Path],
) -> None:
    """
    Python implementation of (some of) dpkg-scanpackages
    """

    with output_path.open("w") as f:
        for package_path in sorted(package_paths):
            pkg = pydpkg.dpkg.Dpkg(package_path)
            f.write(
                textwrap.dedent(
                    f"""
                    Package: {pkg.headers["Package"]}
                    Version: {pkg.headers["Version"]}
                    Architecture: {pkg.headers["Architecture"]}
                    Maintainer: {pkg.headers["Maintainer"]}
                    Depends: {pkg.headers["Depends"]}
                    Filename: ./{package_path.relative_to(relative_to)}
                    Size: {pkg.filesize}
                    MD5sum: {pkg.md5}
                    SHA1: {pkg.sha1}
                    SHA256: {pkg.sha256}
                    Section: {pkg.headers["Section"]}
                    Description: {pkg.headers["Description"]}
                    Author: {pkg.headers["Author"]}
                    Depiction: {pkg.headers["Depiction"]}
                    Name: {pkg.headers["Name"]}
                    """.strip("\n")
                )
            )
            f.write("\n")


if __name__ == "__main__":
    if (build_working_dir := os.getenv("BUILD_WORKING_DIRECTORY")) is not None:
        os.chdir(build_working_dir)
    main()
