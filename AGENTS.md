# Repository Guidelines

## Project Structure & Module Organization

This repository builds an iOS package repo and Jekyll site. Bazel configuration lives in `MODULE.bazel`, `BUILD.bazel`, and package-local `BUILD.bazel` files. Package source assets are under `packages/<bundle-id>/src`, with package metadata in each package's `DEBIAN/control`. The published site and repo index live under `jekyll/`, including `_packages`, `_changelogs`, `debs/`, Sass, layouts, and images. Shared Bazel helpers are in `tools/`; Python test utilities are in `tools/python/`.

## Build, Test, and Development Commands

- `bazelisk build //...`: build all Bazel targets.
- `bazelisk test //...`: run the full test suite, including Python and generated-file checks.
- `bazelisk run //:gazelle`: regenerate Bazel BUILD metadata.
- `bazelisk run //:gazelle_python_manifest.update`: refresh `gazelle_python.yaml` after Python dependency changes.
- `bazelisk run //:py_requirements.update`: refresh `py_requirements_lock.txt` from `py_requirements.in`.
- `bundle exec jekyll build`: build the Jekyll site locally.
- `./png_compress.sh`: compress image assets when adding or replacing PNGs.

Enable repository hooks with `git config core.hooksPath .githooks`; the pre-commit hook regenerates `jekyll/Packages` and `jekyll/Packages.gz`.

## Coding Style & Naming Conventions

Use 4-space indentation for Bazel/Starlark and Python. Python tooling is configured in `pyproject.toml`; Ruff uses a 120-character line length and Pyright excludes generated/cache paths. Keep package directory names aligned with bundle IDs, for example `packages/com.cj81499.cjglyphs`. Prefer generated updates through Bazel targets over hand-editing generated locks or manifests.

## Testing Guidelines

Add or update tests for behavior changes under the relevant Bazel package. Python tests use `pytest` and should be named `*_test.py` or exposed through a Bazel `py_test`. Run `bazelisk test //...` before opening PRs, especially after dependency, BUILD, package metadata, or generated-file changes.

## Commit & Pull Request Guidelines

History uses short imperative commit subjects, such as `upgrade gazelle to 0.51.0` or `use uv in .envrc`. Keep commits focused and avoid mixing generated package index churn with unrelated changes. PRs should describe the change, list verification commands, and mention generated files intentionally updated. Include screenshots only for visible Jekyll/site changes.

## Agent-Specific Instructions

Respect existing generated files: regenerate them with the documented commands and commit only expected diffs. When committing with Git, be aware the pre-commit hook may update `jekyll/Packages`; skip hooks only when intentionally keeping unrelated generated index files out of a focused change.
