# Contributing

## Setup

Use the Bazel version pinned in [.bazelversion](.bazelversion). If you use
`bazelisk`, it will pick that up automatically.

This repo also uses a git hook for package metadata:

```shell
git config core.hooksPath .githooks
```

## Tooling Prereqs

You will need the tools used by the repo scripts and generated-file workflows:

- `bazelisk`
- `ruby` and `bundler`
- `dpkg-deb`, `dpkg-scanpackages`, and `gzip`
- `ImageMagick` if you want to use package-local image helper scripts such as
  `packages/com.cj81499.cjglyphs/invert.sh`

## Common Commands

Build and test the repo with Bazel:

```shell
bazel build //...
bazel test //...
```

Create package artifacts with:

```shell
./ez_pkg.sh
```

## Repo Layout

- `packages/` holds the package definitions and their payload files.
- `jekyll/` holds the site content and package index files.
- `tools/` holds Bazel targets for repo-local helper tools.
- Shell scripts in this repo are generally written for POSIX `sh`.

## Generated Files

Keep generated files in sync when you touch the inputs that produce them:

- `jekyll/Packages` and `jekyll/Packages.gz` are maintained by the pre-commit
  hook in [.githooks/pre-commit](.githooks/pre-commit).
- `py_requirements_lock.txt` comes from `//:py_requirements` and can be
  regenerated with:

  ```shell
  bazel run //:py_requirements.update
  ```

- `gazelle_python_manifest` can be updated with `bazel run //:gazelle_python_manifest.update`.

If you change a package under `packages/`, rebuild it with `./packages/pkg.sh`
and make sure its `src/DEBIAN/control` file and payload layout still match the
package metadata expected by the packaging script.

The package workflow is:

```shell
./packages/pkg.sh packages/<package-name> jekyll/debs
```

That creates a `.deb` in `jekyll/debs/`, and the pre-commit hook regenerates
`jekyll/Packages` and `jekyll/Packages.gz` from that directory.

## Site Changes

The GitHub Pages site is built from the `jekyll/` tree on `main`.

If you change site content, build it locally with:

```shell
bundle exec jekyll build
```

To serve it locally while iterating, use:

```shell
bundle exec jekyll serve
```

Make sure the generated package index and site assets still look correct.

## Optimizing PNGs

PNG files should be optimized with the repository-managed `oxipng` target before
they are committed. This keeps local optimization and CI using the same tool and
flags.

To optimize one or more PNG files:

```shell
bazel run //tools:oxipng -- -o max --strip safe -- path/to/image.png
```

You can pass multiple files in the same command:

```shell
bazel run //tools:oxipng -- -o max --strip safe -- path/to/first.png path/to/second.png
```

To optimize every PNG under a directory tree, pass the directory and use
`--recursive`:

```shell
bazel run //tools:oxipng -- -o max --strip safe -- --recursive .
```

After running `oxipng`, review the changes and commit any optimized PNG files.
Pull requests run the same optimization check on changed PNGs and fail if
`oxipng` can still reduce them.

## Before Opening a PR

- Run `bazel test //...` for code changes.
- Follow the site build or serve commands in [Site Changes](#site-changes) for site edits.
- Optimize any changed PNGs with `oxipng`.
- Make sure generated files are updated if you touched their inputs.
